//
//  ProgressLoadView.h
//  TestProgressBar
//
//  Created by hu on 17/3/4.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ProgressLoadViewBlock)(void);


@interface ProgressLoadView : UIView

+ (instancetype)shareLoadView;

- (void)startLoading;

- (void)startLoading:(BOOL) isCovered;

- (void)startLoading:(BOOL)isCovered withMonitor:(ProgressLoadViewBlock) delegate;


- (void)stopLoading:(BOOL)isSucc;


@end
