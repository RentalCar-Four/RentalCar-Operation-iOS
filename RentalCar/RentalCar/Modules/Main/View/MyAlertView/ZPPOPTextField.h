//
//  ZPPOPTextField.h
//  MEILIBO
//
//  Created by mars on 2017/3/23.
//  Copyright © 2017年 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define M_RATIO_SIZE(s) SCREEN_WIDTH/(320.0/s)

#ifndef NDEBUG
#define DebugLog(message, ...) NSLog(@"%s: " message, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DebugLog(message, ...)
#endif

@interface ZPPOPTextField : UIView

/**
 标题
 */
@property (nonatomic, strong) NSString *title;

/**
 输入框初始值
 */
@property (nonatomic, strong) NSString *textFieldInitialValue;

/**
 限制输入长度
 */
@property (nonatomic, assign) NSInteger textFieldTextMaxLength;

/**
 输入框确定之后的block回调
 */
@property (nonatomic, copy) void(^textFieldTextBlock)(NSString *string);


/**
初始化

 @param title 标题
 @param textFieldInitialValue 输入框初始值
 @param textFieldTextMaxLength 输入框文字最大长度
 @param textFieldText 输入框确定返回的内容
 @return 初始化一个弹出输入框
 */
-(instancetype)initWithTitle:(NSString *)title  textFieldInitialValue:(NSString *)textFieldInitialValue textFieldTextMaxLength:(NSInteger )textFieldTextMaxLength textFieldText:(void(^)(NSString * textFieldText)) textFieldText;
/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;
@end
