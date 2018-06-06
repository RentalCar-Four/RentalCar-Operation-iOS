//
//  OnlineCarListVC.h
//  RentalCar
//
//  Created by MEyo on 2018/5/30.
//  Copyright © 2018年 xyx. All rights reserved.
//

#import "BaseController.h"
#import "StationCarItem.h"
#import "LocationTransform.h"

typedef void(^carItemBlock)(StationCarItem *carItem);

@interface OnlineCarListVC : BaseController

- (instancetype)initWithLocation:(LocationTransform *)location;

@property (nonatomic, copy) carItemBlock carBlock;

@end
