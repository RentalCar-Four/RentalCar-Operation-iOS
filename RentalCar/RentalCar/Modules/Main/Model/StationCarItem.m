//
//  StationCarItem.m
//  RentalCar
//
//  Created by Jason on 2017/12/25.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "StationCarItem.h"

@implementation StationCarItem

- (void)setDistance:(NSString *)distance {
    
    int dis = [distance intValue];
    
    if (dis>999) {
        
        if (dis>10000) {
            _distance = @">10KM";
        } else {
            CGFloat kmValue = (CGFloat)dis/1000;
            _distance = [NSString stringWithFormat:@"%.1fKM",kmValue];
        }
        
    } else {
        _distance = [NSString stringWithFormat:@"%0.0dM",dis];
    }
}

- (void)setSoc:(NSString *)soc {
    _soc = soc;
    if ([APPUtil isBlankString:_soc]) {
        _soc = @"0";
    }
}

@end
