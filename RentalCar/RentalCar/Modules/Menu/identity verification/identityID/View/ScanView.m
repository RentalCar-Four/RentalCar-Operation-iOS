//
//  ScanView.m
//  RentalCar
//
//  Created by Hulk on 2017/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ScanView.h"

@interface ScanView ()

@end

@implementation ScanView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    
    return  self;
}
-(void)setUp{
    [self setBorderColor:[UIColor colorWithHexString:@"#CECECE"]];
    self.borderType = BorderTypeDashed;
    self.dashPattern = 6;
    self.spacePattern = 7;
    self.borderWidth = 1;
    self.cornerRadius = 10;
    _animationView  = [[UIImageView alloc]init];
    [_animationView setBackgroundColor:[UIColor colorWithHexString:@"#fbfbfb"]];
    [self.animationView setImage:[UIImage imageNamed:@"motion_cardscan0071"]];
    [self.animationView setFrame:CGRectMake(self.width/2-(autoScaleW(94)/2), self.height/2-(autoScaleH(64)/2), autoScaleW(94), autoScaleH(64))];
    [self addSubview:_animationView];
    
    
    
    [APPUtil runAnimationWithCount:71 name:@"motion_cardscan00" imageView:self.animationView repeatCount:1 animationDuration:0.03];
    
    
    CGFloat scanY = CGRectGetMaxY(_animationView.frame);
    _scanTitle = [[UILabel alloc]init];
    [_scanTitle setText:@"扫描身份证"];
    [_scanTitle setTextColor:[UIColor colorWithHexString:@"#CFCFCF"]];
    [_scanTitle setTextAlignment:NSTextAlignmentCenter];
    [_scanTitle setFont:[UIFont systemFontOfSize:14]];
    [_scanTitle setFrame:CGRectMake(self.width/2-(autoScaleW(140)/2), scanY+15, autoScaleW(140), autoScaleH(20))];
    [self addSubview:_scanTitle];
    
    _cardIdImgView =[[UIImageView alloc]init];
    
    [_cardIdImgView setFrame:CGRectMake(self.width/2 -autoScaleW(311/2), self.height/2 -autoScaleW(181/2), autoScaleW(311), autoScaleW(181))];
    [_cardIdImgView setContentMode:UIViewContentModeScaleAspectFill];
    _cardIdImgView.clipsToBounds = YES;
    
    [self addSubview:_cardIdImgView];
}
@end

