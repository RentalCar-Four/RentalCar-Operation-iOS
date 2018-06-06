//
//  CarPopView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarPopView.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "CountDownTimer.h"

@interface CarPopView ()<CountDownTimerDelegate>
{
    UIView      *_mainView;
    UIButton    *_closeBtn;
    UIImageView *_imgView;
    UILabel     *_txtTitleLab;
    UILabel     *_txtContentLab;
    UIButton    *_cancelBtn;
    UIButton    *_confirmBtn;
    UIImageView *_loadImgView;
    
    CountDownTimer *timer;
}
@end

@implementation CarPopView

- (id)initWithImageName:(NSString *)imgName
            contentText:(NSString *)content
               descText:(NSString *)desc
                  range:(NSRange)range
        leftButtonTitle:(NSString *)leftTitle
       rightButtonTitle:(NSString *)rigthTitle {
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        
        self.imgName = imgName;
        self.content = content;
        self.desc = desc;
        self.range = range;
        self.leftTitle = leftTitle;
        self.rigthTitle = rigthTitle;
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
    timer = [CountDownTimer new];
    timer.timerDelegate = self;
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:1];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:beffect];
    blurView.frame = self.bounds;
    blurView.alpha = 1;
    [self addSubview:blurView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(55/2), autoScaleH(267/2), autoScaleW(320), autoScaleH(400))];
    _mainView.layer.cornerRadius = 10;
    _mainView.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
    _mainView.layer.shadowOpacity = 0.2; //透明度
    _mainView.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    _mainView.layer.shadowRadius = 6; //模糊度
    _mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    
    //关闭
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_mainView.width-30, 10, 20, 20)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    closeBtn.userInteractionEnabled = NO;
    [_mainView addSubview:closeBtn];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_mainView.width-60, 0, 60, 60)];
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_closeBtn];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(137/2), autoScaleH(20), autoScaleW(183), autoScaleW(183))];
    _imgView.image = [UIImage imageNamed:self.imgName];
    [_mainView addSubview:_imgView];
    
    _txtTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgView.bottom+autoScaleH(15), _mainView.width, 30)];
    _txtTitleLab.font = [UIFont boldSystemFontOfSize:autoScaleW(22)];
    _txtTitleLab.textColor = UIColorFromRGB(0x808080);
    _txtTitleLab.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:self.content];
    
    if (self.content.length>4) {
        [contentStr addAttribute:NSFontAttributeName value:kAvantiBoldSize(15) range:NSMakeRange(4, self.content.length-4)];
        [contentStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x25D880) range:NSMakeRange(4, self.content.length-4)];
    }
    _txtTitleLab.attributedText = contentStr;
    [_mainView addSubview:_txtTitleLab];
    
    _txtContentLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(50), _txtTitleLab.bottom+autoScaleH(5), autoScaleW(220), autoScaleH(65))];
    _txtContentLab.font = [UIFont systemFontOfSize:autoScaleW(16)];
    _txtContentLab.textColor = UIColorFromRGB(0xAAAAAA);
    _txtContentLab.numberOfLines = 0;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self.desc];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:kBlueColor range:self.range];
    _txtContentLab.attributedText = attributedStr;
    [_mainView addSubview:_txtContentLab];
    
    //取消
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(8), autoScaleH(344), autoScaleW(110), autoScaleH(48))];
    _cancelBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
    _cancelBtn.layer.cornerRadius = autoScaleW(5);
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0xE7EDEA).CGColor;
    [_cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x9F9F9F) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_cancelBtn];
    
    //确定
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cancelBtn.right+autoScaleW(5), autoScaleH(344), autoScaleW(190), autoScaleH(48))];
    [[APPUtil share]setButtonClickStyle:_confirmBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    [_confirmBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_confirmBtn];
    
    if ([APPUtil isBlankString:self.leftTitle]) {
        _cancelBtn.hidden = YES;
        _confirmBtn.frame = CGRectMake(autoScaleW(10), autoScaleH(344), autoScaleW(300), autoScaleH(48));
    }
    
    _loadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(106), autoScaleH(15), autoScaleW(18), autoScaleW(18))];
    [_confirmBtn addSubview:_loadImgView];
    
    [self showAnimation];
}

- (void)startTimer {
    [timer onCountDownTimer:10];
}

#pragma mark - methods

//显示动画
- (void)showAnimation {
    _mainView.top = autoScaleH(267/2)+30;
    _mainView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.top = autoScaleH(267/2);
        _mainView.alpha = 1;
    } completion:nil];
}

//消失动画
- (void)hideAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        _mainView.top = autoScaleH(267/2)+30;
        _mainView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//关闭
