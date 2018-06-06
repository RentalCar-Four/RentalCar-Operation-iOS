//
//  NetworkUtil.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/30.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "NetworkUtil.h"

static NetworkUtil *_instance;

@implementation NetworkUtil

+ (NetworkUtil *)sharedInstance
{
    static dispatch_once_t predicate ;
    dispatch_once(&predicate , ^{
        _instance = [[NetworkUtil alloc] init];
    });
    return _instance;
}

- (void)listening
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability *reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];

    switch (netStatus)
    {
        case NotReachable:        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetDisAppear" object:nil];
            [CacherUtil saveCacher:kNoNetworkKey withValue:@"kNetDisAppear"];
            break;
        }
            
        case ReachableViaWWAN:        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
            [CacherUtil saveCacher:kNoNetworkKey withValue:@""];
            break;
        }
        case ReachableViaWiFi:        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
            [CacherUtil saveCacher:kNoNetworkKey withValue:@""];
            break;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
