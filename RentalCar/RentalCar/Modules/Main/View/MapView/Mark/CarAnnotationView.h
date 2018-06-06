//
//  CarAnnotationView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/9.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "StationCarItem.h"

@interface CarAnnotationView : MAAnnotationView

@property (nonatomic,retain) StationCarItem *item;

@property (strong,nonatomic) UIImageView *imgView; //图片
@property (strong,nonatomic) UILabel *countLab; //数量
@property (strong,nonatomic) UILabel *socLab; //电量
@property (strong,nonatomic) UIImageView *loadImgView; //加载视图

@end
