//
//  SignKeyUtil.h
//  RentalCar
//
//  Created by hu on 17/3/3.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignKeyUtil : NSObject

/**
 * 干扰码
 */
+ (NSString *)getNonceString;

/**
 * 参数的MD5签名值【根据字典】
 */
+ (NSString *)getSignByDic:(NSMutableDictionary *)params withType:(NSString *)type;

/**
 * 参数的MD5签名值【根据字符串】
 */
+ (NSString *)getSignByStr:(NSString *)url withType:(NSString *)type;

@end
