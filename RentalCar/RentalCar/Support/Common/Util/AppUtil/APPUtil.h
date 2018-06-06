//
//  APPUtil.h
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APPUtil : NSObject

+ (APPUtil *)share;
//获取当前日期
+(NSString *)getCurrentDate;

+ (BOOL)isLoginWithJump:(BOOL)isJump;

+ (BOOL)isAccountStatePass:(UIViewController *)vc;

+ (void)logout:(BOOL)isJumpLoginVC;

+ (UIViewController *)getCurrentVC;

/**
 计算字符个数

 @param text
 @return
 */
+(NSUInteger) unicodeLengthOfString: (NSString *) text ;

/*!
 *  @brief 判断字符串是否为空
 */
+ (BOOL)isBlankString:(id)string;

/*!
 *  @brief 判断网络状态
 */
+ (BOOL)getNetStatus;

/*!
 *  @brief 仿安卓消息提示
 */
+ (void)showToast:(NSString *)message;
    
/*!
 *  @brief 设置控件阴影
 */
+ (void)setViewShadowStyle:(UIView *)view;

/*!
 *  @brief 设置按钮点击效果
 */
- (void)setButtonClickStyle:(UIButton *)btn
                     Shadow:(BOOL)Shadow
                     normalBorderColor:(UIColor *)normalBorderColor
                     selectedBorderColor: (UIColor *)selectedBorderColor
                     BorderWidth:(int)BorderWidth
                     normalColor:(UIColor *)normalColor
                     selectedColor:(UIColor *)selectedColor
                     cornerRadius:(CGFloat)radius;

/*!
 *  @brief 屏幕快照
 */
+ (UIImage *)snapshotSingleView:(UIView *)view;

/*!
 *  @brief vImage实现模糊
 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/*!
 *  @brief UIImageView 动画方法
 */
+(void)runAnimationWithCount:(int)count name:(NSString *)name imageView:(UIImageView *)imageView repeatCount:(int)repeatCount animationDuration:(CGFloat)animationDuration;

/*!
 *  @brief 获取设备型号
 */
+ (NSString*)doDevicePlatform;

/*!
 *  @brief 判断系统相机权限
 */
+ (BOOL)isCameraPermissionOn;

/*!
 *  @brief 判断系统照片权限
 */
+ (BOOL)isPhotoPermissionOn;

/*!
 *  @brief 判断系统麦克风权限
 */
+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block;

/*!
 *  @brief url编码
 */
+ (NSString *)urlEncoding:(NSString *)urlString;

/*!
 *  @brief url解码
 */
+ (NSString *)urlDecoding:(NSString *)str;

/*!
 *  @brief 根据文字内容、字体大小、行高获取文本宽度
 */
+ (CGFloat)getTextWidth:(NSString *)text font:(UIFont *)font forHeight:(CGFloat)height;

/*!
 *  @brief 根据文字内容、字体大小、行宽获取文本高度
 */
+ (CGFloat)getTextHeight:(NSString *)text font:(UIFont *)font forWidth:(CGFloat)width;
//@brief 隐藏手机号中间四位
- (NSString *)handleDataForSecurity:(NSString *)dataStr;

//判断是否安装微信客户端
+(BOOL)isInstallWinXinApp;

//两个数相乘 保留两位小数
+(NSString *)multiplyingBy:(NSString *)num1 and:(NSString *)num2;

//处理时间
+ (NSString *)handleTimeWithMinus:(NSInteger)mins;

+ (BOOL)isCanUsePhotos;

//汉字转拼音
+ (NSString *)chineseToPinyin:(NSString *)chinese;

//判断当前城市和地图定位的城市是否一样
+(BOOL)isCurrentCityName;

+(UIViewController *)getVCWithUIView:(UIView *)view;

@end
