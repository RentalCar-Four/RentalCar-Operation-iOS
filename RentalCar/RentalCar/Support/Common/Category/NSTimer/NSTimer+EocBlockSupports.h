//
//  NSTimer+EocBlockSupports.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (EocBlockSupports)

+ (NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat;

@end
