//
//  AppDelegate.h
//  RentalCar
//
//  Created by hu on 17/2/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic)NSTimer *nsTimer;
@property(assign, nonatomic)UIBackgroundTaskIdentifier backgroundTask;

//控件宽高字体大小适配方法
- (CGFloat)autoScaleW:(CGFloat)w;
- (CGFloat)autoScaleH:(CGFloat)h;

@end

