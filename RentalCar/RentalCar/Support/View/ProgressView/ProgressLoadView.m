//
//  ProgressLoadView.m
//  TestProgressBar
//
//  Created by hu on 17/3/4.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ProgressLoadView.h"
//#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
//
//#define kVersion6 [[UIDevice currentDevice].systemVersion floatValue] < 6.0

@interface ProgressLoadView(){
    
    int count;
    int progress;
    int navHeight;
    BOOL isCanInvoke;
    BOOL isLoop;
    
    UIControl *coverView;
    UIProgressView *processView;
}
@end

@implementation ProgressLoadView

+ (instancetype)shareLoadView{
    
    static ProgressLoadView *requestInstance;
    static dispatch_once_t t;
    
    dispatch_once(&t, ^{
        
        requestInstance = [[self alloc]init];
        
    });
    return requestInstance;
}


- (void)setUp{

    navHeight = 0;
    if (kVersion6) {
        navHeight += 44;
    }else{
        navHeight += 64;
    }
    if (IS_IPhoneX) {
        navHeight = 44+StatusBarHeight;
    }
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.frame = CGRectMake(0, navHeight,kScreenWidth, 1);
    [self addSubview:processView];

    processView.trackTintColor = [UIColor clearColor];
    processView.progressTintColor = kBlueColor;
    
    [[self getCurrentView] addSubview:self];

}

- (void)startLoading{
    
    [self resetValue];
    [self setUp];
    [self loadView];
}


- (void)startLoading:(BOOL)isCovered{
    
    [self startLoading];
    if (isCovered) {
        [self displayCoveredView];
    }
}


- (void)startLoading:(BOOL)isCovered withMonitor:(ProgressLoadViewBlock)delegate{
    
    
    
}

- (void)resetValue{
    
    count = 40;
    progress = 0;
    isCanInvoke = YES;
    isLoop = YES;
    processView.progress = 0;
    self.hidden = NO;
    
}

- (void)displayCoveredView{
    
    coverView = [UIControl new];
    coverView.frame = CGRectMake(0, navHeight, kScreenWidth, kScreenHeight-navHeight);
    [coverView addTarget:self action:@selector(onCoverSelect) forControlEvents:UIControlEventTouchUpInside];
    [[self getCurrentView] addSubview:coverView];
    
}

- (void)onCoverSelect{}

- (void)hideProgress{
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        self.hidden = YES;
        [self setNeedsDisplay];
    });
    
}

- (void)loadView{
    
    dispatch_queue_t queue = dispatch_queue_create("async", NULL);
    
    dispatch_async(queue, ^{
        
        @try {
            
        loop:  for (int i = 1; i < count; i++) {
            
            if (!isLoop) {
                break;
            }
            progress +=3;
            if (progress < 100) {
                
                    [self setCurrentProcess:progress];
                    
                    [NSThread sleepForTimeInterval:0.1];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                processView.hidden = YES;
            });
        }
        
    });
}

- (void)setCurrentProcess:(float)cprogress{
    

    __block float process = cprogress/100+0.3;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (progress >= count) {
            
            if (progress >= 100) {
               
                 [processView setProgress:process animated:YES];
                [self hideProgress];
                isLoop = false;
                return ;
                
            }
            
            if (!isCanInvoke) {
                return;
            }
            
            int rand = (arc4random() % 5) + 4;
            
            [processView setProgress:rand *10 animated:YES];

            
            isCanInvoke = false;
            isLoop = false;
            
        }else{
            
             [processView setProgress:process animated:YES];
        }
    });
   
}

- (void)stopLoading:(BOOL)isSucc{
    
    if (isSucc) {
        
        progress = 100;
        [self setCurrentProcess:progress];
        
    }else{
        
        [self hideProgress];
    }
    
     [processView removeFromSuperview];
}


- (UIView *)getCurrentView
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result.view;
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end
















