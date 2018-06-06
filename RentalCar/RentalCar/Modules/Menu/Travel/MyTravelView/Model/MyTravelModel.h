//
//  MyTravelModel.h
//  RentalCar
//
//  Created by Hulk on 2017/3/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface MyTravelModel : BaseItem
@property(nonatomic,copy)NSString * rentNum; //租赁单号
@property(nonatomic,copy)NSString * numberPlate;//车牌号
@property(nonatomic,copy)NSString * startTime;//租赁开始 时间
@property(nonatomic,copy)NSString * endTime;//租赁结束 时间
@property(nonatomic,copy)NSString * startLocation;//租赁时的地址
@property(nonatomic,copy)NSString * endLocation;//还车时的地址
@property(nonatomic,copy)NSString * totalFee;//租赁总费用（元）
@property(nonatomic,copy)NSString * leaseMinutes;//租赁时长（分钟）
@property(nonatomic,copy)NSString * leaseMileage;//行驶里程（公里）
@property(nonatomic,copy)NSString * rentStatus;//车辆状态
@property(nonatomic,copy)NSString * status;//0未完成 其他已完成

@end