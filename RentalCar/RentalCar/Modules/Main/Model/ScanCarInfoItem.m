//
//  ScanCarInfoItem.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ScanCarInfoItem.h"

@implementation ScanCarInfoItem

- (void)setSoc:(NSString *)soc {
    _soc = soc;
    if ([APPUtil isBlankString:_soc]) {
        _soc = @"0";
    }
}

@end
