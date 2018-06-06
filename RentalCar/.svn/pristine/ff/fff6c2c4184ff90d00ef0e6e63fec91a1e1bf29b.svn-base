//
//  XDYPasswordView.h
//  RentalCar
//
//  Created by zhanbing han on 17/4/6.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseView.h"

@interface XDYPasswordView : BaseView

/**
 *  键盘弹出回调
 */
@property (nonatomic,copy) dispatch_block_t showKeyboardBlock;
/**
 *  输入完成回调
 */
@property (nonatomic,copy) dispatch_block_t inputDoneBlock;
/**
 *  输入未完成回调
 */
@property (nonatomic,copy) dispatch_block_t inputUnDoneBlock;
/**
 *  输入回调
 */
@property (nonatomic, copy) void(^passwordBlock)(NSString *password);
/**
 *  用于存放所有的子输入框
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *  密码框个数
 */
@property (nonatomic, assign) NSUInteger elementCount;
/**
 *  密码框颜色
 */
@property (nonatomic, strong) UIColor *elementColor;
/**
 *  密码框间距
 */
@property (nonatomic, assign) NSUInteger elementMargin;
/**
 *  父输入框
 */
@property(nonatomic, weak) UITextField *textField;
/**
 *  清除所有输入文字
 */
- (void)clearText;
/**
 *  设置键盘输入是否明文可见
 */
-(void)setNoSecure;
/**
 *  获取焦点
 */
-(void)getFocus;
/**
 *  失去焦点
 */
-(void)dismissFocus;

@end
