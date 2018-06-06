//
//  appInfo.m
//  eLearning
//
//  Created by Hulk on 16/8/15.
//  Copyright © 2016年 com.shengjing360.kaixue. All rights reserved.
//

#import "UserOther.h"

@implementation UserOther

//单例
static UserOther* _instance = nil;

+ (UserOther *)UserOtherInstance {
    
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init] ;
        
    }) ;
    
    return _instance ;
    
}

- (NSData *)ProId {
    NSData *proId = [[NSUserDefaults standardUserDefaults]objectForKey:@"proId"];
  
    return proId;
}

- (NSData *)DriveID {
    NSData *driveID = [[NSUserDefaults standardUserDefaults]objectForKey:@"driveID"];
    
    return driveID;
}

- (NSData *)HoldProId {
    NSData *holdProId = [[NSUserDefaults standardUserDefaults]objectForKey:@"holdProId"];
    
    return holdProId;
}

@end