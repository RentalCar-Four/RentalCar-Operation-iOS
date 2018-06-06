//
//  InputNumberView.h
//  RentalCar
//
//  Created by zhanbing han on 17/4/6.
//  Copyright © 2017年 xyx. All rights reserved.
//

/**
 *  输入车牌号View
 *
 */

#import "BaseView.h"

@interface InputNumberView : BaseView

@property (nonatomic,copy) dispatch_block_t closeBlock;
@property (nonatomic, copy) void(^doneBlock)(NSString *value);

@property (nonatomic,retain) NSArray *array;

@end
