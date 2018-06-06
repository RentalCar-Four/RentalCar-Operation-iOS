//
//  VeriificationService.m
//  RentalCar
//
//  Created by Hulk on 2017/3/10.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "VeriificationService.h"

@implementation VeriificationService

- (void)requestgetUploadVerificationWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:getUploadVerificationUrl() isCovered:NO parameters:param success:^(id data) {
        
        @try {
//            [self onSuccMessage:<#(id)#>];
            
        }
        @catch (NSException *exception) {
            
            [TipUtil showErrorTip:exception.reason];
            
        }
        @finally {
            
            
        }
        
    } failure:^(NSString *code) {
        
        
        
    }];
    
}
@end
