//
//  BaseController.m
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"
#import "TipUtil.h"
#import "LogShowView.h"
#import "PersonCenterViewController.h"
#import "walletViewController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavBar];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
    //无网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDisappear) name:@"kNetDisAppear" object:nil];
    //有网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkAppear) name:@"kNetAppear" object:nil];
    
//    if (!KOnline) { //线下显示调试信息
        LogShowView *logView = [LogShowView shareInstance];
        UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
//        NSString *server = [CacherUtil getCacherWithKey:kTestViewKey];
//        if (![APPUtil isBlankString:server]) {
            [myWindow addSubview:logView];
//        }
//    }
}

//没有网络了
- (void)netWorkDisappear
{
    //    if (![self.navItem.title containsString:@"（未连接）"]) {
    //        self.navItem.title = [NSString stringWithFormat:@"%@（未连接）",self.navItem.title];
    //    }
}

//有网络了
- (void)netWorkAppear
{
    //    if ([self.navItem.title containsString:@"（未连接）"]) {
    //        self.navItem.title = [self.navItem.title stringByReplacingOccurrencesOfString:@"（未连接）" withString:@""];
    //    }
}

#pragma mark - 自定义导航条
- (void)setNavBar {
    
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    self.navBar.translucent = NO;
//    self.navBar.backgroundColor = [UIColor redColor];
    UIView *view;
    if (kSystemVersion>=11) {
        self.navBar.top = StatusBarHeight;
        self.navBar.height = 44;
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, StatusBarHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];;
    }
    if ([self isKindOfClass:[PersonCenterViewController class]]||[self isKindOfClass:[walletViewController class]]) {
        view.hidden = YES;
    }

    self.navItem = [[UINavigationItem alloc] init];
    [self.navBar setItems:@[self.navItem]];
    
    if ([[self.navigationController viewControllers] count] == 1) {
        
    } else {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(0), autoScaleH(11.5), autoScaleW(60), autoScaleH(40))];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, (autoScaleH(40)-autoScaleH(22))/2.0, autoScaleW(22), autoScaleW(22))];
        img.image = [UIImage imageNamed:@"icon_Back"];
        [backBtn addSubview:img];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        //创建UIBarButtonSystemItemFixedSpace
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
        spaceItem.width = -autoScaleW(10);
        backBarButtonItem.width = -autoScaleW(10);
        //将两个BarButtonItem都返回给NavigationItem
        self.navItem.leftBarButtonItems = @[spaceItem,backBarButtonItem];
    }
}

#pragma mark - Set方法

- (void)setTitle:(NSString *)title {
    self.navItem.title = title;
}

#pragma mark - 自定义方法

//返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//获得数据
- (void)getData {
    
}

//隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //隐藏系统导航条
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.navBar];
    
    if (!self.isPanForbid) { //默认开启
        // 开启iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        // 禁用iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.navBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [TipUtil stopProgress:NO]; //隐藏加载进度条
    
    //显示系统导航条
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)dealloc {
    NSLog(@"释放控制器");
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //移除通知
}
//白色的返回按钮
-(void)setupWhiteBackBut:(UIView *)view{
    self.whitebutton =[[UIButton alloc]initWithFrame:CGRectMake(15, 27, autoScaleW(30), autoScaleH(30))];
    [self.whitebutton addTarget:self action:@selector(backview:) forControlEvents:UIControlEventTouchUpInside];
    [self.whitebutton.layer setMasksToBounds:YES];
    [self.whitebutton setImage:[UIImage imageNamed:@"icon_BackWhite"] forState:UIControlStateNormal];
    [self.whitebutton setContentMode:UIViewContentModeScaleAspectFit];
    //    [button setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:self.whitebutton];
    if (IS_IPhoneX) {
        self.whitebutton.top = 27+20;
    }
}

-(void)backview:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


//gh备注：添加左右侧按钮的方法
-(void)addItemForLeft:(LeftOrRight)leftorRight Title:(NSString *)title Titlecolor:(UIColor *)color action:(SEL)action spaceWidth:(CGFloat)width {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, autoScaleW(75), autoScaleH(44));
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil action:nil];
    
    switch (leftorRight) {
        case LeftBtn:{
            self.navItem.leftBarButtonItems = @[space,item];
        }
        
            break;
            
        case RightBtn:{
            self.navItem.rightBarButtonItems = @[space,item];
        }
            
            break;
            
        default:
            break;
    }
}

//解决跳转到相册页面 出现透明导航栏
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end