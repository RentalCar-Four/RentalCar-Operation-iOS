//
//  LoginView.m
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#define kOptionalColor     [UIColor colorWithRed:135/255.0 green:180/255.0 blue:239/255.0 alpha:1.0]
#define kGrayColor         [UIColor colorFromHexCode:@"#C4C4C4"]

#import "XDYLoginView.h"
#import "CountDownTimer.h"
#import "LoginParamItem.h"
#import "RegularView.h"
#import "APPUtil.h"
#import "PhoneRegularUtil.h"
#import "LoginArealist.h"


@interface XDYLoginView() <CountDownTimerDelegate> {
    CountDownTimer *timer;
}

@property (nonatomic, strong) UILabel *titleLabel; //标题 - 小灵狗车务

@property (nonatomic, strong) RegularView *phoneField;       //手机号输入框
@property (nonatomic, strong) UITextField *validateField;    //验证码输入框
@property (nonatomic, strong) UITextField *bgValidateField;  //验证码输入框背景
@property (nonatomic, strong) UIButton *fetchValidateBtn;    //获取验证码按钮
@property (nonatomic, strong) UIButton *loginBtn;            //登陆按钮

@property (nonatomic, strong) UILabel *errorLable;           //错误提示

@end

@implementation XDYLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneVule:) name:@"needAreaValue" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldEditChanged:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:self.phoneField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldEditChanged:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:self.validateField];
    }
    
    return  self;
}

- (void)setUp{
    
    timer = [CountDownTimer new];
    timer.timerDelegate = self;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.phoneField];
    [self addSubview:self.bgValidateField];
    [self addSubview:self.validateField];
    
    [self addSubview:self.fetchValidateBtn];
    [self setViewEnable:self.fetchValidateBtn and:NO];

    [self addSubview:self.loginBtn];
    [self setViewEnable:self.loginBtn and:NO];

    [self addSubview:self.errorLable];
//    [coverPhoneView bringSubviewToFront:phoneField];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    int navHeight = 44 + StatusBarHeight;
    int paddingLeftRight = 25;
    
    @weakify(self);
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.mas_equalTo(self.superview.mas_top).offset(navHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - navHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.mas_equalTo(self).offset(30);
        make.centerX.mas_equalTo(self);
    }];
    
    /***输入号码****/
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(54);
        make.left.mas_equalTo(self).offset(25);
        make.right.mas_equalTo(self).offset(-25);
        make.height.mas_equalTo(45);
    }];
    
    //验证码输入背景
    [self.bgValidateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneField.mas_bottom).offset(14);
        make.left.and.right.and.height.mas_equalTo(self.phoneField);
    }];
    
    /** 错误提示 */
    [self.errorLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.validateField.mas_bottom).offset(20);
        make.left.and.right.mas_equalTo(self.phoneField);
        make.height.mas_equalTo(@16);
    }];
    
    /** 验证码按钮 **/
    [self.fetchValidateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.bgValidateField).offset(-15);
        make.centerY.mas_equalTo(self.bgValidateField);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
    //验证码输入
    [self.validateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.mas_equalTo(self.bgValidateField);
        make.right.mas_equalTo(self.fetchValidateBtn.mas_left).offset(-8);
    }];
    
    /***登录****/
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.left.and.right.equalTo(self.phoneField);
        make.bottom.mas_equalTo(self).offset(-41);
        make.height.mas_equalTo(44);
    }];
    
}


- (void)showAreaView:(Boolean)isVisiable {
    
}
         
- (void)updateCheckViewConstrains:(UIView *) view and:(int)height {
    
    [self layoutIfNeeded];
 }

- (void)onValidateClick{
  
    if ([self.loginDelegate respondsToSelector:@selector(onClickWithValidateEvent:)]) {
        
        NSString *phone = self.phoneField.text;
        [self.phoneField endEditing:YES];
       
        if ([PhoneRegularUtil validatePhoneRegular:phone]) {
            
            self.errorLable.hidden = YES;
            phone = [phone stringByReplacingOccurrencesOfString:@" " withString: @""];
            
            [self.loginDelegate onClickWithValidateEvent:phone];
            
            [timer onCountDownTimer:59];
            
            phone = nil;

        }else{
            
            self.errorLable.hidden = NO;
            self.errorLable.text = @"手机号码错误！";
        }
      
    }
}

- (void)onLoginClick{
    
    self.loginBtn.backgroundColor = kBlueColor;
    [self.loginBtn.layer setMasksToBounds:NO];
    
    NSString *phone = self.phoneField.text;
    
    if ([PhoneRegularUtil validatePhoneRegular:phone]) { //手机号没问题
        
        self.errorLable.hidden = YES;
        
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.item.mobile = phone;
        self.item.vcode = self.validateField.text;
        self.item.deviceCode = kDeviceUuidString;
        
        self.item.areaId = _areaId;
        
        if ([self.loginDelegate respondsToSelector:@selector(onClickWithLoginEvent:)]) {
            [self.loginDelegate onClickWithLoginEvent:self.item];
        }
        self.item = nil;
        
    } else {
        
        self.errorLable.hidden = NO;
        self.errorLable.text = @"手机号码错误！";
    }
}

