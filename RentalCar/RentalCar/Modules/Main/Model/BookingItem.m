//
//  BookingItem.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BookingItem.h"

@implementation BookingItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"ID" : @"id"};
}

- (void)setSoc:(NSString *)soc {
    _soc = soc;
    if ([APPUtil isBlankString:_soc]) {
        _soc = @"0";
    }
}

@end
