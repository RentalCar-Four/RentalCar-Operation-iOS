//
//  BookingItem.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface BookingItem : BaseItem

@property(nonatomic,copy)NSString *ID; //预约记录ID
@property(nonatomic,copy)NSString *startTime; //开始时间
@property(nonatomic,copy)NSString *endTime; //结束时间
@property(nonatomic,copy)NSString *leftMinutes; //剩余时间(分钟)
@property(nonatomic,copy)NSString *leftSeconds; //剩余时间(秒)

@property(nonatomic,copy)NSString *lockStatus; //开锁状态 1、可开锁，2、不可开锁(锁已开)

@property(nonatomic,copy)NSString *vin; //车架号
@property(nonatomic,copy)NSString *numberPlate; //车牌号
@property(nonatomic,copy)NSString *vehicleModels; //车辆型号
@property(nonatomic,copy)NSString *soc; //电量
@property(nonatomic,copy)NSString *remainingKm; //续航里程（公里）
@property(nonatomic,copy)NSString *addr; //地址(网点)
@property(nonatomic,copy)NSString *gpsLng; //GPS 经度
@property(nonatomic,copy)NSString *gpsLat; //GPS 纬度

@property(nonatomic,copy)NSString *rentNum; //租赁单号
@property(nonatomic,copy)NSString *startLocation; //取车点
@property(nonatomic,copy)NSString *currTime; //服务器端当前时间
@property(nonatomic,copy)NSString *leaseMinutes; //截至服务器端当前时间,租赁时长（分钟）
@property(nonatomic,copy)NSString *leaseMileage; //截至服务器端当前时间,行驶里程（公里）
@property(nonatomic,copy)NSString *leaseMoney; //截至服务器端当前时间,预估费用（元）

@property(nonatomic,copy)NSString *forbidReturnCar; //长租用户禁止还车

@end