//
//  CouponViewController.h
//  RentalCar
//
//  Created by Hulk on 2017/4/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"
#import "CouponCell.h"
#import "CouponModel.h"
@interface CouponViewController : BaseController
@property(nonatomic,assign)NSInteger OnPush;//1还车 2钱包
@property (nonatomic, copy) void(^CouponInfoBlock)(CouponModel *Info);
@property(nonatomic,strong)CouponCell *cell;
@end
