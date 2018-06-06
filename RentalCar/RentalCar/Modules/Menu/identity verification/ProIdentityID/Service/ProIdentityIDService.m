//
//  ProIdentityIDService.m
//  RentalCar
//
//  Created by Hulk on 2017/4/5.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ProIdentityIDService.h"

@implementation ProIdentityIDService
- (void)requestProIdentityCardInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail{
    [CommonRequest shareRequest].upType = 4;
    [[CommonRequest shareRequest] requestWithPostUpload:uploadArtificialAuditImg() parameters:param success:^(NSDictionary *data) {
        
        success(data);
        
        [self onSuccMessage:data withType:_REQUEST_ProID_];
        
//        debugLog(@"%@",data);
    } failure:^(NSString *content) {
        
        fail(content);
//        debugLog(@"%@",content);
        [self onFailMessage:content withType:_REQUEST_ProID_];
    }];
    
}


- (NSString *)requestGetMemberImgWithService:(NSDictionary *)param{
   [CommonRequest shareRequest].upType = 5;
    
   NSString *NewUrl = [[CommonRequest shareRequest]requestWithPostDownloadPic:getMemberImg() parameters:param];
    
    
    return NewUrl;
}
@end
