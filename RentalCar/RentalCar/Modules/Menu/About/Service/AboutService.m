//
//  AboutService.m
//  RentalCar
//
//  Created by Hulk on 2017/4/14.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "AboutService.h"

@implementation AboutService
- (void)requestgetMemberTotalDataWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [[CommonRequest shareRequest] requestWithPost:getMemberGuideAgreement() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
}
@end
