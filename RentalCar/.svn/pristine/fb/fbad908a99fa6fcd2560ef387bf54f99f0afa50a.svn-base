//
//  CarReturnView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  还车View
 *
 */

#import "BaseView.h"
@class StationItem;

@protocol CarReturnDelegate <NSObject>

@optional
- (void)onClickWithReturnCarGuideEvent:(StationItem *)item;

@end

@interface CarReturnView : BaseView

//数据源
@property (nonatomic,strong) StationItem *stationItem;

//代理方法
@property (nonatomic,weak) id<CarReturnDelegate> delegate;

@end
