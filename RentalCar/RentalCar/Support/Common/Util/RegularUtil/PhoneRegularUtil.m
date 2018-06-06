//
//  RegularUtil.m
//  RentalCar
//
//  Created by hu on 17/3/5.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "PhoneRegularUtil.h"

@implementation PhoneRegularUtil


+ (BOOL)validatePhoneRegular:(NSString *)phoneNumber
{
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNumber.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNumber];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNumber];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNumber];
        
//        if (isMatch1 || isMatch2 || isMatch3) {
//            return YES;
//        }else{
//            return NO;
//        }
        
        if ([[phoneNumber substringToIndex:1] isEqualToString:@"1"]) {
            return YES;
        }else{
            return NO;
        }
        
    }
}

@end


