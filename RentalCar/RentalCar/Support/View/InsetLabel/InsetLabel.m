//
//  InsetLabel.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/30.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "InsetLabel.h"

@implementation InsetLabel

//初始化方法一
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

//初始化方法二
-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

//重载drawTextInRect方法
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
