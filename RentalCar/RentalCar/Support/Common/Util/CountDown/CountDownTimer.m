//
//  CountDownTimer.m
//  RentalCar
//
//  Created by hu on 17/3/3.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CountDownTimer.h"
@interface CountDownTimer()
{
    
   __block NSInteger timeOut;
}

@end

@implementation CountDownTimer


- (void)onCountDownTimer:(int)seconds {
   
//    __block NSInteger timeOut = 59;
    
    timeOut = seconds;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

   dispatch_source_t dispatch_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_source_set_timer(dispatch_timer, DISPATCH_TIME_NOW, NSEC_PER_SEC, NSEC_PER_SEC);
    dispatch_source_set_event_handler(dispatch_timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(dispatch_timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                if ([self.timerDelegate respondsToSelector:@selector(onTimerOut)]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.timerDelegate onTimerOut];
                        
                    });
                }
            });
        } else {


            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];

            NSString *currentTime = [NSString stringWithFormat:@"%@",strTime];
            if ([self.timerDelegate respondsToSelector:@selector(onRefreshTimer:)]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.timerDelegate onRefreshTimer:currentTime];

                });
                
            }
          
            timeOut--;
        }
    });
    dispatch_resume(dispatch_timer);
}

- (void)stopTimer{
    
    timeOut = 0;
}

@end
