//
//  IdentityService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/14.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "IdentityService.h"

@implementation IdentityService

- (void)requestIdentityCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [CommonRequest shareRequest].upType = 0;
    [[CommonRequest shareRequest] requestWithPostUpload:getUploadVerificationUrl() parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
        [self onSuccMessage:data withType:_REQUEST_ID_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
        debugLog(@"%@",content);
        [self onFailMessage:content withType:_REQUEST_ID_];
    }];
    
}


- (void)requestDrivingCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [CommonRequest shareRequest].upType = 1;
    [[CommonRequest shareRequest] requestWithPostUpload:getUploadVerificationUrl() parameters:param success:^(NSDictionary *data) {
        
        success(data);
        [self onSuccMessage:data withType:_REQUEST_DrivingID_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
        debugLog(@"%@",content);
        [self onFailMessage:content withType:_REQUEST_DrivingID_];
    }];
    
}

- (void)requestFaceCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [CommonRequest shareRequest].upType = 2;
    [[CommonRequest shareRequest] requestWithPostUpload:getUploadVerificationUrl() parameters:param success:^(NSDictionary *data) {
        success(data);
        [self onSuccMessage:data withType:_REQUEST_FaceID_];
        
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        [self onFailMessage:content withType:_REQUEST_FaceID_Fill];
        
        fail(content);
//        debugLog(@"%@",content);
    }];
    
}


- (void)requestMemberFRFAgreementWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [[CommonRequest shareRequest] requestWithPost:getMemberFRFAgreement() isCovered:NO parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
    }];
}


@end
