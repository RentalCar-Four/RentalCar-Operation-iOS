//
//  LoginItem.m
//  RentalCar
//
//  Created by hu on 17/3/4.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "LoginItem.h"

@interface LoginItem() <YYModel>

@end

@implementation LoginItem


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"token" : @"result.token",
             @"memberId":@"result.memberId"};
}
@end
