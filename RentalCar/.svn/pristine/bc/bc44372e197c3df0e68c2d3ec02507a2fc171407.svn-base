//
//  MGIDBoxLayer.m
//  MGIDCard
//
//  Created by 张英堂 on 16/8/11.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import "MGIDBoxLayer.h"
#import "MGIDCardBundle.h"
#import "MGIDCardConfig.h"

@interface MGIDBoxLayer ()

//@property (nonatomic, strong) UIImage *messageImage;

@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UILabel *messageTextView;

@end

@implementation MGIDBoxLayer

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


//-(UIImage *)messageImage{
//    if (!_messageImage) {
//        NSString *imageName = (self.IDCardSide == IDCARD_SIDE_FRONT ? @"card_front" : @"card_back");
//        
//        _messageImage = [MGIDCardBundle IDCardImageWithName:imageName];
//    }
//    return _messageImage;
//}

-(UIImageView *)messageImageView{
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_messageImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_messageImageView setClipsToBounds:YES];
        
        [self addSubview:_messageImageView];
    }
    return _messageImageView;
}

-(UILabel *)messageTextView{
    if (!_messageTextView) {
        _messageTextView = [[UILabel alloc] initWithFrame:CGRectZero];
        [_messageTextView setFont:[UIFont systemFontOfSize:18]];
        [_messageTextView setTextAlignment:NSTextAlignmentLeft];
        [_messageTextView setTextColor:[UIColor whiteColor]];
        [_messageTextView setNumberOfLines:0];
        
        [self addSubview:_messageTextView];
    }
    return _messageTextView;
}

- (void)drawImage:(UIImage *)image rect:(CGRect)rect{
    
    [self.messageImageView setFrame:rect];
    [self.messageImageView setImage:image];
}

- (void)drawtext:(NSString *)text rect:(CGRect)rect{
    
    [self.messageTextView setFrame:rect];
    [self.messageTextView setText:text];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    [self drawBox:self.IDCardBoxRect Context:ctx];
      NSLog(@"%@",NSStringFromCGRect(self.IDCardBoxRect));
    [self drawLayerCornerFrame:self.IDCardBoxRect Context:ctx];
    
    CGRect imageRect = CGRectZero;
    CGRect textRect = CGRectZero;
    NSString *messageText = nil;
    //这里可以修改扫描身份证页面的ui
    CGFloat whScale = (MGIDCardDefaultScale().WHScale);
    if (CGRectGetMaxX(self.IDCardBoxRect)/rect.size.width > 0.8) {
        self.messageTextView.font = [UIFont systemFontOfSize:15];
        [self.messageTextView setTextAlignment:NSTextAlignmentCenter];

//        imageRect = CGRectMake(self.IDCardBoxRect.origin.x+CGRectGetWidth(self.IDCardBoxRect)*0.1,
//                              CGRectGetMaxY(self.IDCardBoxRect)+30,
//                              CGRectGetWidth(self.IDCardBoxRect)*0.4,
//                              CGRectGetWidth(self.IDCardBoxRect)*0.4/whScale);
        
        textRect = CGRectMake(CGRectGetMaxX(self.IDCardBoxRect)/2-55,
                              CGRectGetMaxY(self.IDCardBoxRect),
                              220,
                              45);
    }else{
        //修改sdk里扫描身份证的样式);
        
        //设置扫描文字样式居中
        
        self.messageTextView.font = [UIFont systemFontOfSize:15];
        
//        imageRect = CGRectMake(CGRectGetMaxX(self.IDCardBoxRect)+25,
//                               CGRectGetMinY(self.IDCardBoxRect),
//                               (rect.size.width-CGRectGetMaxX(self.IDCardBoxRect)-25)*0.65,
//                               (rect.size.width-CGRectGetMaxX(self.IDCardBoxRect))*0.8/whScale);
        
        textRect = CGRectMake(CGRectGetMaxX(imageRect),
                              CGRectGetMaxY(imageRect),
                              CGRectGetWidth(imageRect),
                              40);
        

    }
    
    if (self.IDCardSide == IDCARD_SIDE_BACK) {
        messageText = @"请将身份证背面置于框内";
    }else{
        messageText = @"请将身份证正面置于框内";
    }
    
    
//    [self drawImage:self.messageImage rect:imageRect];
    [self drawtext:messageText rect:textRect];
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
    CGContextSetStrokeColorWithColor(ctx, MGColorWithRGB(37, 216, 128, 1).CGColor);
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
