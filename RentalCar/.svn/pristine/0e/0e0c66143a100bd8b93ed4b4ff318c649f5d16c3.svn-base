//
//  WKDelegateController.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface WKDelegateController : UIViewController <WKScriptMessageHandler>

@property (weak, nonatomic) id<WKDelegate> delegate;

@end
