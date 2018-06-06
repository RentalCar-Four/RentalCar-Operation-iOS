//
//  BaseNavController.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/8.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置UINavigationBar的样式
    [[UINavigationBar appearance] setTintColor:kBlueColor];
    [UINavigationBar appearance].barTintColor=[UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:kTitleFont,NSForegroundColorAttributeName:kTitleColor}];
    //将导航条默认黑线改成阴影
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage imageNamed:@"NavbarShadow"]; //阴影图片
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
