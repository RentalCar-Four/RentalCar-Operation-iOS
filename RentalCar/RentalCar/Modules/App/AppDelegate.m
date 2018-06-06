//
//  AppDelegate.m
//  RentalCar
//
//  Created by hu on 17/3/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchVC.h"
#import "BaseNavController.h"
#import "XDYLoginController.h"
#import "XDYHomeVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AlipayHeader.h"
#import "NetworkUtil.h"
#import "AppDelegate+Umeng.h"
#import "WXApi.h"
#import "SignKeyUtil.h"

@interface AppDelegate ()<WXApiDelegate>

//当前屏幕与设计尺寸(iPhone6)宽度比例
@property(nonatomic,assign)CGFloat autoSizeScaleW;
//当前屏幕与设计尺寸(iPhone6)高度比例
@property(nonatomic,assign)CGFloat autoSizeScaleH;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //友盟方法
    [self UmengApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //监测网络
    [[NetworkUtil sharedInstance] listening];
    
    //获取用户信息
    [[UserInfo share] getUserInfo];
    //清除用户选择区域信息
    [[AreaInfo share] setAreaInfo:nil];
    
    
    //清楚搜索信息
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"searchCarInfoKey"];;
    //清除用户所在区域信息
    [CacherUtil saveCacher:kLocationAreaName withValue:@""];
    
    NSLog(@"用户token用户token:%@",[UserInfo share].token);
    
    //键盘事件
    [self processKeyBoard];
    
    //控件宽高、字体适配
    [self initAutoScaleSize];
    
    //高德地图注册
    [AMapServices sharedServices].apiKey = kMapKey;
    
    //微信注册
    [WXApi registerApp:@"wx36a6dde914572202"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = kBgColor;
    
    //将launcherViewController作为根视图控制器
    LaunchVC *launchVC = [[LaunchVC alloc] init];
    self.window.rootViewController = launchVC;
    
    launchVC.doneBlock = ^(){
        XDYHomeVC *loginVc = [[XDYHomeVC alloc] init];
        
        BaseNavController *navVc = [[BaseNavController alloc] initWithRootViewController:loginVc];
        
        self.window.rootViewController = navVc;
        
        //判定系统版本，选择页面加载方式
        if (kVersion6) {
            [self.window addSubview:navVc.view];
        } else {
            [self.window setRootViewController:navVc];
        }
    };

    [self.window makeKeyAndVisible];
    
//    NSString *url = @"mobile=11111888888&deviceCode=23B29C74-8E5B-4167-B8A4-DB18FF51F76B&vcode=000000&areaId=&nonceStr=1536567942474d9cb2e21c0989d47b84";
//    NSLog(@"签名值：%@",[SignKeyUtil getSignByStr:url withType:@"post"]);
   
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.nsTimer forMode:NSRunLoopCommonModes];
    [self startTaskTimer];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
      [self stopTaskOnBackground];
      [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}



-(void)startTaskTimer
{

    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

        [self stopTaskOnBackground];
        
    }];
}

-(void)stopTaskOnBackground
{

    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
}

- (void)countTimerAction{
    
    
    
}

- (void)processKeyBoard{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    manager.enable = YES;
    
    manager.shouldResignOnTouchOutside = YES;
    
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    manager.enableAutoToolbar = NO;
}

#pragma mark - ScaleSize 控件宽高、字体适配

- (void)initAutoScaleSize{
    
    if (kScreenHeight==480) {
        //4s
        _autoSizeScaleW =kScreenWidth/375;
        _autoSizeScaleH =kScreenHeight/667;
    }else if(kScreenHeight==568) {
        //5
        _autoSizeScaleW =kScreenWidth/375;
        _autoSizeScaleH =kScreenHeight/667;
    }else if(kScreenHeight==667){
        //6
        _autoSizeScaleW =kScreenWidth/375;
        _autoSizeScaleH =kScreenHeight/667;
    }else if(kScreenHeight==736){
        //6p
        _autoSizeScaleW =kScreenWidth/375;
        _autoSizeScaleH =kScreenHeight/667;
    }else if(kScreenHeight==812){
        //6p
        _autoSizeScaleW =kScreenWidth/375;
        _autoSizeScaleH =kScreenHeight/667;
    }else{
        _autoSizeScaleW =1;
        _autoSizeScaleH =1;
    }
}

- (CGFloat)autoScaleW:(CGFloat)w{
    return w * self.autoSizeScaleW;
}

- (CGFloat)autoScaleH:(CGFloat)h{
    return h * self.autoSizeScaleH;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //    NSLog(@"application:openURL:sourceApplication:annotation:%@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                        NSLog(@"result111 = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySucceedNOtifi" object:nil userInfo:resultDic];
            
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) {//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                        NSLog(@"result222 = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySucceedNOtifi" object:nil];
        }];
    }
    
    
    debugLog(@"%d",[WXApi handleOpenURL:url delegate:self]);
    return [WXApi handleOpenURL:url delegate:self];
}

// 微信支付回调
- (void)onResp:(BaseResp *)resp
{
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
//    NSLog(@"strMsg: %@",strMsg);
    
    NSString * errStr       = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
//    NSLog(@"errStr: %@",errStr);
    
    
    NSString * strTitle;
    //判断是微信消息的回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
    }
    
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                strMsg = @"支付结果:";
//                NSLog(@"支付成功: %d",resp.errCode);
                wxPayResult = @"支付成功";
                break;
            }
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户取消了支付";
//                NSLog(@"用户取消支付: %d",resp.errCode);
                wxPayResult = @"用户取消支付";
                break;
            }
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
//                NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
                wxPayResult = @"支付失败";
                break;
            }
        }
        
        //发出通知
        NSNotification * notification = [NSNotification notificationWithName:@"WXPaySucceedNOtifi" object:wxPayResult];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result111 = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySucceedNOtifi" object:nil userInfo:resultDic];
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) {//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result222 = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySucceedNOtifi" object:nil];
        }];
    }
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

@end
