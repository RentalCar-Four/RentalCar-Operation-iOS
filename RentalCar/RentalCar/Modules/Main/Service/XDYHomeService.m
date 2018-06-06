//
//  XDYHomeService.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/7.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYHomeService.h"
#import "UserInfo.h"
#import "NSDictionary+DeleteNULL.h"
@implementation XDYHomeService

- (void)requestUserAuthState{
    
    NSDictionary *param = [NSDictionary dictionary];
    param = @{@"appType":@"1"};
    [[CommonRequest shareRequest] requestWithPost:getAuthUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSLog(@"会员状态信息：%@",data[@"result"]);
        
        UserInfo *info = [UserInfo yy_modelWithJSON:[NSDictionary changeType:data[@"result"]]];
        
        NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] mutableCopy];
        if (!userDic) {
            userDic = [NSMutableDictionary dictionary];
        }
        userDic = [NSDictionary changeType:userDic];
        [userDic setObject:info.memberId forKey:@"memberId"];
        [userDic setObject:info.mobile forKey:@"mobile"];
        [userDic setObject:info.nickName forKey:@"nickName"];
        [userDic setObject:info.auditStatus forKey:@"auditStatus"];
        NSString *auditRemark = @"";
        if (![APPUtil isBlankString:info.auditRemark]) {
            auditRemark = info.auditRemark;
        }
        [userDic setObject:auditRemark forKey:@"auditRemark"];
        [userDic setObject:info.memberStatus forKey:@"memberStatus"];
        [userDic setObject:info.accountStatus forKey:@"accountStatus"];
        [userDic setObject:info.autoAuditstate forKey:@"autoAuditstate"];
        [userDic setObject:info.depositToPay forKey:@"depositToPay"];
        
        NSString *rentPsw = @"";//用户的租车密码
        if (![APPUtil isBlankString:data[@"result"][@"rentPwd"]]) {
            rentPsw = [NSString stringWithFormat:@"%@",data[@"result"][@"rentPwd"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:rentPsw forKey:kRentPswKey];;
        
        NSString *userAreaID = @"";//用户的区域ID
        if (![APPUtil isBlankString:data[@"result"][@"userAreaId"]]) {
            userAreaID = [NSString stringWithFormat:@"%@",data[@"result"][@"userAreaId"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:userAreaID forKey:kUserAreaID];;
        
        
        NSString *userAreaName = @"";//用户的区域名字
        if (![APPUtil isBlankString:data[@"result"][@"userAreaName"]]) {
            userAreaName = [NSString stringWithFormat:@"%@",data[@"result"][@"userAreaName"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:userAreaName forKey:kUserAreaName];;
        
        
        NSString *headImgUrl = [self requestWithPostDownloadHeadImgWithService:param];
        [userDic setObject:headImgUrl forKey:@"headImgUrl"];
        [[UserInfo share] setUserInfo:userDic];
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetUserInfoNotification object:nil];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:headImgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:@"headImg" toDisk:YES];
            [self onSuccMessage:data withType: _REQUEST_AUTHSTATE_OK];
        }];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_AUTHSTATE_];
        
    }];
}

- (void)requestCityToAreaWithService:(NSDictionary *)param {
    [[CommonRequest shareRequest] requestWithPost:getCityToAreaUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        [self onSuccMessage:result[@"result"] withType:_REQUEST_CityToArea_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_CityToArea_];
        
    }];
}

//获取区域列表
- (void)requestGetAreaListWithService{
    
    [[CommonRequest shareRequest] requestWithGet:getAreaListUrl() parameters:nil success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *areaArr = [NSArray yy_modelArrayWithClass:[AreaInfo class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:areaArr withType:_REQUEST_GetAreaList];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_GetAreaList];
        
    }];
}

//获取租赁中的车
- (void)requestCarForLeaseWithService:(NSDictionary *)param{
    
    [[CommonRequest shareRequest] requestWithPost:getCarForLeaseUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *stationCarArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:stationCarArr withType:_REQUEST_CARFORLEASE_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_CARFORLEASE_];
        
    }];
}

