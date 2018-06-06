//
//  LoginService.m
//  RentalCar
//
//  Created by hu on 17/3/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYLoginService.h"

@implementation XDYLoginService

- (void)requestValidateWithService:(NSString *)phone{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"mobile"];
    [param setObject:@"1" forKey:@"appType"];

    [[CommonRequest shareRequest] requestWithGet:getValidateUrl() parameters:param success:^(id data) {
        
        [StatisticsClass eventId:DL01];
        [self onSuccMessage:data withType:_REQUEST_VALIDATE_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_VALIDATE_];
        
    }];
}

- (void)requestLoginWithService:(LoginParamItem *)item{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:item.mobile forKey:@"mobile"];
    [param setObject:item.vcode forKey:@"vcode"];
    [param setObject:item.deviceCode forKey:@"deviceCode"];
    [param setObject:@"1" forKey:@"appType"];
    if (item.areaId == nil) {
        [param setObject:@"" forKey:@"areaId"];
    }else{
        [param setObject:item.areaId forKey:@"areaId"];
    }
    
    [[CommonRequest shareRequest] requestWithPost:getLoginUrl() isCovered:YES parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        LoginItem *item = [LoginItem yy_modelWithJSON:result];
        
        NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] mutableCopy];
        if (!userDic) {
            userDic = [NSMutableDictionary dictionary];
        }
        [userDic setObject:item.memberId forKey:@"memberId"];
        [userDic setObject:item.token forKey:@"token"];
        [[UserInfo share] setUserInfo:userDic];
        
        NSLog(@"用户信息：%@",userDic);
        
        [self onSuccMessage:item withType:_REQUEST_LOGIN_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_LOGIN_];
        
    }];
    
}


//获取区域列表
- (void)requestGetAreaListWithService{
    
    [[CommonRequest shareRequest] requestWithGet:getAreaListUrl() parameters:nil success:^(id data) {
        
        NSDictionary *result = [data objectForKey:@"result"];
        
        [self onSuccMessage:result];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_LOGIN_];
        
    }];
}

- (void)requestGetMemberAgreementWithService{
    [[CommonRequest shareRequest] requestWithGet:getMemberAgreementUrl() parameters:nil success:^(id data) {
    
        NSDictionary *result = [data objectForKey:@"result"];
        
        [self onSuccMessage:result withType:_REQUEST_GetAgreement_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_LOGIN_];
        
    }];
}


@end