- (void)closeAction {
    
    [self hideAnimation];
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

//取消
- (void)cancelAction {
    
    if (self.fromFlag==1) {
        [StatisticsClass eventId:SY06];
    }
    
    if ([self.rigthTitle isEqualToString:@"确认开锁"]) {
        [StatisticsClass eventId:YC05];
    }
    
    if ([self.leftTitle isEqualToString:@"确认取消"]) {
        [StatisticsClass eventId:YY02];
    }
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

//确定
- (void)confirmAction {
    
    _confirmBtn.backgroundColor = kBlueColor;
    [_confirmBtn.layer setMasksToBounds:NO];
    
    if ([self.rigthTitle isEqualToString:@"立即预约"]) {
        [self bookingAction];
        
        [StatisticsClass eventId:SY07];
    }
    
    if ([self.rigthTitle isEqualToString:@"我再想想"]) {
        [StatisticsClass eventId:YY03];
        
        if (self.confirmBlock) {
            self.confirmBlock();
        }
    }
    
    else if ([self.rigthTitle isEqualToString:@"确认开锁"]) {
        
        [StatisticsClass eventId:YC06];
        [self unLockCarAction];
    }
    
    else {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
    }

}

#pragma mark - 事件处理

//立即预约
- (void)bookingAction {
    
    _confirmBtn.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self requestStart:@"预约中..."];
        
    } completion:^(BOOL finished) {
        //预约用车
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [APPUtil isBlankString:self.carItem.vin]?@"":self.carItem.vin,@"vin",nil];
        
        [[CommonRequest shareRequest] requestWithPost:getBookingCarUrl() isCovered:NO parameters:paramDic success:^(id data) {
            
            _confirmBtn.userInteractionEnabled = YES;
            
            [self requestSuccess:@"预约成功"];
            
            NSDictionary *result = data;
            BookingItem *item = [BookingItem yy_modelWithJSON:result];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction];
                
                if (self.bookingSuccBlock) {
                    self.bookingSuccBlock(item);
                }
            });
        } failure:^(NSString *code) {
            
            _confirmBtn.userInteractionEnabled = YES;
            
            if ([code isEqualToString:@"token失效"]) {
                [self closeAction];
                return;
            }
            
            [self requestFail:@"预约失败"];
            
            if (self.bookingFailBlock) {
                self.bookingFailBlock();
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction];
            });
        }];
    }];
    
}

//开锁用车
- (void)unLockCarAction {
    
    _confirmBtn.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self requestStart:@"开锁中..."];
        
    } completion:^(BOOL finished) {

        NSDictionary *paramDic;
        NSString *urlStr = @"";
        if (self.fromFlag==1) { //预约用车开锁
            paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.bookingItem.ID,@"bookingId",nil];
            urlStr = getOpenBookingCarUrl();
        } else if(self.fromFlag==2){ //扫码用车开锁
            paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                        self.bookingItem.vin,@"vin",nil];
            urlStr = getOpenCarDirectlyUrl();
        }
        
        
        [[CommonRequest shareRequest] requestWithPost:urlStr isCovered:NO parameters:paramDic success:^(id data) {
            
            _confirmBtn.userInteractionEnabled = YES;
            
            [self requestSuccess:@"开锁成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction];
                
                if (self.confirmBlock) {
                    self.confirmBlock();
                }
            });
        } failure:^(NSString *code) {
            
            _confirmBtn.userInteractionEnabled = YES;
            
            [self requestFail:@"开锁失败"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction];
            });
        }];
    }];
    
}

#pragma mark - 请求状态

//请求开始
- (void)requestStart:(NSString *)str {
    [_confirmBtn setTitle:str forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = UIColorFromRGB(0x09C58A);
    _confirmBtn.frame = CGRectMake(autoScaleW(8), autoScaleH(344), autoScaleW(304), autoScaleH(48));
    [_confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -autoScaleW(25))];
    [_confirmBtn.layer setMasksToBounds:YES];
    [APPUtil runAnimationWithCount:9 name:@"motion_BtnLoading00" imageView:_loadImgView repeatCount:0 animationDuration:0.05]; //开始加载
}

//请求成功
- (void)requestSuccess:(NSString *)str {
    
    [_confirmBtn.layer setMasksToBounds:NO];
    [_confirmBtn setTitle:str forState:UIControlStateNormal];
    _loadImgView.animationImages = nil;
    
    [_loadImgView setImage:[UIImage imageNamed:@"icon_success"]];
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(106), autoScaleH(15), autoScaleW(18), autoScaleW(18))];
    tempView.backgroundColor = UIColorFromRGB(0x09C58A);
    [_confirmBtn addSubview:tempView];
    [UIView animateWithDuration:0.3 animations:^{
        tempView.frame = CGRectMake(autoScaleW(124), autoScaleH(15), autoScaleW(0), autoScaleW(18));
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        tempView.backgroundColor = kBlueColor;
        _confirmBtn.backgroundColor = kBlueColor;
    }];
    
    _confirmBtn.userInteractionEnabled = NO;
}

//请求失败
- (void)requestFail:(NSString *)str {
    _confirmBtn.backgroundColor = UIColorFromRGB(0xFF6459);
    [_confirmBtn.layer setMasksToBounds:NO];
    [_confirmBtn setTitle:str forState:UIControlStateNormal];
    _loadImgView.animationImages = nil;
    [_loadImgView setImage:[UIImage imageNamed:@"icon_fail"]];
    
    _confirmBtn.userInteractionEnabled = NO;
}

#pragma mark - CountDownTimerDelegate

- (void)onRefreshTimer:(NSString *)cutTimer{
    
    _confirmBtn.userInteractionEnabled = NO;
    _closeBtn.userInteractionEnabled = NO;
    _confirmBtn.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [_confirmBtn.layer setMasksToBounds:YES];
    [_confirmBtn setTitle:[NSString stringWithFormat:@"我知道了(%@s)",cutTimer] forState:UIControlStateNormal];
}

//倒计时结束
- (void)onTimerOut{
    
    _confirmBtn.userInteractionEnabled = YES;
    _closeBtn.userInteractionEnabled = YES;
    _confirmBtn.backgroundColor = kBlueColor;
    [_confirmBtn.layer setMasksToBounds:NO];
    [_confirmBtn setTitle:@"我知道了" forState:UIControlStateNormal];
}

- (void)notifyStopTimer{
    
    [timer stopTimer];
}

@end
