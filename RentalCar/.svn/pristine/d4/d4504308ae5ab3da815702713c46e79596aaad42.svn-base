//
//  ClusterAnnotationView.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/11.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ClusterAnnotationView.h"

@implementation ClusterAnnotationView

- (id) initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-1);
    }
    return self;
}

- (void) setClusterText:(NSString *)text
{
    label.text = text;
}

@end
