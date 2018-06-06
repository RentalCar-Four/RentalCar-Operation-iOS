//
//  UrlConfig.h
//  RentalCar
//
//  Created by hu on 17/3/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "Config.h"

@interface UrlConfig : Config

    //验证
    NSString *getValidateUrl();

    //注册登录
    NSString *getLoginUrl();

    //获取区域列表
    NSString *getAreaListUrl();

    //根据城市获取对应的区域
    NSString *getCityToAreaUrl();

    //获取可租车辆列表
    NSString *getCarForLeaseUrl();

    //获取站点及可租车辆数量
    NSString *getStationForLeaseUrl();

    //获取站点可租车辆列表
    NSString *getStationCarListUrl();

    //获取还车站点
    NSString *getStationForReturnUrl();

    NSString *getUploadVerificationUrl();

    //预约车辆
    NSString *getBookingCarUrl();

    //支付宝
    NSString *getAliPayUrl();

    //微信支付
    NSString *getWXPayUrl();

    //用户状态
    NSString *getAuthUrl();

    //行程列表
    NSString *getLeaseUrl();

    //退出登录
    NSString *getLogoutUrl();

    //获取会员路程时长
    NSString *getMemberTotalData();

    //获取租车密码
    NSString *getRentPwd();

    //获取已预约车辆
    NSString *getCarInBookingUrl();

    //获取扫码车辆
    NSString *getCarInSearchInfoUrl();

    //获取行程中车辆
    NSString *getCarInLeaseUrl();

    //解除预约车辆
    NSString *getCancelBookingCarUrl();

    //预约中开车门(开锁用车)
    NSString *getOpenBookingCarUrl();

    //直接用车（未预约、未租车时直接开车门）
    NSString *getOpenCarDirectlyUrl();

    //搜索站点
    NSString *getSearchStationUrl();

    //扫码租车获取车辆信息
    NSString *getSearchCarForLeaseUrl();

    //获取钱包信息
    NSString *getMemberAccountUrl();

    //获取服务协议
    NSString *getMemberAgreementUrl();

    //租赁中开关车门
    NSString *getOpenOrCloseLeaseCarUrl();

    //还车
    NSString *getReturnCarUrl();

    //获取服务电话
    NSString *getServicePhoneUrl();

    //获取版本信息
    NSString *getAppVersionUrl();

    //获取还车时检查项
    NSString *getChekItemForReturnCar();

    //获取租赁中车辆预估租金
    NSString *getEstimateLeaseFee();

    //上传头像
    NSString *uploadHeadImg();

    //下载头像
    NSString *downloadHeadImg();

    //人工审核上传身份证
    NSString *uploadArtificialAuditImg();
    //获取优惠券列表
    NSString *couponList();

    //获取车牌号前2个字符
    NSString *getNumberPlatePrefix();
    //获取正在审核的照片
    NSString *getMemberImg();
    //上传昵称
    NSString *updateMemberInfo();
    //用户协议
    NSString *getMemberGuideAgreement();
    //面部识别失败
    NSString *getMemberFRFAgreement();

    //上传经纬度
    NSString *uploadLatLng();

    //搜索车辆信息
    NSString *getCarInfo();

@end
