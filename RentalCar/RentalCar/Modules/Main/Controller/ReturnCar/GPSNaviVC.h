//
//  GPSNaviVC.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "StationCarItem.h"

@interface GPSNaviVC : UIViewController

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate; /* 起始点经纬度. */
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoordinate; /* 终点经纬度. */

@end
