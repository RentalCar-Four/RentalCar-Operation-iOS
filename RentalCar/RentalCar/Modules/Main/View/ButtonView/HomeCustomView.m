//
//  HomeCustomView.m
//  SMMenuButton
//
//  Created by zhanbing han on 2017/10/16.
//  Copyright © 2017年 朱思明. All rights reserved.
//

#import "HomeCustomView.h"

#define BUTTONWIDTH autoScaleW(44)
#define BUTTONHEIGHT autoScaleW(44)

@interface HomeCustomView ()
{
    UIView *buttonView;
    UIButton *firstBtn;
}
@end

@implementation HomeCustomView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.clipsToBounds = YES;
    firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(1, 0, BUTTONWIDTH, BUTTONHEIGHT)];
    firstBtn.backgroundColor = [UIColor whiteColor];
//    [firstBtn setTitle:@"空闲" forState:0];
    [firstBtn setImage:[UIImage imageNamed:@"menu"] forState:0];
    [firstBtn setTitleColor:[UIColor blackColor] forState:0];
    [firstBtn addTarget:self action:@selector(buttonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:firstBtn];
    [firstBtn.layer setCornerRadius:autoScaleW(10.0)];
    [APPUtil setViewShadowStyle:firstBtn];
    
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, BUTTONWIDTH, (BUTTONHEIGHT+10)*4)];
    buttonView.height = 0;
//    buttonView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    buttonView.clipsToBounds = YES;
    [self addSubview:buttonView];
}

- (void)buttonTouchAction:(UIButton *)sender{
    if (buttonView.height==0) {
        [self showView];
    }else{
        [self hiddenView];
    }
    [self refreshButtonView];
}




- (void)TouchActions:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    if ([firstBtn.currentTitle isEqualToString:sender.currentTitle]) {
        [self hiddenView];
        return;
    }
    if (_TouchAction) {
        _TouchAction(sender.currentTitle,sender.tag-10);
//        [firstBtn setTitle:sender.currentTitle forState:0];
    }
    [self hiddenView];
    for (NSInteger i = 0; i < _buttonIconNormalArr.count; i ++) {
        UIButton *btn = [buttonView viewWithTag:10+i];
        if (![sender isEqual:btn]) {
            btn.selected = NO;
        }
    }
}

- (void)hiddenView{
    CGFloat bgViewTop = SCREEN_HEIGHT-autoScaleH(100)-(BUTTONHEIGHT+10)*1;
    CGFloat bgViewHeight = (BUTTONHEIGHT+10)*1;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = bgViewTop;
        self.height = bgViewHeight;
        firstBtn.top = self.height- BUTTONHEIGHT;
        buttonView.height = 0;
    } completion:^(BOOL finished) {
    } ];
    
}

- (void)showView{
    CGFloat bgViewTop = SCREEN_HEIGHT-autoScaleH(100)-(BUTTONHEIGHT+10)*5;
    CGFloat bgViewHeight = (BUTTONHEIGHT+10)*5;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = bgViewTop;
        self.height = bgViewHeight;
        firstBtn.top = self.height- BUTTONHEIGHT;
        buttonView.height = (BUTTONHEIGHT+10)*4;
    } completion:^(BOOL finished) {
    } ];
}

- (void)refreshButtonView{
    for (NSInteger i = 0; i < _buttonNameArr.count; i ++) {
        UIButton *btn = [buttonView viewWithTag:10+i];
        btn.frame = CGRectMake(0, i*(BUTTONHEIGHT+10)+10, BUTTONWIDTH, BUTTONHEIGHT);
    }
}


- (void)setButtonNameArr:(NSArray *)buttonNameArr{
    //    buttonNameArr = @[@"空闲1",@"空闲2",@"空闲3",@"空闲4"];
    if (_buttonNameArr != buttonNameArr) {
        _buttonNameArr = buttonNameArr;
    }
    [buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < buttonNameArr.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*(BUTTONHEIGHT+10)+10, BUTTONWIDTH, BUTTONHEIGHT)];
        btn.cornerRadius = 3;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:buttonNameArr[i] forState:0];
        btn.titleLabel.numberOfLines = 0;
        [buttonView addSubview:btn];
        btn.borderColor = [UIColor redColor];
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(TouchActions:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
        }
    }
    
}

- (void)setButtonIconNormalArr:(NSArray *)buttonIconNormalArr{
    if (_buttonIconNormalArr != buttonIconNormalArr) {
        _buttonIconNormalArr = buttonIconNormalArr;
    }
    [buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < buttonIconNormalArr.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*(BUTTONHEIGHT+10)+10, BUTTONWIDTH, BUTTONHEIGHT)];
        [btn.layer setCornerRadius:autoScaleW(10.0)];
        [APPUtil setViewShadowStyle:btn];
        btn.backgroundColor = [UIColor whiteColor];
//        [btn setTitle:buttonNameArr[i] forState:0];
        [btn setImage:[UIImage imageNamed:buttonIconNormalArr[i]] forState:0];
         [btn setImage:[UIImage imageNamed:_buttonIconSelectArr[i]] forState:UIControlStateSelected];
        btn.titleLabel.numberOfLines = 0;
        [buttonView addSubview:btn];
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(TouchActions:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
        }
    }
}

- (void)resetView{
    [self hiddenView];
    for (NSInteger i = 0; i < _buttonIconNormalArr.count; i ++) {
        UIButton *btn = [buttonView viewWithTag:10+i];
        if (i==0) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
