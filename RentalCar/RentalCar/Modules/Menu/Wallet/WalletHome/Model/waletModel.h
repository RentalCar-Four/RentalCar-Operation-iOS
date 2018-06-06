//
//  waletModel.h
//  RentalCar
//
//  Created by Hulk on 2017/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface waletModel : BaseItem
@property(nonatomic,copy)NSString *deposit;//保证金
@property(nonatomic,copy)NSString *amount;//余额
@property(nonatomic,copy)NSString *memberState;//押金状态
@end
