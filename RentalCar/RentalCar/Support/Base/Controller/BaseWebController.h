//
//  BaseWebController.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"

@protocol BaseWebControllerDelegate <NSObject>

-(void)ProIdentityIDClick;

@end

@interface BaseWebController : BaseController

@property (strong, nonatomic) NSString *homeUrl;
@property (strong, nonatomic) NSString *webTitle;
@property (assign, nonatomic) BOOL isPresent;
@property(nonatomic,assign) id<BaseWebControllerDelegate> delegate;

/** 传入控制器、url、标题 H5获取参数*/
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isPresent:(BOOL)isPresent;

@end
