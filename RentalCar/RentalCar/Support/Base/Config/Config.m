//
//  Config.m
//  RentalCar
//
//  Created by hu on 17/3/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "Config.h"

@implementation Config

NSString* domainUrl(){
    
    NSString *server = [CacherUtil getCacherWithKey:kTestServerKey];
    
//    if (KOnline) {
//        return @"http://api2.evcoming.com:5131/v3/"; //宁波线上服务器地址
//    } else
    if ([APPUtil isBlankString:server]) {
        return @"http://122.246.11.153:5131/v3/"; //宁波测试服务器地址
    } else {
        return @"http://api2.evcoming.com:5131/v3/"; //宁波线上服务器地址
    }
}

@end
