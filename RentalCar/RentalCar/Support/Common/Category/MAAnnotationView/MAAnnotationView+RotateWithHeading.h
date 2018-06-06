//
//  MAAnnotationView+RotateWithHeading.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/8.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface MAAnnotationView (RotateWithHeading)

//根据heading信息旋转大头针视图
- (void)rotateWithHeading:(CLHeading *)heading;

@end
