//
//  CouponViewService.m
//  RentalCar
//
//  Created by Hulk on 2017/4/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CouponViewService.h"

@implementation CouponViewService
- (void)requesCouponListWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    
    [[CommonRequest shareRequest] requestWithPost:couponList() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        [self onSuccMessage:data withType:_REQUEST_CouponList_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
    
}
@end
