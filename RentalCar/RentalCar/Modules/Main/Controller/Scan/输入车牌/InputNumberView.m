//
//  InputNumberView.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/6.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "InputNumberView.h"
#import "XDYPasswordView.h"
#import "PickerView.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "ScanCarInfoItem.h"

@interface InputNumberView (){
    UIView      *_mainView;
    
    UIButton    *_areaBtn;
    XDYPasswordView  *_passwordTF;
    PickerView  *_pickerView;
    
    UIButton    *_cancelBtn;
    UIButton    *_confirmBtn;
}
@end

@implementation InputNumberView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp{
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside =  NO;
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:1];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:beffect];
    blurView.frame = self.bounds;
    blurView.alpha = 1;
    [self addSubview:blurView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)];
    [blurView addGestureRecognizer:tap];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(28), autoScaleH(160), autoScaleW(320), autoScaleH(200))];
    _mainView.layer.cornerRadius = autoScaleW(10);
    _mainView.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
    _mainView.layer.shadowOpacity = 0.2; //透明度
    _mainView.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    _mainView.layer.shadowRadius = autoScaleW(6); //模糊度
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    
    _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(20), autoScaleH(40), autoScaleW(50), autoScaleH(54))];
    _areaBtn.layer.cornerRadius = autoScaleW(5);
    _areaBtn.layer.borderWidth = autoScaleW(1);
    _areaBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    _areaBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_areaBtn addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_areaBtn];
    
    
    _passwordTF = [[XDYPasswordView alloc] initWithFrame:CGRectMake(autoScaleW(80), autoScaleH(40), autoScaleW(220), autoScaleH(54))];
    _passwordTF.elementCount = 5;
    _passwordTF.elementMargin = autoScaleW(5);
    _passwordTF.elementColor=UIColorFromRGB(0xECECEC);
    [_mainView addSubview:_passwordTF];
    [_passwordTF setNoSecure];
    __block InputNumberView *weakself=self;
    _passwordTF.showKeyboardBlock = ^() {
        [weakself recoverAreaBtnStyle];
    };
    _passwordTF.inputDoneBlock = ^() {
        [weakself setUnLockBtnClicked];
    };
    _passwordTF.inputUnDoneBlock = ^() {
        [weakself setUnLockBtnUnClicked];
    };
    
    //提示
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _mainView.height-autoScaleH(91), _mainView.width, autoScaleH(21))];
    tipLab.text = @"请在确认开锁前认真核对车牌号";
    tipLab.textColor = UIColorFromRGB(0xAAAAAA);
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_mainView addSubview:tipLab];
    
    //取消
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(8), _mainView.height-autoScaleH(56), autoScaleW(110), autoScaleH(48))];
    _cancelBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0xE7EDEA).CGColor;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x9F9F9F) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_cancelBtn];
    
    //确定
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cancelBtn.right+autoScaleW(5), _mainView.height-autoScaleH(56), autoScaleW(190), autoScaleH(48))];
    [[APPUtil share] setButtonClickStyle:_confirmBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    _confirmBtn.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [_confirmBtn.layer setMasksToBounds:YES];
    _confirmBtn.userInteractionEnabled = NO;
    [_confirmBtn setTitle:@"开始用车" forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_confirmBtn];
}

- (void)setArray:(NSArray *)array {
    
    _array = array;
    
    NSDictionary *firstDic = array[0];
    
    NSString *prefixStr = firstDic[@"prefix"];
    if (prefixStr.length>2) {
        prefixStr = [prefixStr substringWithRange:NSMakeRange(0, 2)];
    }
    [_areaBtn setTitle:prefixStr forState:UIControlStateNormal];
    [_areaBtn setTitleColor:UIColorFromRGB(0x4C4C4C) forState:UIControlStateNormal];
}

- (void)recoverAreaBtnStyle {
    _areaBtn.layer.borderWidth = autoScaleW(1);
    _areaBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
}

- (void)setAreaBtnValue:(NSString *)value {

    if (value.length>2) {
        value = [value substringWithRange:NSMakeRange(0, 2)];
    }
    [_areaBtn setTitle:value forState:UIControlStateNormal];
}

- (void)showKeyBoard {
    
    
}

//设置开锁按钮可点击
- (void)setUnLockBtnClicked {
    
    _confirmBtn.backgroundColor = kBlueColor;
    [_confirmBtn.layer setMasksToBounds:NO];
    _confirmBtn.userInteractionEnabled = YES;
}

//设置开锁按钮不可点击
- (void)setUnLockBtnUnClicked {
    
    _confirmBtn.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [_confirmBtn.layer setMasksToBounds:YES];
    _confirmBtn.userInteractionEnabled = NO;
}

#pragma mark - methods

//显示动画
- (void)showAnimation {
    _mainView.top = autoScaleH(267/2)+30;
    _mainView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.top = autoScaleH(267/2);
        _mainView.alpha = 1;
    } completion:nil];
}

//消失动画
- (void)hideAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        _mainView.top = autoScaleH(267/2)+30;
        _mainView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//关闭
- (void)closeAction {
    
    [self hideAnimation];
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

//确定
- (void)confirmAction {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",_areaBtn.titleLabel.text,_passwordTF.textField.text];
    NSLog(@"jkrvbkrjnvt%@",str);
    
    if (self.doneBlock) {
        
        [_passwordTF.textField resignFirstResponder];
        self.doneBlock(str);
    }
}

- (void)selectArea:(UIButton *)btn {
    
    btn.layer.borderWidth = autoScaleW(2);
    btn.layer.borderColor = UIColorFromRGB(0x25D880).CGColor;
    
    [_passwordTF dismissFocus];
    
    _pickerView = [PickerView pickerView];
    _pickerView.array = self.array;
    [self addSubview:_pickerView];
    [_pickerView show];
    
    __block InputNumberView *weakself=self;
    _pickerView.doneBlock = ^(NSString *value) {
        
        [weakself setAreaBtnValue:value];
        
        [weakself confirmPicker];
    };
}

- (void)confirmPicker {
    [_passwordTF getFocus];
    [self recoverAreaBtnStyle];
}

@end
