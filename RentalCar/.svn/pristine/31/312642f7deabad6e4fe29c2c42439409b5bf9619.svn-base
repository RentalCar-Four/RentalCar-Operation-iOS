//
//  ToastView.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/24.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ToastView.h"
#import "InsetLabel.h"

@interface ToastView ()
{
    InsetLabel *_textLabel;
    UIButton *_contentView;
}
@end

@implementation ToastView

- (instancetype)initWithText:(NSString *)text
{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp:text];
    }
    return self;
}

- (void)setUp:(NSString *)text {
    
    UIFont *font = [UIFont systemFontOfSize:autoScaleW(16)];
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[text boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    _textLabel = [[InsetLabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width>autoScaleW(300)?autoScaleW(300):rect.size.width+40, autoScaleH(50))];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = font;
    _textLabel.text = text;
    _textLabel.insets = UIEdgeInsetsMake(5, 5, 5, 5);//通过设置insets属性直接设置Label的内边距。
    
    _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _textLabel.width, _textLabel.height)];
    _contentView.layer.cornerRadius = autoScaleW(5);
    _contentView.backgroundColor = UIColorFromRGB(0x393E44);
    [APPUtil setViewShadowStyle:_contentView];
    [_contentView addSubview:_textLabel];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _contentView.alpha = 0.0f;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:_contentView];
    
    _contentView.layer.cornerRadius = autoScaleW(5);
    [APPUtil setViewShadowStyle:_contentView];
    _contentView.center = CGPointMake(window.center.x, window.center.y);
}

- (void)show {
    
    [UIView animateWithDuration:0.0 animations:^{
        _contentView.alpha = 0.95f;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _contentView.alpha = 0.0f;
            }];
        });
    }];
}

@end
