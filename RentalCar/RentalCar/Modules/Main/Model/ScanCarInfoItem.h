//
//  ScanCarInfoItem.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface ScanCarInfoItem : BaseItem

@property(nonatomic,copy)NSString *rentStatus; //租赁状态， 1 可租， 2 本人预约中， 3 本人租赁中， 4 不可租
@property(nonatomic,copy)NSString *nonRentReason; //不可租原因描述
@property(nonatomic,copy)NSString *orderNo; //预约记录号或租赁单号

@property(nonatomic,copy)NSString *vin; //车架号
@property(nonatomic,copy)NSString *numberPlate; //车牌号
@property(nonatomic,copy)NSString *vehicleModels; //车辆型号
@property(nonatomic,copy)NSString *soc; //电量
@property(nonatomic,copy)NSString *remainingKm; //续航里程（公里）
@property(nonatomic,copy)NSString *addr; //地址(网点)
@property(nonatomic,copy)NSString *priceRule; //计费规则
@property(nonatomic,copy)NSString *priceDtlUrl; //详细计费规则 URL 地址
@property (nonatomic,copy)NSString *pricePerMinute;//计费价格
@end
