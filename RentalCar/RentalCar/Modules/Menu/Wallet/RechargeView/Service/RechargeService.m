//
//  RechargeService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "RechargeService.h"

@implementation RechargeService
- (void)requestRechargeAlipayWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    
    [[CommonRequest shareRequest] requestWithPost:getAliPayUrl() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
    
}


- (void)requestRechargeWXpayWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    
    [[CommonRequest shareRequest] requestWithPost:getWXPayUrl() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
    
}


@end
