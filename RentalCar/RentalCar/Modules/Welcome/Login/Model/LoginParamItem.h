//
//  LoginParamItem.h
//  RentalCar
//
//  Created by hu on 17/3/4.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface LoginParamItem : BaseItem

@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * vcode;
@property(nonatomic,copy)NSString * deviceCode;
@property(nonatomic,copy)NSString * areaId;

@end
