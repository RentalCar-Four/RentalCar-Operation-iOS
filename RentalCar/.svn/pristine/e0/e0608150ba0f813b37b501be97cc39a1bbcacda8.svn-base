//
//  XDYAlertView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/30.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animation.h"

@interface XDYAlertView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) dispatch_block_t doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,copy) NSString *topTitle;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,retain) NSString *textStr;
@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rigthTitle;

@property (nonatomic,assign)AShowAnimationStyle animationStyle;

/**
 *  不隐藏，默认为NO。设置为YES时点击按钮alertView不会消失（适合在强制升级时使用）
 */
@property (nonatomic,assign)BOOL dontDissmiss;

/**
 *  构造方法
 *
 *  @param textArr    更新内容
 *  @param leftTitle  左按钮标题
 *  @param rigthTitle 右按钮标题
 *
 *  @return id
 */
- (id)initWithContentText:(NSString *)textStr
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
     TopButtonTitle:(NSString *)topTitle;

@end
