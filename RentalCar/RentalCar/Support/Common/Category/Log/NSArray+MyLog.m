//
//  NSArray+MyLog.m
//  RentalCar
//
//  Created by Jason on 2017/8/31.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "NSArray+MyLog.h"

@implementation NSArray (MyLog)

- (NSString*)descriptionWithLocale:(id)locale {
    
    NSMutableString*str = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
        
        [str appendFormat:@"\t%@,\n", obj];
        
    }];
    
    [str appendString:@")"];
    
    return str;
    
}

@end

@implementation NSDictionary (MyLog)

- (NSString*)descriptionWithLocale:(id)locale {
    
    NSMutableString *str = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop) {
        
        [str appendFormat:@"\t%@ = %@;\n", key, obj];
        
    }];
    
    [str appendString:@"}\n"];
    
    return str;
    
}

@end
