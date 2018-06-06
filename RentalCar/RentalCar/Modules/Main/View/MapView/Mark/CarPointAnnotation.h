//
//  CarPointAnnotation.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/10.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class StationCarItem;

@interface CarPointAnnotation : MAPointAnnotation

@property (nonatomic,retain) StationCarItem *item;

/** 标注点的protocol，提供了标注类的基本信息函数*/
@property (nonatomic,weak) id<MAAnnotation> delegate;

@end
