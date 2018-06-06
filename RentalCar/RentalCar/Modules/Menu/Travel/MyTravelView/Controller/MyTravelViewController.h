//
//  MyTravelViewController.h
//  RentalCar
//
//  Created by Hulk on 2017/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"



@interface MyTravelViewController : BaseController
@property (nonatomic , copy) void (^getSelectRentNum)(NSString *rentNum);
@end
