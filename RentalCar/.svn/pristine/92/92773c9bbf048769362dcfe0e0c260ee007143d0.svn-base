//
//  defaultDataView.m
//  RentalCar
//
//  Created by Hulk on 2017/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "defaultDataView.h"

@implementation defaultDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return  self;
}

-(void)layoutSubviews{
    [self setUp];
}

-(void)setUp{
    UILabel *openLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, autoScaleW(212), kScreenWidth, autoScaleH(20))];
    [self setBackgroundColor:[UIColor colorWithHexString:@"#FBFBFB"]];
    
    [openLabel setText:@"开启小灵狗与你的第一段行程"];
    [openLabel setFont:[UIFont systemFontOfSize:autoScaleH(14)]];
    [openLabel setTextColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    
    [openLabel setTextAlignment:NSTextAlignmentCenter];
    UIButton *openbutton =[[UIButton alloc]initWithFrame:CGRectMake(self.width/2-autoScaleW((176)/2), autoScaleW(262), autoScaleW(176), autoScaleH(40))];
    [openbutton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [openbutton setTitle:@"马上用车" forState:UIControlStateNormal];
    [openbutton.titleLabel setFont:[UIFont systemFontOfSize:autoScaleH(14)]];
    
    [openbutton setTitleColor:[UIColor colorWithHexString:@"#9F9F9F"] forState:UIControlStateNormal];
     [[APPUtil share] setButtonClickStyle:openbutton Shadow:NO normalBorderColor:[UIColor colorWithHexString:@"#E7EDEA"] selectedBorderColor:[UIColor colorWithHexString:@"EEEEEE"] BorderWidth:1 normalColor:[UIColor colorWithHexString:@"#FCFCFC"] selectedColor:[UIColor colorWithHexString:@"F5F5F5"] cornerRadius:autoScaleH(5)];
    [openbutton.layer setCornerRadius:5];
    [openbutton.layer setBorderColor:[UIColor colorWithHexString:@"#E7EDEA "].CGColor];
    [openbutton.layer setBorderWidth:1];
    [openbutton addTarget:self action:@selector(backMap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:openLabel];
    [self addSubview:openbutton];
    
    if (_PushType == 1) {
        [openbutton setHidden:YES];
        [openLabel setText:@"暂无优惠券"];
    }else if (_PushType ==2){
        [openbutton setHidden:NO];
        [openbutton setTitle:@"查看已失效优惠券" forState:UIControlStateNormal];
        [openLabel setText:@"暂无可用优惠券"];
    }
    else{
        
        
    }
}

-(void)backMap:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(backMap)]) {
        [self.delegate backMap];
    }
    
    if ([self.delegate respondsToSelector:@selector(openInvalid:)]) {
        [self.delegate openInvalid:button];
    }
}
@end
