//
//  ObserverServiceDelegate.h
//  XYXOperationSupport
//
//  Created by hu on 16/10/20.
//  Copyright © 2016年 CWB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionType.h"



@protocol ObserverServiceDelegate <NSObject>

@optional
- (void)onSuccess:(id)data;
- (void)onSuccess:(id)data withType:(ActionType)type;
- (void)onFailure;
- (void)onFailureWithType:(ActionType)type;
- (void)onFailure:(NSString *)msg withType:(ActionType)type;
- (void)onSuccwithType:(ActionType)type withProgress:(CGFloat)Progress;


@end
