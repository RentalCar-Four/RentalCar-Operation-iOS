//
//  XDYScanController.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"
#import "BackProtocol.h"

@interface XDYScanController : BaseController

@property (nonatomic, weak)  id<BackProtocol> backDelegate;

@end
