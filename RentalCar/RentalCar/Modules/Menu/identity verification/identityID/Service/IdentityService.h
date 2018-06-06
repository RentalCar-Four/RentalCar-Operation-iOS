//
//  IdentityService.h
//  RentalCar
//
//  Created by Hulk on 2017/3/14.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseService.h"

@interface IdentityService : BaseService
//获取身份证信息
- (void)requestIdentityCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
//获取驾照信息
- (void)requestDrivingCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
//获取人脸识别信息
- (void)requestFaceCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
//获取遇到问题的web页面
- (void)requestMemberFRFAgreementWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
@end
