//
//  walletService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "walletService.h"

@implementation walletService
- (void)requestgetMemberAccountWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    
    [[CommonRequest shareRequest] requestWithPost:getMemberAccountUrl() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        [self onSuccMessage:data withType:_REQUEST_MemberAccount_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
    
}
@end
