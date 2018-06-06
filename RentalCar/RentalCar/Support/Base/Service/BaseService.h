//
//  BaseService.h
//
//  Created by hu on 16/10/21.
//  Copyright © 2016年 hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObserverServiceDelegate.h"
#import "SignKeyUtil.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "TipUtil.h"
#import "APPUtil.h"

@interface BaseService : NSObject


@property(nonatomic,weak)id<ObserverServiceDelegate> serviceDelegate;
- (void)onSuccMessage:(id)data withType:(ActionType)type;
- (void)onFailMessage:(NSString *)msg withType:(ActionType)type;

- (void)onSuccMessage:(id)data;
- (void)onFailMessage;
- (void)onFailMessageWithType:(ActionType)type;





@end
