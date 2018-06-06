//
//  walletService.h
//  RentalCar
//
//  Created by Hulk on 2017/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseService.h"

@interface walletService : BaseService
- (void)requestgetMemberAccountWithService:(NSDictionary *)param success:(void(^)(id))success fail:(void(^)(NSString *))fail;
@end
