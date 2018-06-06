//
//  ClusterAnnotationView.h
//  RentalCar
//
//  Created by zhanbing han on 17/4/11.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface ClusterAnnotationView : MAAnnotationView<MAAnnotation>
{
    UILabel *label;
}

- (void)setClusterText:(NSString *)text;

@property (nonatomic ,readonly) CLLocationCoordinate2D coordinate;

@end
