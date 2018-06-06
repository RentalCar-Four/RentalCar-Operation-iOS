//
//  PersonCenterService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "PersonCenterService.h"

@implementation PersonCenterService

//- (void)requestgetMemberStatusWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
//    [[CommonRequest shareRequest] requestWithPost:getMemberUrl() parameters:param success:^(NSDictionary *data) {
//        
//        success(data);
//        
//        debugLog(@"%@",data);
//    } failure:^(NSString *content) {
//        
//        fail(content);
//        debugLog(@"%@",content);
//    }];
//}

- (void)requestgetMemberTotalDataWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [[CommonRequest shareRequest] requestWithPost:getMemberTotalData() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
        debugLog(@"%@",content);
    }];
}

- (void)requestgetRentPwdWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [[CommonRequest shareRequest] requestWithPost:getRentPwd() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
}
@end
