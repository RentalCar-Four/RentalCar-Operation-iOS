//
//  XDYPasswordView.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/6.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYPasswordView.h"

@implementation XDYPasswordView

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:self.elementCount];
    }
    return _dataSource;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc] initWithFrame:self.bounds];
        textField.hidden = YES;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:textField];
        self.textField = textField;
        self.textField.tag=20;
        [self.textField becomeFirstResponder];
    }
    return self;
}

- (void)setElementCount:(NSUInteger)elementCount {
    _elementCount = elementCount;
    for (int i = 0; i < self.elementCount; i++)
    {
        UITextField *pwdTextField = [[UITextField alloc] init];
        pwdTextField.textColor = UIColorFromRGB(0x4C4C4C);
        pwdTextField.font = [UIFont boldSystemFontOfSize:26];
        pwdTextField.layer.cornerRadius = autoScaleW(5);
        pwdTextField.layer.borderColor = _elementColor.CGColor;
        pwdTextField.enabled = NO;
        pwdTextField.tag=i+1;
        pwdTextField.backgroundColor=[UIColor whiteColor];
        pwdTextField.textAlignment = NSTextAlignmentCenter;
        pwdTextField.secureTextEntry = YES;//设置密码模式
        pwdTextField.layer.borderWidth = autoScaleW(1);
        pwdTextField.userInteractionEnabled = NO;
        [self insertSubview:pwdTextField belowSubview:self.textField];
        [self.dataSource addObject:pwdTextField];
    }
}
-(void)setNoSecure
{
    for (UITextField *text in self.subviews) {
        /**
         *  除了父输入框，其余输入框键盘全部设置明文
         */
        if (text.tag!=20) {
            text.secureTextEntry=NO;
        }
    }
}
-(void)getFocus
{
    for (UITextField *text in self.subviews) {
        if (text.tag!=20) {
            if (self.textField.text.length<5) {
                UITextField *pwdTextField= [_dataSource objectAtIndex:self.textField.text.length];
                pwdTextField.layer.borderWidth = autoScaleW(2);
                pwdTextField.layer.borderColor = UIColorFromRGB(0x25D880).CGColor;
            }
        }
    }
    
    [self.textField becomeFirstResponder];
}
-(void)dismissFocus
{
    for (UITextField *text in self.subviews) {
        if (text.tag!=20) {
            text.layer.borderColor = _elementColor.CGColor;
            text.layer.borderWidth = autoScaleW(1);
        }
    }
    
    [self.textField resignFirstResponder];
}
- (void)setElementColor:(UIColor *)elementColor {
    _elementColor = elementColor;
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        UITextField *pwdTextField = [_dataSource objectAtIndex:i];
        pwdTextField.layer.borderColor = self.elementColor.CGColor;
        
        if (i==0) {
            pwdTextField.layer.borderWidth = autoScaleW(2);
            pwdTextField.layer.borderColor = UIColorFromRGB(0x25D880).CGColor;
        }
    }
}


- (void)setElementMargin:(NSUInteger)elementMargin {
    _elementMargin = elementMargin;
    [self setNeedsLayout];
}

- (void)clearText {
    self.textField.text = nil;
    [self textChange:self.textField];
}

#pragma mark - 文本框内容改变
- (void)textChange:(UITextField *)textField {
    
    if (textField.text.length > self.elementCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.elementCount)];
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    NSString *filtered = [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    textField.text = [filtered uppercaseString];
    
    if (textField.text.length >= self.elementCount) {
        if (self.inputDoneBlock) {
            self.inputDoneBlock();
        }
    } else {
        if (self.inputUnDoneBlock) {
            self.inputUnDoneBlock();
        }
    }
    
    for (int i = 0; i < _dataSource.count; i++)
    {
        UITextField *pwdTextField= [_dataSource objectAtIndex:i];
        if (i < textField.text.length) {
            NSString *pwd = [textField.text substringWithRange:NSMakeRange(i, 1)];
            pwdTextField.text = pwd;
        } else {
            pwdTextField.text = nil;
        }
        
        if (i==textField.text.length) {
            pwdTextField.layer.borderWidth = autoScaleW(2);
            pwdTextField.layer.borderColor = UIColorFromRGB(0x25D880).CGColor;
        } else {
            pwdTextField.layer.borderWidth = autoScaleW(1);
            pwdTextField.layer.borderColor = _elementColor.CGColor;
        }
        
    }
    
    if (textField.text.length == _dataSource.count)
    {
        //[textField resignFirstResponder];//隐藏键盘
    }
    
    !self.passwordBlock ? : self.passwordBlock(textField.text);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.bounds.size.width - (self.elementCount - 1) * self.elementMargin) / self.elementCount;
    CGFloat h = self.bounds.size.height;
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        UITextField *pwdTextField = [_dataSource objectAtIndex:i];
        x = i * (w + self.elementMargin);
        pwdTextField.frame = CGRectMake(x, y, w, h);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self getFocus];
    
    if (self.showKeyboardBlock) {
        self.showKeyboardBlock();
    }
}

@end