//获取租赁中的网点
- (void)requestStationForLeaseWithService:(NSDictionary *)param{
    
    [[CommonRequest shareRequest] requestWithPost:getStationForLeaseUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *stationArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:stationArr withType:_REQUEST_STATIONFORLEASE_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_STATIONFORLEASE_];
        
    }];
}

//搜索车辆信息
- (void)requestSearchCarInfoWithService:(NSDictionary *)param{
    [[CommonRequest shareRequest] requestWithPost:getCarInfo() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *stationArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:stationArr withType:_REQUEST_SearchCarInfo];
        
    } failure:^(NSString *code) {
        [self onFailMessageWithType:_REQUEST_SearchCarInfo];
        
    }];
}

//根据网点获取车辆列表
- (void)requestStationCarListWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getStationCarListUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *carArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:carArr withType:_REQUEST_STATIONCarList_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_STATIONCarList_];
        
    }];
}

//获取车辆信息
- (void)requestCarInfoWithService:(NSDictionary *)param{
    [[CommonRequest shareRequest] requestWithPost:getCarInfo() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *carArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:carArr withType:_REQUEST_GetCarInfo];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_GetCarInfo];
        
    }];
}

- (void)requestStationForReturnWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getStationForReturnUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *stationArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:stationArr withType:_REQUEST_STATIONFORLEASE_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_STATIONFORLEASE_];
        
    }];
}

- (void)requestCarInBookingWithService {
    
    NSDictionary *param = [NSDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithPost:getCarInBookingUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *bookingCarArr = [NSArray yy_modelArrayWithClass:[BookingItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:bookingCarArr withType:_REQUEST_CarInBooking_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_CarInBooking_];
        
    }];
}

- (void)requestCarInSearchInfoWithService {
    
    NSDictionary *param = [NSDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithPost:getCarInSearchInfoUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        NSLog(@"扫码车辆信息：%@",result);
        
        NSArray *bookingCarArr = [NSArray yy_modelArrayWithClass:[BookingItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:bookingCarArr withType:_REQUEST_CarInSearchInfo_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_CarInSearchInfo_];
        
    }];
}

- (void)requestCarInLeaseWithService:(NSDictionary *)param {
    
//    NSDictionary *param = [NSDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithPost:getCarInLeaseUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *bookingCarArr = [NSArray yy_modelArrayWithClass:[BookingItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:bookingCarArr withType:_REQUEST_CarInLease_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_CarInLease_];
        
    }];
}

- (void)requestCancelBookingCarWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getCancelBookingCarUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        [self onSuccMessage:result[@"result"] withType:_REQUEST_CancelBookingCar_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_CancelBookingCar_];
        
    }];
}

- (void)requestSearchStationWithService:(NSDictionary *)param {
    [[CommonRequest shareRequest] requestWithPost:getSearchStationUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *stationArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        [self onSuccMessage:stationArr withType:_REQUEST_SEARCHSTATION_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_SEARCHSTATION_];
        
    }];
}

- (void)requestSearchCarForLeaseWithService:(NSDictionary *)param {
    [[CommonRequest shareRequest] requestWithPost:getSearchCarForLeaseUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        NSLog(@"扫码结果：%@",result);
        
        ScanCarInfoItem *item = [ScanCarInfoItem yy_modelWithJSON:result[@"result"]];
        
        [self onSuccMessage:item withType:_REQUEST_SearchCarForLease_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_SearchCarForLease_];
        
    }];
}

- (void)requestGetRentPwdService {
    NSDictionary *param = [NSDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithPost:getRentPwd()isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        [self onSuccMessage:result[@"result"][@"rentPwd"] withType:_REQUEST_GetRentPwd_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_GetRentPwd_];
        
    }];
}

