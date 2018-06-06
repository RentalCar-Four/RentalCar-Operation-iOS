//
//  StationCarItem.h
//  RentalCar
//
//  Created by Jason on 2017/12/25.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface StationCarItem : BaseItem

@property(nonatomic,copy)NSString * stationId; //站点 ID
@property(nonatomic,copy)NSString * stationName; //站点名称
@property(nonatomic,copy)NSString * vehicleCnt; //可租车辆数
@property(nonatomic,copy)NSString * gpsLng; //GPS 经度
@property(nonatomic,copy)NSString * gpsLat; //GPS 纬度
@property(nonatomic,copy)NSString * addr; //地址
@property(nonatomic,copy)NSString * distance; //站点与参数所传经纬度的距离
@property(nonatomic,copy)NSString * returnStatus; //可还车状态， 1 可还， 2 已满
@property(nonatomic,copy)NSString * entityPileCount; //实体充电桩个数

@property(nonatomic,copy)NSString * pricePerMinute; //每分钟多少钱
@property(nonatomic,copy)NSString * priceDtlUrl; //计费规则
@property(nonatomic,copy)NSString * vin; //车架号
@property(nonatomic,copy)NSString * numberPlate; //车牌号
@property(nonatomic,copy)NSString * vehicleModels; //车辆型号
@property(nonatomic,copy)NSString * soc; //电量
@property(nonatomic,copy)NSString * remainingKm; //续航里程
@property(nonatomic,copy)NSString * bookTotalTime; //预约时长

@property(nonatomic,copy)NSString * showType; //1网点、2车辆
@property(nonatomic,copy)NSString * carType; //1长租 2分时  3全部
@property(nonatomic,copy)NSString * carStatus; //0空闲,1租赁中,2预约中,3故障,4亏电,5运维,6离线,7全部,8正常车(包含0、1、2),9不正常车(包含3、4、5、6)
@property(nonatomic,copy)NSString * operationMemberId; //操作人员会员号
@property(nonatomic,copy)NSString * operationRentNum; //操作人员租赁单号
@property(nonatomic,copy)NSString * operationName; //操作人员姓名
@property(nonatomic,copy)NSString * operationPhone; //操作人员手机号

@end
