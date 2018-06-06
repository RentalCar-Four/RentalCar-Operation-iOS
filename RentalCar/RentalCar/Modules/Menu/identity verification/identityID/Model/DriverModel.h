//
//  DriverModel.h
//  RentalCar
//
//  Created by Hulk on 2017/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface DriverModel : BaseItem
@property(nonatomic,copy)NSString *driverAuditPassed;
@property(nonatomic,copy)NSString *driverCarType;
@property(nonatomic,copy)NSString *driverNo;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *vName;
@end
