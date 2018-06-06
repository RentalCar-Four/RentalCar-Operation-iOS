//
//  NSTimer+EocBlockSupports.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "NSTimer+EocBlockSupports.h"

@implementation NSTimer (EocBlockSupports)

+ (NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat {
    return  [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startTimer:) userInfo:[block copy] repeats:repeat];
}

//定时器所执行的方法
+ (void)startTimer:(NSTimer *)timer {
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
