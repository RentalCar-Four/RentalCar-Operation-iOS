//
//  StatisticsClass.h
//  eLearning
//
//  Created by 盛景 on 16/10/12.
//  Copyright © 2016年 com.shengjing360.kaixue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsClass : NSObject

//初始化统计
+ (void)startStatistics;
//页面统计事件
+ (void)pageId:(NSString *)pageId show:(BOOL)Show;
//自定义事件
+ (void)eventId:(NSString *)eventId;

@end
