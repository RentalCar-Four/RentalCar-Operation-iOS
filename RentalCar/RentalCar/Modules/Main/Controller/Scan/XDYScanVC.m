//
//  XDYScanVC.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/10.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYScanVC.h"
#import "XDYScanInfoVC.h"
#import "InputNumberView.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "TipUtil.h"
#import <AudioToolbox/AudioToolbox.h>

@interface XDYScanVC ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIView *_boxView;
    UIImageView *_scanAnniView;
    
    UIButton *sgdBut; //闪光灯按钮
    UIButton *sgdTxtBut;
    
    BOOL sgdIsOpen; // 闪光灯
    NSString *pileStrValue;
    NSInteger flag; //1、车架号；2、车牌号；3、code码
}
@end

@implementation XDYScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫码用车";
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    [self initNav];
    [self initView];
    
    [self setupCamera];
}

- (void)initNav {
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 7, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    CGAffineTransform transform =CGAffineTransformMakeRotation(-M_PI/2);
    [backBtn setTransform:transform];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navItem.rightBarButtonItem = backItem;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView {
    
    _scanAnniView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-autoScaleW(115), autoScaleH(255), autoScaleW(230), autoScaleW(220))];
    [self.view addSubview:_scanAnniView];
    
    // 蒙版和框
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    bgView.image = [UIImage imageNamed:@"img_scan"];
    [self.view addSubview:bgView];
    
    // 提示
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, autoScaleH(192), kScreenWidth, 30)];
    lab.text = @"请扫描车身二维码";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:lab];
    
    // 闪光灯开关按钮
    sgdBut = [UIButton buttonWithType:UIButtonTypeCustom];
    sgdBut.frame = CGRectMake(autoScaleW(80), kScreenHeight-autoScaleH(170), autoScaleW(80), autoScaleH(60));
    [sgdBut setImage:[UIImage imageNamed:@"btn_light_off"] forState:UIControlStateNormal];
    [sgdBut addTarget:self action:@selector(sgdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sgdBut];
    
    sgdTxtBut = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(80), sgdBut.bottom, autoScaleW(80), autoScaleH(20))];
    sgdTxtBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [sgdTxtBut setTitle:@"点击照亮" forState:UIControlStateNormal];
    [sgdTxtBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sgdTxtBut addTarget:self action:@selector(sgdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sgdTxtBut];
    
    // 输入车牌
    UIButton *inputBut = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBut.frame = CGRectMake(kScreenWidth-autoScaleW(80)-autoScaleW(80), kScreenHeight-autoScaleH(170), autoScaleW(80), autoScaleH(60));
    [inputBut setImage:[UIImage imageNamed:@"btn_input"] forState:UIControlStateNormal];
    [inputBut addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputBut];
    
    UIButton *inputTxtBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-autoScaleW(80)-autoScaleW(80), inputBut.bottom, autoScaleW(80), autoScaleH(20))];
    inputTxtBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [inputTxtBut setTitle:@"输入车牌" forState:UIControlStateNormal];
    [inputTxtBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputTxtBut addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputTxtBut];
    
    [APPUtil runAnimationWithCount:46 name:@"motion_QrScan00" imageView:_scanAnniView repeatCount:0 animationDuration:0.03];
}

- (void)sgdAction
{
    sgdIsOpen = !sgdIsOpen;
    // 打开闪光灯
    // Start session configuration
    [_session beginConfiguration];
    [self.camera lockForConfiguration:nil];
    
    if (sgdIsOpen) {
        // Set torch to on
        [self.camera setTorchMode:AVCaptureTorchModeOn];
        [sgdTxtBut setTitle:@"点击熄灭" forState:UIControlStateNormal];
        [sgdBut setImage:[UIImage imageNamed:@"btn_light_on"] forState:UIControlStateNormal];
    } else {
        // Set torch to off
        [self.camera setTorchMode:AVCaptureTorchModeOff];
        [sgdTxtBut setTitle:@"点击照亮" forState:UIControlStateNormal];
        [sgdBut setImage:[UIImage imageNamed:@"btn_light_off"] forState:UIControlStateNormal];
    }
    
    [self.camera unlockForConfiguration];
    [_session commitConfiguration];
}

//输入车牌
- (void)inputAction:(UIButton *)but
{
    [StatisticsClass eventId:YC01];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithPost:getNumberPlatePrefix() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        [JHHJView hideLoading];
        
        NSDictionary *result = [data objectForKey:@"result"];
        NSArray *list = result[@"list"];
        
        if (list.count>0) {
            [_session stopRunning];
            [_scanAnniView stopAnimating];
            
            InputNumberView *inputNumberView = [[InputNumberView alloc] init];
            [self.view addSubview:inputNumberView];
            inputNumberView.array = list;
            
            inputNumberView.closeBlock = ^(){
                [_scanAnniView startAnimating];
                [_session startRunning];
            };
            
            inputNumberView.doneBlock = ^(NSString *value){
                
                [self.backDelegate backAction:value andFlag:2];
                [self dismissViewControllerAnimated:YES completion:nil];
            };
        }
        
    } failure:^(NSString *content) {
        
        [JHHJView hideLoading];
    }];
}

-(void)setupCamera
{
    self.camera=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input=[AVCaptureDeviceInput deviceInputWithDevice:self.camera error:nil];
    self.output=[[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session=[[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    self.preView=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preView.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.preView.frame=self.view.bounds;
    [self.view.layer insertSublayer:self.preView atIndex:0];
    
    //条码类型,人脸
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeFace,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode];
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.session startRunning];
                   });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.session&&![self.session isRunning])
    {
        [self.session startRunning];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.session stopRunning];
    self.session = nil;
    [self.preView removeFromSuperlayer];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0)
    {
        // 停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        if (![metadataObject respondsToSelector:@selector(stringValue)]) {
            return;
        }
        pileStrValue = [NSString stringWithFormat:@"%@",metadataObject.stringValue];
        
//        NSLog(@"二维码字符串前：%@", pileStrValue);
        
        if (pileStrValue.length == 17) {
            flag = 1;
        }
        
        if ([pileStrValue containsString:@"code/"]) {
            NSArray *array = [pileStrValue componentsSeparatedByString:@"code/"];
            pileStrValue = array[1];
            flag = 3;
        }
        
        if ([pileStrValue containsString:@"vin="]) {
            NSArray *array = [pileStrValue componentsSeparatedByString:@"vin="];
            pileStrValue = array[1];
            flag = 1;
        }
        
//        NSLog(@"二维码字符串后：%@", pileStrValue);
        
        //手机震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // 车架号
        if ((flag == 1 & pileStrValue.length == 17) || flag == 3) { //车架号或者code码
            
            [self.backDelegate backAction:pileStrValue andFlag:flag];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [APPUtil showToast:@"二维码与车辆不匹配"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
//        else if ([pileStrValue rangeOfString:@"http://"].location != NSNotFound || [pileStrValue rangeOfString:@"https://"].location != NSNotFound) {
//            
//            //打开浏览器
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pileStrValue]];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        } else {
//            
//            XDYScanInfoVC *scanInfoVC = [[XDYScanInfoVC alloc] init];
//            scanInfoVC.infoString = pileStrValue;
//            [self.navigationController pushViewController:scanInfoVC animated:YES];
//        }
        // 移除扫描视图
        self.preView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
