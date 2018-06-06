//
//  AreaInfo.h
//  RentalCar
//
//  Created by Jason on 2018/1/3.
//  Copyright © 2018年 xyx. All rights reserved.
//

/**
 * 用户所选区域
 */
#import "BaseItem.h"

@interface AreaInfo : BaseItem

//区域ID
@property (nonatomic, copy) NSString *areaId;
//区域名称
@property (nonatomic, copy) NSString *areaName;
//区域押金
@property (nonatomic, copy) NSString *deposit;
//经度
@property (nonatomic, copy) NSString *lng;
//维度
@property (nonatomic, copy) NSString *lat;
//拼音首字母大写
@property (nonatomic, copy) NSString *firstCharacter;
/*
 * 区域状态
 * 1、开通
 * 2、当前城市用车服务暂未开通。敬请期待！
 * 3、本地区暂不提供时长低于一周的租赁服务。
 * 4、暂未提供注册地外跨区域用车服务。
 */
@property (nonatomic, copy) NSString *areaStatus;

+ (AreaInfo *)share;

- (void)getAreaInfo;

- (void)setAreaInfo:(NSDictionary *)areaDic;

@end
