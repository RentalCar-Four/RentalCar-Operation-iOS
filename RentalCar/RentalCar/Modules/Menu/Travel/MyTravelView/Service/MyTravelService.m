//
//  MyTravelService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "MyTravelService.h"

@implementation MyTravelService
- (void)requesLeaseWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    
    [[CommonRequest shareRequest] requestWithPost:getLeaseUrl() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        [self onSuccMessage:data withType:_REQUEST_LeaseList_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
    
}
@end