//
//  NSString+XDYUtil.m
//  XDYLease3
//
//  Created by hu on 16/11/14.
//  Copyright © 2016年 com.xdy. All rights reserved.
//

#import "NSString+XDYUtil.h"

@implementation NSString (XDYUtil)

+ (BOOL)isEmpty:(NSString *)string{
    
    if ([string isEqualToString:@""] || nil == string) {
        return YES;
    }else{
        return NO;
    }
}

@end
