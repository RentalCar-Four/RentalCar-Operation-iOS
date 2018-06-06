//
//  XDYScanController.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYScanController.h"
#import <AVFoundation/AVFoundation.h>
#import "XDYScanInfoController.h"
#import "InputNumberView.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "TipUtil.h"

@interface XDYScanController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
    
    NSString *pileStrValue;
    NSArray *stationAndPileID;
    UIView *_boxView;
    UIImageView *_scanLayer;
    BOOL isOpenDoor;    // 桩门是否开启
    BOOL isRenting;     // 被扫描的车是否自己租赁中
    BOOL sgdIsOpen;     // 闪光灯
}
@end

@implementation XDYScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫码用车";
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 7, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    CGAffineTransform transform =CGAffineTransformMakeRotation(-M_PI/2);
    [backBtn setTransform:transform];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navItem.rightBarButtonItem = backItem;
    
    // 参照扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-autoScaleW(115), autoScaleH(255), autoScaleW(230), autoScaleW(220))];
    [self.view addSubview:_boxView];
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setRectOfInterest:CGRectMake((124)/kScreenHeight, (( kScreenWidth-220)*.5)/kScreenWidth, 220/kScreenHeight, 220/kScreenWidth)];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:_input])
    {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output])
    {
        [_session addOutput:_output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // 蒙版和框
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scan"]];
    
    _scanLayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _boxView.width, _boxView.height)];
    [_boxView addSubview:_scanLayer];

    bgView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:bgView];
    
    // 提示
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, autoScaleH(192), kScreenWidth, 30)];
    lab.text = @"请扫描车身二维码";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:lab];
    
    // 闪光灯开关按钮
    UIButton *sgdBut = [UIButton buttonWithType:UIButtonTypeCustom];
    sgdBut.frame = CGRectMake(autoScaleW(80), kScreenHeight-autoScaleH(170), 80, autoScaleH(80));
    [sgdBut setTitle:@"点击照亮" forState:UIControlStateNormal];
    [sgdBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sgdBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [sgdBut setImage:[UIImage imageNamed:@"btn_light_off"] forState:UIControlStateNormal];
    [sgdBut setImageEdgeInsets:UIEdgeInsetsMake(0.0, autoScaleW(20), autoScaleH(20), 0.0)];
    [sgdBut setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -autoScaleW(40), -autoScaleH(60), 0.0)];
    [sgdBut addTarget:self action:@selector(sgdAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sgdBut];
    
    // 输入车牌
    UIButton *inputBut = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBut.frame = CGRectMake(kScreenWidth-autoScaleW(80)-80, kScreenHeight-autoScaleH(170), 80, autoScaleH(80));
    [inputBut setTitle:@"确认车牌" forState:UIControlStateNormal];
    [inputBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inputBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [inputBut setImage:[UIImage imageNamed:@"btn_input"] forState:UIControlStateNormal];
    [inputBut setImageEdgeInsets:UIEdgeInsetsMake(0.0, autoScaleW(20), autoScaleH(20), 0.0)];
    [inputBut setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -autoScaleW(40), -autoScaleH(60), 0.0)];
    [inputBut addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputBut];
    
    [APPUtil runAnimationWithCount:46 name:@"motion_QrScan00" imageView:_scanLayer repeatCount:0 animationDuration:0.03];

    [_session startRunning];
    
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sgdAction:(UIButton *)but
{
    sgdIsOpen = !sgdIsOpen;
    // 打开闪光灯
    // Start session configuration
    [_session beginConfiguration];
    [_device lockForConfiguration:nil];
    
    if (sgdIsOpen) {
        // Set torch to on
        [_device setTorchMode:AVCaptureTorchModeOn];
        [but setTitle:@"点击熄灭" forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"btn_light_on"] forState:UIControlStateNormal];
    } else {
        // Set torch to off
        [_device setTorchMode:AVCaptureTorchModeOff];
        [but setTitle:@"点击照亮" forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"btn_light_off"] forState:UIControlStateNormal];
    }
    
    [_device unlockForConfiguration];
    [_session commitConfiguration];
}

//输入车牌
- (void)inputAction:(UIButton *)but
{
    
//    [APPUtil showToast:@"敬请期待"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithPost:getNumberPlatePrefix() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        NSDictionary *result = [data objectForKey:@"result"];
        NSArray *list = result[@"list"];
        
        if (list.count>0) {
            [_session stopRunning];
            [_scanLayer stopAnimating];
            
            InputNumberView *inputNumberView = [[InputNumberView alloc] init];
            [self.view addSubview:inputNumberView];
            inputNumberView.array = list;
            
            inputNumberView.closeBlock = ^(){
                [_scanLayer startAnimating];
                [_session startRunning];
            };
            
            inputNumberView.doneBlock = ^(NSString *value){
                
                [self.backDelegate backAction:value];
                [self dismissViewControllerAnimated:YES completion:nil];
            };
        }
        
    } failure:^(NSString *content) {
 
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0)
    {
        // 停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        pileStrValue = metadataObject.stringValue;
        
        if ([pileStrValue containsString:@","]) {
            stationAndPileID = [pileStrValue componentsSeparatedByString:@","];
        } else if ([pileStrValue containsString:@"，"]) {
            stationAndPileID = [pileStrValue componentsSeparatedByString:@"，"];
        }
        
        //NSLog(@"二维码字符串：%@", pileStrValue);
        
        // 车架号
        if (pileStrValue.length == 17) {
            
            [self.backDelegate backAction:pileStrValue];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else if ([pileStrValue rangeOfString:@"http://"].location != NSNotFound || [pileStrValue rangeOfString:@"https://"].location != NSNotFound) {
            
            //打开浏览器
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pileStrValue]];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            XDYScanInfoController *scanInfoVC = [[XDYScanInfoController alloc] init];
            scanInfoVC.infoString = pileStrValue;
            [self.navigationController pushViewController:scanInfoVC animated:YES];
        }
        // 移除扫描视图
        _preview = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
