//
//  EditUserInfoService.h
//  RentalCar
//
//  Created by Hulk on 2017/3/30.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseService.h"

@interface EditUserInfoService : BaseService
//上传头像
- (void)requestUploadHeadImgWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
//上传昵称
- (void)requestUploadInfoWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
@end
