//
//  TipUtil.m
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "TipUtil.h"
#import "SVProgressHUD.h"
#import "ProgressLoadView.h"

@implementation TipUtil

+ (void)showSuccTip:(NSString *)content{
    
//    [SVProgressHUD showSuccessWithStatus:content maskType:SVProgressHUDMaskTypeBlack];
    
    [APPUtil showToast:content];
}

+ (void)showErrorTip:(NSString *)content{
    
//    [SVProgressHUD showErrorWithStatus:content maskType:SVProgressHUDMaskTypeBlack];

    [APPUtil showToast:content];
}

+ (void)hiddenTip{
    
    [SVProgressHUD dismiss];
}


+ (void)showProgressIsCovered:(BOOL)isCovered{
    
    [[ProgressLoadView shareLoadView] startLoading:isCovered];
}

+ (void)stopProgress:(BOOL)isSucc{
    
    [[ProgressLoadView shareLoadView] stopLoading:isSucc];
}

@end
