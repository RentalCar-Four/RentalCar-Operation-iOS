//
//  BottomAnimationView.m
//  LivenessDetection
//
//  Created by 张英堂 on 15/1/8.
//  Copyright (c) 2015年 megvii. All rights reserved.
//

#import "MGBaseBottomManager.h"
#import "UIImageView+MGReadImage.h"


@interface MGBaseBottomManager ()


@end

@implementation MGBaseBottomManager

-(instancetype)initWithFrame:(CGRect)frame andCountDownType:(MGCountDownType)countDownType{
    self = [super initWithFrame:frame];
    if (self) {
        
        _countDownType = countDownType;
        
        [self creatBottomView];
       // [self creatAniamtionView];
        
        [self recovery];
    }
    return self;
}

- (void)creatBottomView{
    //gh:这里写关于底部的ui代码
    [self setBackgroundColor:MGColorWithRGB(250, 250, 250, 1)];
    
    
}

- (void)creatAniamtionView{
    
}

- (void)showMessageView:(NSString *)message{
    //gh:设置颜色
    [self.messageLabel setTextColor:MGColorWithRGB(114, 114, 114, 1)];
    if (!message) {
        [self.messageLabel setText:[MGLiveBundle LiveBundleString:@"face_check_title1"]];
    }else{
        [self.messageLabel setText:message];
    }
}

- (void)recovery{
    _stopAnimaiton = YES;
    [[MGPlayAudio sharedAudioPlayer] cancelAllPlay];
    
    [self recoveryView];
}

- (void)recoveryView{
    [self.countDownView stopAnimation];

}

- (void)recoveryWithTitle:(NSString *)title{
    [self recovery];
    [self showMessageView:title];
}


- (void)willChangeAnimation:(MGLivenessDetectionType)state outTime:(CGFloat)time currentStep:(NSInteger)step{
    _stopAnimaiton = NO;
    [self outTime:time];
    
}

- (void)outTime:(CGFloat)time{
    [self.countDownView setMaxTime:time];
}

- (void)startRollAnimation{
    [self.countDownView startAnimation];
}


-(void)addSubview:(UIView *)view{
    if (view.superview == self) {
        return;
    }
    [super addSubview:view];
}

@end
