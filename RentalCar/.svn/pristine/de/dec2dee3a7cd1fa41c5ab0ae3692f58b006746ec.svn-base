//
//  BookingTimerView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/15.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  预约计时View
 *
 */

#import "BaseView.h"
#import <MAMapKit/MAMapKit.h>

@class BookingItem;

@protocol BookingTimerDelegate <NSObject>

@optional
- (void)onClickWithCancelBookingCarEvent:(BookingItem *)item;
- (void)onClickWithUnLockCarEvent:(BookingItem *)item;
- (void)onClickWithShowCarPswEvent:(BookingItem *)item;
- (void)onClickWithTimerOverEvent:(BookingItem *)item;

@end

@interface BookingTimerView : BaseView

//数据源
@property (nonatomic,strong) BookingItem *bookingItem;
@property (nonatomic,assign) CLLocationCoordinate2D userLoc;
@property (nonatomic,assign) int flag; //1、开锁 2、查看租车密码

//代理
@property (nonatomic,weak) id<BookingTimerDelegate> delegate;

- (void)endTimer;

@end
