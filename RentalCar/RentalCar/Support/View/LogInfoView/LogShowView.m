//
//  LogShowView.m
//  RentalCar
//
//  Created by zhanbing han on 2017/11/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "LogShowView.h"


@interface LogShowView()
{
    UIButton *logBnt;
    
}
@end

//static LogShowView *_instance;

@implementation LogShowView

+ (instancetype)shareInstance
{
    static LogShowView *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[LogShowView alloc] init];
    });
    return singleton;
}

- (id)init{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.frame = CGRectMake(autoScaleW(20), SCREEN_HEIGHT-autoScaleW(150), autoScaleW(44), autoScaleW(44));
    logBnt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, autoScaleW(44), autoScaleW(44))];
    [logBnt setTitle:@"调试" forState:0];
    logBnt.backgroundColor = [UIColor whiteColor];
    [logBnt setTitleColor:kBlueColor forState:UIControlStateNormal];
    logBnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [logBnt.layer setCornerRadius:autoScaleW(10.0)];
    [APPUtil setViewShadowStyle:logBnt];
    [logBnt addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logBnt];
    self.clipsToBounds = YES;
    _textViews = [[UITextView alloc]initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-30, SCREEN_HEIGHT-60)];
    _textViews.layer.cornerRadius = 10;
    _textViews.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
    _textViews.layer.shadowOpacity = 0.2; //透明度
    _textViews.layer.shadowColor =  [UIColor blackColor].CGColor; //阴影颜色
    _textViews.layer.shadowRadius = 6; //模糊度
    _textViews.text = @"";
    _textViews.font = [UIFont systemFontOfSize:15];
    _textViews.editable = NO;
    _textViews.hidden = YES;
    [self addSubview:_textViews];
    [self addSubview:logBnt];
    
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-autoScaleW(64), SCREEN_HEIGHT-autoScaleW(64),  autoScaleW(44), autoScaleW(44))];
    [clearBtn setTitle:@"清除" forState:0];
    clearBtn.backgroundColor = [UIColor whiteColor];
    [clearBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [clearBtn.layer setCornerRadius:autoScaleW(10.0)];
    [APPUtil setViewShadowStyle:clearBtn];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
}

- (void)showInfo{
    if (self.width>60) {
        self.frame = CGRectMake(autoScaleW(20), SCREEN_HEIGHT-autoScaleW(64), autoScaleW(44), autoScaleW(44));
        logBnt.top = 0;
        logBnt.left = 0;
        _textViews.hidden = YES;
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        logBnt.top = self.height-autoScaleW(64);
        _textViews.hidden = NO;
        logBnt.left = autoScaleW(20);
    }
}

- (void)clearLog{
    _textViews.text = @"";
}


@end

