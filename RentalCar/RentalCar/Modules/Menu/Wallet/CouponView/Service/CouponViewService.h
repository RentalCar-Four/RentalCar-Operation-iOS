//
//  CouponViewService.h
//  RentalCar
//
//  Created by Hulk on 2017/4/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseService.h"

@interface CouponViewService : BaseService
- (void)requesCouponListWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
@end