- (void)onRefreshTimer:(NSString *)cutTimer{
    
    [self setViewEnable:self.fetchValidateBtn and:NO];
    NSString *time = [NSString stringWithFormat:@"正在获取%@秒",cutTimer];
    [self.fetchValidateBtn setTitle:time forState:UIControlStateNormal];
    self.fetchValidateBtn.titleLabel.font = [UIFont systemFontOfSize:13];

}

- (void)onTimerOut{
    
    [self setViewEnable:self.fetchValidateBtn and:YES];
    [self.fetchValidateBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.fetchValidateBtn.titleLabel.font = [UIFont systemFontOfSize:14];

}

- (void)resetValidateCode{
    
    self.validateField.text = nil;
    [self setViewEnable:self.loginBtn and:NO];
}

- (void)notifyStopTimer {
    
    [timer stopTimer];
}

-(void)textFieldEditChanged:(NSNotification *)obj{
    
    int maxLength = 0;
    
    UITextField *textField = (UITextField *)obj.object;
    if ([textField isKindOfClass: [RegularView class]]) {
        
        maxLength = 13;
        
    }else{
        
        maxLength = 6;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

        if (!position) {
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:6];
            }
        }
       
    }
    if (toBeString.length >= maxLength) {
        textField.text = [toBeString substringToIndex:maxLength];
        
        if (self.phoneField.text.length == 13 && self.validateField.text.length == 6) {

            [self setViewEnable:self.loginBtn and:YES];
            
        }
        if (self.phoneField.text.length == 13) {
            [self setViewEnable:self.fetchValidateBtn and:YES];
        }
        
    }else{

        [self setViewEnable:self.loginBtn and:NO];
        if (maxLength == 13) {
            [self setViewEnable:self.fetchValidateBtn and:NO];
        }
    }
    
}

- (LoginParamItem *)item {
    if (_item == nil) {
        _item = [[LoginParamItem alloc]init];
    }
    return _item;
}

- (void)doneVule:(NSNotification *)sender{

    if (sender.object) {
        
        NSString *titleName = [sender.object objectForKey:@"areaName"];
        self.areaId = [sender.object objectForKey:@"areaId"];
    }

}

- (void)setViewEnable:(UIControl *)view and:(BOOL)enable{
    
    if (enable) {
        view.enabled = YES;
        view.alpha = 1;
        
    }else{
        view.enabled = NO;
        view.alpha = 0.6;
    }
}

#pragma mark - Lazy Loading 改版新加

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"小灵狗车务";
        _titleLabel.textColor = [UIColor colorFromHexCode:@"#232627"];
        _titleLabel.font = [ UIFont systemFontOfSize:32];
    }
    return _titleLabel;
}

- (RegularView *)phoneField {
    
    if (!_phoneField) {
        _phoneField = [[RegularView alloc] init];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneField.placeholder = @"手机号码";
        _phoneField.leftImage = [UIImage imageNamed:@"icon_phone"];
        _phoneField.font = kArialSize(0);
        _phoneField.textColor = [UIColor blackColor];
        _phoneField.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    return _phoneField;
}

- (UITextField *)validateField {
    
    if (!_validateField) {
        _validateField = [[UITextField alloc] init];
        _validateField.keyboardType = UIKeyboardTypeNumberPad;
        _validateField.placeholder = @"验证码";
        _validateField.font = kArialSize(0);
        _validateField.textColor = [UIColor blackColor];
        
        UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 52, 26)];
        leftImgView.image = [UIImage imageNamed:@"icon_password"];
        leftImgView.contentMode = UIViewContentModeScaleAspectFit;
        _validateField.leftView = leftImgView;
        _validateField.leftViewMode = UITextFieldViewModeAlways;
        _validateField.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    return _validateField;
}

- (UITextField *)bgValidateField {
    
    if (!_bgValidateField) {
        _bgValidateField = [[UITextField alloc] init];
        _bgValidateField.borderStyle = UITextBorderStyleRoundedRect;
        _bgValidateField.layer.cornerRadius = 10;
    }

    return _bgValidateField;
}

- (UIButton *)fetchValidateBtn {
    
    if (!_fetchValidateBtn) {
        _fetchValidateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _fetchValidateBtn.titleLabel.font = kArialSize(-1);
        [_fetchValidateBtn setBackgroundColor:kBlueColor];
        [_fetchValidateBtn.layer setMasksToBounds:YES];
        [_fetchValidateBtn.layer setCornerRadius:5.0];
        [_fetchValidateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchValidateBtn addTarget:self action:@selector(onValidateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fetchValidateBtn;
}

- (UIButton *)loginBtn {
    
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = kArialSize(2);
        
        [[APPUtil share] setButtonClickStyle:_loginBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x05C247) cornerRadius:autoScaleW(20)];
        
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(onLoginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginBtn;
}

- (UILabel *)errorLable {
    
    if (!_errorLable) {
        _errorLable = [UILabel new];
        _errorLable.font = kArialSize(-4);
        _errorLable.textColor = [UIColor colorFromHexCode:@"#FF3030"];
        _errorLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _errorLable;
}

@end
