//
//  RechargeService.h
//  RentalCar
//
//  Created by Hulk on 2017/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseService.h"

@interface RechargeService : BaseService
- (void)requestRechargeAlipayWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;

- (void)requestRechargeWXpayWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;


@end
