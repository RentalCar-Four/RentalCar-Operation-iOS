//
//  CarReturnConfirmView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  还车确认View
 *
 */

#import "BaseView.h"
#import "BookingItem.h"

@protocol CarReturnConfirmDelegate <NSObject>
- (void)onClickWithCancelReturnCarEvent:(BookingItem *)item;
- (void)onClickWithConfirmReturnCarEvent:(BookingItem *)item;
- (void)returnCarSuccEvent:(NSDictionary *)dic;
- (void)returnCarFailEvent;

@optional


@end

@interface CarReturnConfirmView : BaseView

@property (nonatomic,strong) UILabel *Lab1; //停放至还车点
@property (nonatomic,strong) UILabel *Lab2; //确认拉起手刹
@property (nonatomic,strong) UILabel *Lab3; //关闭车辆电源
@property (nonatomic,strong) UILabel *Lab4; //关闭车门车窗

//数据源
@property (nonatomic,strong) BookingItem *bookingItem;

//代理
@property (nonatomic,weak) id<CarReturnConfirmDelegate> delegate;

- (void)recoverView;

@end