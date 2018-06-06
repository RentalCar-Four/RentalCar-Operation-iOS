//
//  UrlConfig.m
//  RentalCar
//
//  Created by hu on 17/3/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "UrlConfig.h"

@implementation UrlConfig

//ghOwfR7Wz44cbKU93KVSxwYXPGloNu
NSString *getLoginUrl(){
    
    return @"app/loginOrRegister.json";
}


NSString *getValidateUrl(){
    
    return @"app/vcodeForLoginOrRegister.json";
}

NSString *getAreaListUrl(){
    
    return @"app/areaList.json";
}

NSString *getCityToAreaUrl(){
    
    return @"app/cityToArea.json";
}

NSString *getCarForLeaseUrl(){
    
    return @"app/carForLease.json";
}

NSString *getStationForLeaseUrl(){
    
    return @"app/stationForLease.json";
}

NSString *getStationForReturnUrl(){
    
    return @"app/stationForReturn.json";
}

NSString *getStationCarListUrl(){
    
    return @"app/stationCarList.json";
}


NSString *getUploadVerificationUrl(){
    
    return @"app/uploadAuditImg.json";
    
}


NSString *getBookingCarUrl(){
    
    return @"app/bookingCar.json";
}

NSString *getAliPayUrl(){
    
    return @"app/aliPay.json";
}

NSString *getWXPayUrl(){
    
    return @"app/weixinPay.json";
}

NSString *getAuthUrl(){
    
    return @"app/getMemberStatus.json";
}


NSString *getLeaseUrl(){
    
    return @"app/lease.json";
}

NSString *getLogoutUrl(){
    
    return @"app/logout.json";
}

NSString *getMemberTotalData(){
    
    return @"app/getMemberTotalData.json";
}

NSString *getRentPwd(){
    
    return @"app/getRentPwd.json";
}

NSString *getCarInBookingUrl(){
    
    return @"app/carInBooking.json";
}

NSString *getCarInSearchInfoUrl(){
    
    return @"app/carInSearchInfo.json";
}

NSString *getCarInLeaseUrl(){
    
    return @"app/carInLease.json";
}

NSString *getCancelBookingCarUrl(){
    
    return @"app/cancelBookingCar.json";
}

NSString *getOpenBookingCarUrl(){
    
    return @"app/openBookingCar.json";
}

NSString *getOpenCarDirectlyUrl(){
    
    return @"app/openCarDirectly.json";
}

NSString *getSearchStationUrl(){
    
    return @"app/searchStation.json";
}

NSString *getSearchCarForLeaseUrl(){
    
    return @"app/searchCarForLease.json";
}

NSString *getMemberAccountUrl(){
    
    return @"app/getMemberAccount.json";
}


NSString *getMemberAgreementUrl(){
    
    return @"app/getMemberAgreementUrl.json";
}


NSString *getOpenOrCloseLeaseCarUrl(){
    
    return @"app/openOrCloseLeaseCar.json";
}

NSString *getReturnCarUrl(){
    
    return @"app/returnCar.json";
}

NSString *getServicePhoneUrl(){
    
    return @"app/getServicePhone.json";
}

NSString *getAppVersionUrl(){
    
    return @"app/getAppVersion.json";
}

NSString *getChekItemForReturnCar(){
    
    return @"app/chekItemForReturnCar.json";
}

NSString *getEstimateLeaseFee(){
    
    return @"app/estimateLeaseFee.json";
}

NSString *uploadHeadImg(){
    
    return @"app/uploadHeadImg.json";
}

NSString *downloadHeadImg(){
    
    return @"app/downloadHeadImg";
}

NSString *uploadArtificialAuditImg(){
    
    return @"app/uploadArtificialAuditImg.json";
}

NSString *getNumberPlatePrefix(){
    
    return @"app/getNumberPlatePrefix.json";
}

NSString *couponList(){
    
    return @"app/couponList.json";
}

NSString *getMemberImg(){
    
    return @"app/getMemberImg.json";
}

NSString *updateMemberInfo(){
    
    return @"app/updateMemberInfo.json";
}

NSString *getMemberGuideAgreement(){
    
    return @"app/getMemberGuideAgreementUrl.json";
}

NSString *getMemberFRFAgreement(){
    
    return @"app/getMemberFRFAgreementUrl.json";
}

NSString *uploadLatLng(){
    
    return @"app/uploadLatLngUrl.json";
}

NSString *getCarInfo(){
    
    return @"app/carInfo.json";
}



@end
