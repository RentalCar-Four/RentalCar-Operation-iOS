//
//  HideFormView.m
//  RentalCar
//
//  Created by Hulk on 2017/3/15.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "HideFormView.h"

@implementation HideFormView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    [self drawBox:self.IDCardBoxRect Context:ctx];
    [self drawLayerCornerFrame:self.IDCardBoxRect Context:ctx];

}

/**
 *  绘制一块区域，该区域为透明色，其余位置为半透明
 *
 *  @param box 区域
 *  @param ctx contextref
 */
- (void)drawBox:(CGRect)box Context:(CGContextRef)ctx{
    CGColorRef bgColor = CGColorCreateCopyWithAlpha([UIColor blackColor].CGColor, 0.6);
    
    CGContextSetFillColorWithColor(ctx, bgColor);
    CGContextFillRect(ctx, self.bounds);
    CGContextClearRect(ctx, box);
    
    CGColorRelease(bgColor);
}

/**
 *  在一个长方形内画四个边角
 *
 *  @param ctx  CGContextRef
 *  @param rect 长方形区域
 */
- (void)drawLayerCornerFrame:(CGRect)rect Context:(CGContextRef )ctx{
    CGContextSetStrokeColorWithColor(ctx, UIColorFromValueAlpha(37, 216, 128, 1).CGColor);
    CGContextSetLineWidth(ctx, 1.5f);
    
    CGFloat cHeight = 15.0f;
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect)+cHeight);
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect)+cHeight, CGRectGetMinY(rect));
    
    CGContextMoveToPoint(ctx, CGRectGetMaxX(rect)-cHeight, CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect)+cHeight);
    
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect)-cHeight);
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect)+cHeight, CGRectGetMaxY(rect));
    
    CGContextMoveToPoint(ctx, CGRectGetMaxX(rect)-cHeight, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect)-cHeight);
    
    CGContextDrawPath(ctx, kCGPathStroke);
}
@end