//
//  UserInfo.m
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_userInfo = nil;
static NSUserDefaults *_defaults = nil;

@implementation UserInfo

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserInfo alloc] init];
        _defaults = [NSUserDefaults standardUserDefaults];
    });
    return _userInfo;
}

- (void)getUserInfo {
    
    NSDictionary *userDic = [_defaults objectForKey:@"UserInfo"];
    if (userDic) {
        [self loadUserDic:userDic];
    }
}

- (void)setUserInfo:(NSDictionary *)userDic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDic forKey:@"UserInfo"];
    [defaults synchronize];
    
    [self loadUserDic:userDic];
}

- (void)loadUserDic:(NSDictionary *)userDic {
    self.accountStatus = userDic[@"accountStatus"];
    self.auditStatus = userDic[@"auditStatus"];
    self.depositToPay = userDic[@"depositToPay"];
    self.memberId = userDic[@"memberId"];
    self.memberStatus = userDic[@"memberStatus"];
    self.autoAuditstate = userDic[@"autoAuditstate"];
    self.mobile = [[APPUtil share]handleDataForSecurity:userDic[@"mobile"]];
    self.auditRemark = userDic[@"auditRemark"];
    self.headImgUrl = userDic[@"headImgUrl"];
    self.nickName = userDic[@"nickName"];
    self.token = userDic[@"token"];
    self.userStatus =  [NSString stringWithFormat:@"%d",[userDic[@"userStatus"] intValue]];
    if (userDic.allKeys.count==0||userDic==nil) {
        self.token = @"";
    }
}

-(NSString *)token{
    if ([APPUtil isBlankString:_token]) {
        return @"";
    }
    return _token;
}


@end
