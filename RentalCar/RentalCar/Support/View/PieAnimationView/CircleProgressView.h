//
//  CircleProgressView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseView.h"

@interface CircleProgressView : BaseView

-(instancetype)initWithFrame:(CGRect)frame andPercent:(float)percent andColor:(UIColor *)color;

-(void)reloadViewWithPercent:(float)percent;

@end
