//
//  BaseController.h
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController
//设置左侧或右侧自定义按钮
typedef enum{
    
    LeftBtn       = 0, //左侧
    RightBtn      = 1, //右侧
    
}LeftOrRight;

//self.navBar.hidden = YES; //隐藏导航条,在子类viewWillAppear里面调用
@property (nonatomic,retain) UINavigationBar *navBar;
@property (nonatomic,retain) UINavigationItem *navItem;
@property(nonatomic,strong)UIButton *whitebutton;

//self.isPanForbid = YES; //禁用iOS自带侧滑返回手势(1、手势冲突，比如地图；2、不是继承基类的VC，比如继承UIViewController/UITableViewController/UISearchController),在子类viewDidLoad方法里面调用
@property (nonatomic,assign) BOOL isPanForbid;

/*!
 *  @brief 返回
 */
- (void)backAction;

/*!
 *  @brief 获取数据
 */
- (void)getData;

/*!
 *  @brief 无网络
 */
- (void)netWorkDisappear;

/*!
 *  @brief 有网络
 */
- (void)netWorkAppear;

//白色按钮
-(void)setupWhiteBackBut:(UIView *)view;

//gh备注：设置左右按钮的距离
-(void)addItemForLeft:(LeftOrRight)leftorRight
                Title:(NSString *)title
                Titlecolor:(UIColor *)color
                action:(SEL)action
                spaceWidth:(CGFloat)width;


@end
