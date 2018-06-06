//
//  SearchPoi.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface SearchPoi : BaseItem<NSCoding>

//名称
@property (nonatomic, copy) NSString *name;
//地址
@property (nonatomic, copy) NSString *address;
//经度
@property (nonatomic, assign) double longitude;
//维度
@property (nonatomic, assign) double latitude;

@end
