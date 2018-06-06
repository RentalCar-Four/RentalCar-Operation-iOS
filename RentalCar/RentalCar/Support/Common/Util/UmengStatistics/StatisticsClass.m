//
//  StatisticsClass.m
//  eLearning
//
//  Created by 盛景 on 16/10/12.
//  Copyright © 2016年 com.shengjing360.kaixue. All rights reserved.
//

#import "StatisticsClass.h"

@implementation StatisticsClass
//友盟埋点
//初始化统计
+ (void)startStatistics {
    //获取版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    UMConfigInstance.appKey = @"58e61df87666136e58001dc0";
    //UMConfigInstance.channelId = @"";
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

//页面统计事件
+ (void)pageId:(NSString *)pageId show:(BOOL)show {
    if (show) {
        [MobClick beginLogPageView:pageId];
    } else {
        [MobClick endLogPageView:pageId];
    }
}

//自定义事件
+ (void)eventId:(NSString *)eventId {
    [MobClick event:eventId];
}

@end
