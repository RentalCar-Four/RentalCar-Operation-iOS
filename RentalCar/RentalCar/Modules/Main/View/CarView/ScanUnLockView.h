//
//  ScanUnLockView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  扫码开锁View
 *
 */

#import "BaseView.h"

@class ScanCarInfoItem;

@protocol ScanUnLockDelegate <NSObject>

@optional
- (void)onClickWithCancelUnLockCarEvent:(ScanCarInfoItem *)item;
- (void)onClickWithScanUnLockCarEvent:(ScanCarInfoItem *)item;
- (void)onClickWithPriceRuleEvent:(ScanCarInfoItem *)item;

@end

@interface ScanUnLockView : BaseView

//数据源
@property (nonatomic,strong) ScanCarInfoItem *item;

//代理
@property (nonatomic,weak) id<ScanUnLockDelegate> delegate;

//动画视图
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIView *carInfoView;


@end
