//
//  EditUserInfoService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/30.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "EditUserInfoService.h"

@implementation EditUserInfoService
- (void)requestUploadHeadImgWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [CommonRequest shareRequest].upType = 3;
    [[CommonRequest shareRequest] requestWithPostUpload:uploadHeadImg() parameters:param success:^(NSDictionary *data) {
        
        success(data);
//        [self onSuccMessage:data withType:_REQUEST_DrivingID_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
        debugLog(@"%@",content);
//        [self onFailMessage:content withType:_REQUEST_DrivingID_];
    }];
    
}


- (void)requestUploadInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [[CommonRequest shareRequest] requestWithPost:updateMemberInfo() isCovered:NO parameters:param success:^(NSDictionary *data) {
        success(data);
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        
    }];
    
}




@end
