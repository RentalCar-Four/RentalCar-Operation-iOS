//
//  LeftMenuView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/14.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseView.h"
#import "HeaderView.h"
#define titleArr @[@"钱包", @"行程",@"我的运维", @"客服",@"关于"]
#define iconNormalImage @[[UIImage imageNamed:@"icon_wallet"], [UIImage imageNamed:@"icon_list"],[UIImage imageNamed:@"icon_invite_black"], [UIImage imageNamed:@"icon_service"],[UIImage imageNamed:@"icon_about"]]
#define iconSelectedImage @[[UIImage imageNamed:@"icon_wallet_pressed"], [UIImage imageNamed:@"icon_list_pressed"],[UIImage imageNamed:@"icon_invite_green"], [UIImage imageNamed:@"icon_service_pressed"],[UIImage imageNamed:@"icon_about_pressed"]]
#define iconHighlightedImage @[[UIImage imageNamed:@"icon_wallet_pressed"], [UIImage imageNamed:@"icon_list_pressed"],[UIImage imageNamed:@"icon_invite_green"], [UIImage imageNamed:@"icon_service_pressed"],[UIImage imageNamed:@"icon_about_pressed"]]


@protocol LeftMenuDelegate <NSObject>

@optional
- (void)onClickWithHideLeftMenuEvent; //隐藏菜单
- (void)onClickWithHeaderViewEvent; //头像点击
-(void)onDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;//点击cell

@end

@interface LeftMenuView : BaseView

@property (nonatomic,weak) id<LeftMenuDelegate> delegate;

@property (nonatomic,strong) UIView *leftView; //左侧滑菜单
@property (nonatomic,strong) UIView *shadowView; //侧滑蒙版
@property (nonatomic,strong) UITableView *leftTableView; //侧滑列表
@property (nonatomic,assign) BOOL isAnimationOn; //是否开启侧滑动画
@property (nonatomic,assign) int leftViewShow;
@property(nonatomic,strong)HeaderView *headView;

- (void)refreshLeftMenuView;
@end
