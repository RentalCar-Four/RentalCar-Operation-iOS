//
//  LaunchVC.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/5.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "LaunchVC.h"

@interface LaunchVC ()

@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    /**
     *  目的：实现启动页面放大渐隐消失
     */
    UIImageView *launchImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    launchImgView.image = [UIImage imageNamed:@"Launching"];
    [self.view addSubview:launchImgView];
    if (IS_IPhoneX) {
        launchImgView.top=launchImgView.top-30;
        launchImgView.height = kScreenHeight+30;
    }
    UIImageView *animationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(107.5), autoScaleH(210), autoScaleW(160), autoScaleW(160))];
    animationImgView.image = [UIImage imageNamed:@"motion_Splashs0029"];
    [self.view addSubview:animationImgView];

    [APPUtil runAnimationWithCount:29 name:@"motion_Splashs00" imageView:animationImgView repeatCount:1 animationDuration:0.03]; //开始加载
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self doneAction]; //完成事件
    });
   
}

#pragma mark - 启动动画完成
- (void)doneAction {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
