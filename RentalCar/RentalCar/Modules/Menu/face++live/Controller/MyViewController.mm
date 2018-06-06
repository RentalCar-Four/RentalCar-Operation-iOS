//
//  MyViewController.m
//  MegLiveDemo
//
//  Created by 张英堂 on 16/6/8.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import "MyViewController.h"
#import "MyBottomView.h"
#import "MyFinishViewController.h"
#import "CircleView.h"

#define IS_SYSTERM YES

@interface MyViewController ()
@property(nonatomic,strong)CircleView *titleView;
@property(nonatomic,strong)MGVideoManager *videoManager;
@property(nonatomic,strong)UIView *nav;
@property(nonatomic,strong)UIButton * startScnBtn;
@end

@implementation MyViewController
@dynamic videoManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //    if (IS_SYSTERM) {
    //        MGLiveManager *liveManager = [[MGLiveManager alloc] init];
    //        liveManager.actionCount = 1;
    //        liveManager.actionTimeOut = 10;
    //        liveManager.randomAction = NO;
    //        liveManager.actionArray = @[@(1)];
    //        [liveManager startFaceDecetionViewController:self finish:^(FaceIDData *finishDic, UIViewController *viewController) {
    //
    //            [viewController dismissViewControllerAnimated:YES completion:nil];
    //            NSData *resultData = [[finishDic images] valueForKey:@"image_best"];
    ////            UIImage *resultImage = [UIImage imageWithData:resultData];
    //            if ([self.LivingDelegate respondsToSelector:@selector(onData:)]) {
    //
    //                [self.LivingDelegate onData:finishDic];
    //            }
    //        }
    //       error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
    //        //   button.userInteractionEnabled = YES;
    //        [viewController dismissViewControllerAnimated:YES completion:nil];
    //        //       [self showErrorString:errorType];
    //        //       [self.messageLabel setTextColor:[UIColor redColor]];
    //         }];
    //    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defaultSetting{
    
    
    if (self.liveManager == nil && self.self.videoManager == nil) {
        
        MGLiveActionManager *ActionManager = [MGLiveActionManager LiveActionRandom:NO actionArray:@[@(DETECTION_TYPE_BLINK)] actionCount:1];
        
        //调整检测区域
        MGLiveErrorManager *errorManager = [[MGLiveErrorManager alloc] initWithFaceCenter:CGPointMake(0.5, 0.5)];
        
        self.videoManager = [MGVideoManager videoPreset:AVCaptureSessionPreset640x480
                                         devicePosition:AVCaptureDevicePositionFront
                                            videoRecord:NO
                                             videoSound:NO];
        
        MGLiveDetectionManager *liveManager = [[MGLiveDetectionManager alloc]initWithActionTime:8
                                                                                  actionManager:ActionManager
                                                                                   errorManager:errorManager];
        
        
        [self setLiveManager:liveManager];
        [self setVideoManager:self.videoManager];
    }
}

//创建界面
-(void)creatView{
    
    [self setUpTopView];
    UIView *navTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44+StatusBarHeight)];
    navTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navTitleView];
    
    
    UIView *circleViewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 44+StatusBarHeight, SCREEN_WIDTH, 0)];
    circleViewBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:circleViewBG];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    
    _titleView = [[CircleView alloc]init];
    
    _titleView.tagS = 3;
    _titleView.tagH = 2;
    
    [_titleView setFrame:CGRectMake(autoScaleW(kScreenWidth/2 -(kScreenWidth-15)/2), NVBarAndStatusBarHeight+15,kScreenWidth-15, autoScaleH(50))];
    [_titleView.layer setCornerRadius:20.0];
    _titleView.layer.masksToBounds = YES;
    
    [self.view addSubview:_titleView];
    circleViewBG.height = _titleView.bottom-circleViewBG.top+15;
    
    CGFloat headerViewMAXY = CGRectGetMaxY(_titleView.frame);
    
    self.headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView setImage:[MGLiveBundle LiveImageWithName:@"header_bg_img"]];
    [self.headerView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerView setFrame:CGRectMake(0, headerViewMAXY+15, MG_WIN_WIDTH, MG_WIN_WIDTH)];
    //    self.videoManager.topY = self.headerView.origin.y;
    //    self.videoManager.viewHight = self.headerView.height;
    CGFloat bottomViewMAXY = CGRectGetMaxY(self.headerView.frame);
    self.bottomView = [[MyBottomView alloc] initWithFrame:CGRectMake(0, bottomViewMAXY, MG_WIN_WIDTH, 40)
                                         andCountDownType:MGCountDownTypeText];
    
    //    self.bottomView.countDownView.Delegate =self;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self steupBomBtn];
    bottomView.top = _startScnBtn.top;
    bottomView.height = SCREEN_HEIGHT-bottomView.top;
    
}

//活体检测结束处理
- (void)liveDetectionFinish:(MGLivenessDetectionFailedType)type checkOK:(BOOL)check liveDetectionType:(MGLiveDetectionType)detectionType{
    [super liveDetectionFinish:type checkOK:check liveDetectionType:detectionType];
    
    //    MyFinishViewController *finishVC = [[MyFinishViewController alloc] initWithNibName:nil bundle:nil];
    //    [finishVC setCheckOK:check];
    
    if (check == YES) {
        FaceIDData *faceData = [self.liveManager getFaceIDData];
        
        if ([self.LivingDelegate respondsToSelector:@selector(onData:)]) {
            
            [self.LivingDelegate onData:faceData];
        }
        
//        debugLog(@"%@",faceData);
    }
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

-(void)steupBomBtn{
    CGFloat startScnBtnY =   CGRectGetMaxY(self.bottomView.frame);
    _startScnBtn = [[UIButton alloc]init];
    
    [_startScnBtn setFrame:CGRectMake(kScreenWidth/2-((kScreenWidth-20)/2), startScnBtnY, kScreenWidth-20, autoScaleH(48))];
    [_startScnBtn setTitle:@"识别中..." forState:UIControlStateNormal];
    [_startScnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startScnBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [APPUtil setViewShadowStyle:_startScnBtn];
    
    [_startScnBtn setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHexString:@"#09C58A"]] forState:UIControlStateNormal];
    _startScnBtn.layer.masksToBounds = YES;
    [_startScnBtn.layer setCornerRadius:5.0];
    
    [self.view addSubview:_startScnBtn];
    
    CGFloat ScndescribeY = CGRectGetMaxY(_startScnBtn.frame);
    UIButton *Scndescribe = [[UIButton alloc]init];
    [Scndescribe setImage:[UIImage imageNamed:@"icon_safety"] forState:UIControlStateNormal];
    
    [Scndescribe setTitle:@"您的资料仅用于审核用车资格" forState:UIControlStateNormal];
    [Scndescribe setFrame:CGRectMake(kScreenWidth/2-autoScaleW(kScreenWidth)/2, ScndescribeY+5, autoScaleW(kScreenWidth), autoScaleH(22))];
    [Scndescribe setTitleColor:[UIColor colorWithHexString:@"#CFCFCF"] forState:UIControlStateNormal];
    [Scndescribe.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    //    Scndescribe.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:Scndescribe];
    
}

- (void)setUpTopView{
    
    
    self.title = @"面部识别";
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onBackClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

- (void)onBackClick{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

-(void)onTimeUp:(CGFloat)time{
//    debugLog(@"%f",time);
    NSString *newtitle =[NSString stringWithFormat:@"识别中...(%d)",(int)time];
    [_startScnBtn setTitle:newtitle forState:UIControlStateNormal];
}

-(void)dealloc{
    
}




@end

