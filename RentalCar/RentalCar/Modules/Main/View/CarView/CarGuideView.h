//
//  CarReturnView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  还车导航View
 *
 */

#import "BaseView.h"
@class StationCarItem;

@protocol CarGuideDelegate <NSObject>

@optional
- (void)onClickWithReturnCarGuideEvent:(StationCarItem *)item;

@end

@interface CarGuideView : BaseView

//数据源
@property (nonatomic,strong) StationCarItem *stationItem;

//代理方法
@property (nonatomic,weak) id<CarGuideDelegate> delegate;


- (CGFloat)getHeight:(BOOL)isHavePile;

@end
