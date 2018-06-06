//
//  CarFeeDetailView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/29.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  行程结束费用明细View
 *
 */

#import "BaseView.h"

@interface CarFeeDetailView : BaseView

@property (nonatomic,copy) dispatch_block_t doneBlock;

@property (nonatomic,retain) NSDictionary *resultDic;

@end
