//
//  BaseService.m
//
//  Created by hu on 16/10/21.
//  Copyright © 2016年 hu. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService


- (void)onFailMessage:(NSString *)msg withType:(ActionType)type{
    
    if ([self.serviceDelegate respondsToSelector:@selector(onFailure:withType:)]) {
        
        [self.serviceDelegate onFailure:msg withType:type];
    }
    
}

- (void)onSuccMessage:(id)data withType:(ActionType)type{
    
    if ([self.serviceDelegate respondsToSelector:@selector(onSuccess:withType:)]) {
        
        [self.serviceDelegate onSuccess:data withType:type];
    }

}

- (void)onSuccMessage:(id)data{
    
    if ([self.serviceDelegate respondsToSelector:@selector(onSuccess:)]) {
        
        [self.serviceDelegate onSuccess:data];
        
    }
    
}


- (void)onFailMessageWithType:(ActionType)type{
    
    
    if ([self.serviceDelegate respondsToSelector:@selector(onFailureWithType:)]) {
        
        [self.serviceDelegate onFailureWithType:type];
    }
}

- (void)onFailMessage{
    
    
    if ([self.serviceDelegate respondsToSelector:@selector(onFailure)]) {
        
        [self.serviceDelegate onFailure];
        
    }
}



@end
