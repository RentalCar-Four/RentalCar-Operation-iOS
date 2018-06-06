//
//  MAMapView+ShareManager.m
//  RentalCar
//
//  Created by zyl on 17/3/8.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "MAMapView+ShareManager.h"

@implementation MAMapView (ShareManager)

static MAMapView *_mapView = nil;

+ (MAMapView *)shareMAMapView {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapView = [[MAMapView alloc] init];
    });
    return _mapView;
}

//重写allocWithZone保证分配内存alloc相同
+ (id)allocWithZone:(NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapView = [super allocWithZone:zone];
    });
    return _mapView;
}

//保证copy相同
+ (id)copyWithZone:(NSZone *)zone {
    return _mapView;
}

@end
