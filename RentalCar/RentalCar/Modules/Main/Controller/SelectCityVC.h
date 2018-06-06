//
//  SelectCityVC.h
//  RentalCar
//
//  Created by Jason on 2018/1/4.
//  Copyright © 2018年 xyx. All rights reserved.
//

#import "BaseController.h"
#import "BackProtocol.h"

@interface SelectCityVC : BaseController

@property (nonatomic, weak)  id<BackProtocol> backDelegate;

@end
