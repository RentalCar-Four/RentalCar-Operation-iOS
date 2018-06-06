//
//  CountDownTimer.h
//  RentalCar
//
//  Created by hu on 17/3/3.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CountDownTimerDelegate <NSObject>

@optional

- (void)onTimerOut;
- (void)onRefreshTimer:(NSString *)cutTimer;


@end

@interface CountDownTimer : NSObject

- (void)stopTimer;
- (void)onCountDownTimer:(int)seconds;

@property(nonatomic,weak)id<CountDownTimerDelegate>  timerDelegate;

@end
