//
//  MemberTotalDataModel.h
//  RentalCar
//
//  Created by Hulk on 2017/3/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface MemberTotalDataModel : BaseItem
@property(nonatomic,copy)NSString *memberId;//会员 ID
@property(nonatomic,copy)NSString *totalCarbon;//节约碳排放
@property(nonatomic,copy)NSString *totalMileage;//累计里程
@property(nonatomic,copy)NSString *totalMinutes;//累计时长
@end
