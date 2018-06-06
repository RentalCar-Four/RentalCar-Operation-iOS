//
//  UIView+Animation.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/27.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , AShowAnimationStyle) {
    ASAnimationDefault    = 0,
    ASAnimationLeftShake  ,
    ASAnimationTopShake   ,
    ASAnimationNO         ,
};

@interface UIView (Animation)

- (void)setShowAnimationWithStyle:(AShowAnimationStyle)animationStyle;

@end
