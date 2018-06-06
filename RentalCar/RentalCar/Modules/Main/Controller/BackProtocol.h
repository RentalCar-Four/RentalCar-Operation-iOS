//
//  BackProtocol.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchPoi.h"
#import "AreaInfo.h"

@protocol BackProtocol <NSObject>

@optional
/**
 * 扫码租车(1、车架号；2、车牌号；3、code码)
 */
- (void)backAction:(NSString *)str andFlag:(NSInteger)flag;
- (void)mapSearchBackAction:(SearchPoi *)poi;
- (void)selectCity:(NSDictionary *)dic;

@end