- (void)requestOpenOrCloseLeaseCarWithService:(NSDictionary *)param {
    
    NSString *actionStr = param[@"action"];
    
    [[CommonRequest shareRequest] requestWithPost:getOpenOrCloseLeaseCarUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        if ([actionStr isEqualToString:@"1"]) {
            [TipUtil showSuccTip:@"关车门成功"];
        } else {
            [TipUtil showSuccTip:@"开车门成功"];
        }
        
        [self onSuccMessage:result withType:_REQUEST_DEFAULT_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_DEFAULT_];
        
    }];
}

- (void)requestReturnCarWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getReturnCarUrl() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        [self onSuccMessage:result[@"result"] withType:_REQUEST_ReturnCar_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_ReturnCar_];
        
    }];
}


- (void)requestgetServicePhoneWithService {
    NSDictionary *param = [NSDictionary dictionary];
    [[CommonRequest shareRequest] requestWithPost:getServicePhoneUrl()isCovered:NO parameters:param success:^(id data) {
        
        
        [self onSuccMessage:data withType:_REQUEST_GeterSvicePhone_];
        
    } failure:^(NSString *code) {
        
        
    }];
}


- (void)requestgetAppVersionWithService {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    debugLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *buildNum = [infoDictionary objectForKey:@"CFBundleVersion"];
//    debugLog(@"当前应用build软件版本:%@",buildNum);
    
    [param setValue:appCurVersion forKey:@"versioncode"];
    [param setValue:buildNum forKey:@"buildnumber"];
    [param setValue:@"2" forKey:@"type"];
    [param setValue:@"1" forKey:@"appType"];
    [[CommonRequest shareRequest] requestWithGet:getAppVersionUrl() parameters:param success:^(NSDictionary *data) {
        NSDictionary *result = [data objectForKey:@"result"];
       [self onSuccMessage:result withType:_REQUEST_getAppVersion_];
    } failure:^(NSString *content) {
        debugLog(@"%@",content);
        
    }];
}

- (void)requestChekItemForReturnCarWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getChekItemForReturnCar() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        [self onSuccMessage:result[@"result"][@"list"] withType:_REQUEST_ChekItemForReturnCar_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_ChekItemForReturnCar_];
        
    }];
}

- (void)requestEstimateLeaseFeeWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getEstimateLeaseFee() isCovered:NO parameters:param success:^(id data) {
        
        NSDictionary *result = data;
        
        [self onSuccMessage:result[@"result"] withType:_REQUEST_ChekItemForReturnCar_];
        
    } failure:^(NSString *code) {
        
        [self onFailMessageWithType:_REQUEST_ChekItemForReturnCar_];
        
    }];
}

//请求用户头像
- (NSString *)requestWithPostDownloadHeadImgWithService:(NSDictionary *)param{
    
    NSString *PicUrl = [[CommonRequest shareRequest] requestWithPostDownloadPic:downloadHeadImg() parameters:param];
    
    return PicUrl;
}

- (void)requestGetNumberPlatePrefixWithService {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[CommonRequest shareRequest] requestWithGet:getNumberPlatePrefix() parameters:param success:^(NSDictionary *data) {
        
        NSDictionary *result = [data objectForKey:@"result"];
        [self onSuccMessage:result[@"list"] withType:_REQUEST_getAppVersion_];
    } failure:^(NSString *content) {
        debugLog(@"%@",content);
        
    }];
}

- (void)requestUploadLatLngWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:uploadLatLng() isCovered:NO parameters:param success:^(id data) {
        
//        NSDictionary *result = data;
//        [self onSuccMessage:result withType:_REQUEST_UploadLatLng];
        
    } failure:^(NSString *code) {
        
//        [self onFailMessageWithType:_REQUEST_UploadLatLng];
        
    }];
}

- (void)requestBookTimeOpenCarWithService:(NSDictionary *)param{
    [[CommonRequest shareRequest] requestWithPost:getOpenBookingCarUrl() isCovered:NO parameters:param success:^(id data) {
        [APPUtil showToast:@"开锁成功"];
    } failure:^(NSString *code) {
         [APPUtil showToast:@"开锁失败"];
    }];
}

@end
