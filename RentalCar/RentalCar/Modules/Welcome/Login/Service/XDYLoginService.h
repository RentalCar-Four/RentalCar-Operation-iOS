//
//  LoginService.h
//  RentalCar
//
//  Created by hu on 17/3/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseService.h"
#import "LoginItem.h"
#import "LoginParamItem.h"
#import "LoginAreaList.h"

@interface XDYLoginService : BaseService

//登录请求
- (void)requestLoginWithService:(LoginParamItem *)item;

//验证码
- (void)requestValidateWithService:(NSString *)phone;

//获取区域列表
- (void)requestGetAreaListWithService;

//获取服务协议
- (void)requestGetMemberAgreementWithService;

@end
