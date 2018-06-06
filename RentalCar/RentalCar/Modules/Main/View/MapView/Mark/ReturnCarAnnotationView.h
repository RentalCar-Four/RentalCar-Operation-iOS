//
//  ReturnCarAnnotationView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "StationCarItem.h"

@interface ReturnCarAnnotationView : MAAnnotationView

@property (nonatomic,retain) StationCarItem *item;

@property (strong,nonatomic) UIImageView *imgView; //图片
@property (strong,nonatomic) UILabel *countLabel; //状态视图

@end
