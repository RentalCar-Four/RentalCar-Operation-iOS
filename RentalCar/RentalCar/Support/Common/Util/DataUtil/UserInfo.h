//
//  UserInfo.h
//  ArtEast
//
//  Created by yibao on 16/9/30.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  用户Modle
 *
 */

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,copy) NSString *accountStatus;//会员状态（ 1 启用， 2 欠费）
@property (nonatomic,copy) NSString *autoAuditstate; //自动审核状态 1 、未验证 2 、身份证验证失败（调用 faceid 有源比对不通过）3 、身份证验证成功 4 、驾驶证信息与身份证信息不匹配（驾驶证识别出的姓名、证号与身份证信息不匹配）5 、驾驶证已过期（驾驶证识别出有效期已过期）6 、驾驶证信息验证失败（调用 faceid 无源比对不通过）7 、驾驶证验证成功 8 、人脸验证失败（调用 faceid 无源比对不通过）9 、自动验证成功
@property (nonatomic,copy) NSString *auditStatus;//认证状态 认证状态（ 1 未认证， 2 待认证， 3 认证失败， 4 已认证， 5 待开通， 6 已开通， 7 退款中）
@property (nonatomic,copy) NSString *depositToPay;//保证金 需支付的违章保证金（元）
@property (nonatomic,copy) NSString *memberId;//会员id
@property (nonatomic,copy) NSString *memberStatus;//会员状态 （ 1 启用， 2 禁用， 3 已退押金）
@property (nonatomic,copy) NSString *mobile;//电话
@property (nonatomic,copy) NSString *auditRemark; //认证失败原因
@property (nonatomic,copy) NSString *headImgUrl; //用户头像
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *userStatus; //新增 0：用户，1：运维人员

+ (UserInfo *)share;

- (void)getUserInfo;

- (void)setUserInfo:(NSDictionary *)userDic;

@end