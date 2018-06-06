//
//  CarReturnConfirmView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarReturnConfirmView.h"
#import "CommonRequest.h"
#import "UrlConfig.h"

@interface CarReturnConfirmView ()
{
    UILabel     *_moneyLab; //预估费用
    
    UIButton    *_couponBtn; //优惠券
    UIButton    *_cancelBtn;
    UIButton    *_confirmBtn;
    UIImageView *_loadImgView;
    
    NSArray *_dataArr;
}
@end

@implementation CarReturnConfirmView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _dataArr = @[@"停放至还车点",@"确认拉起手刹",@"关闭车辆电源",@"关闭车门车窗"];
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
    self.frame = CGRectMake(autoScaleW(10), autoScaleH(667), autoScaleW(355), autoScaleH(310));
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = autoScaleW(10);
    [APPUtil setViewShadowStyle:self];
    self.alpha = 0;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, autoScaleH(120))];
    topView.backgroundColor = UIColorFromRGB(0xFCFCFC);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(autoScaleW(10),autoScaleW(10))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topView.bounds;
    maskLayer.path = maskPath.CGPath;
    topView.layer.mask = maskLayer;
    [self addSubview:topView];
    
    UILabel *flagLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(75), autoScaleH(25), autoScaleW(200), autoScaleH(16))];
    flagLab.text = @"还车前请确认以下事项:";
    flagLab.textColor = UIColorFromRGB(0x808080);
    flagLab.font = [UIFont boldSystemFontOfSize:autoScaleH(15)];
    [topView addSubview:flagLab];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-autoScaleW(72), 0, autoScaleW(72), autoScaleW(72))];
    logoImgView.image = [UIImage imageNamed:@"img_ReturnTips"];
    [topView addSubview:logoImgView];
    
    _Lab1 = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(75), flagLab.bottom+autoScaleH(18), autoScaleW(100), autoScaleH(15))];
    _Lab1.textColor = UIColorFromRGB(0x969696);
    _Lab1.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _Lab1.text = _dataArr[0];
    [topView addSubview:_Lab1];
    
    _Lab2 = [[UILabel alloc] initWithFrame:CGRectMake(_Lab1.right, _Lab1.top, autoScaleW(100), autoScaleH(15))];
    _Lab2.textColor = UIColorFromRGB(0x969696);
    _Lab2.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _Lab2.text = _dataArr[1];
    [topView addSubview:_Lab2];
    
    _Lab3 = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(75), _Lab1.bottom+autoScaleH(9), autoScaleW(100), autoScaleH(15))];
    _Lab3.textColor = UIColorFromRGB(0x969696);
    _Lab3.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _Lab3.text = _dataArr[2];
    [topView addSubview:_Lab3];
    
    _Lab4 = [[UILabel alloc] initWithFrame:CGRectMake(_Lab3.right, _Lab3.top, autoScaleW(100), autoScaleH(15))];
    _Lab4.textColor = UIColorFromRGB(0x969696);
    _Lab4.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _Lab4.text = _dataArr[3];
    [topView addSubview:_Lab4];
    
    UILabel *rowLine = [[UILabel alloc] initWithFrame:CGRectMake(0, topView.bottom, self.width, 1)];
    rowLine.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self addSubview:rowLine];
    
    //多了10
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(5), rowLine.bottom+autoScaleH(25), self.width, autoScaleH(19))];
    tipLable.text = @"费用预估（元）";
    tipLable.textColor = UIColorFromRGB(0xC5C5C5);
    tipLable.font = [UIFont systemFontOfSize:autoScaleW(13)];
    tipLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLable];
    
    _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, rowLine.bottom+autoScaleH(55), self.width, autoScaleH(36))];
    _moneyLab.text = @"0.0";
    _moneyLab.font = kAvantiBoldSize(21);
    _moneyLab.textColor = kBlueColor;
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLab];
    
    //优惠券
    _couponBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(50), _moneyLab.bottom+autoScaleH(5), self.width-autoScaleW(50)*2, 20)];
//    _couponBtn.hidden = YES;
    [_couponBtn setTitle:@"优惠券将自动抵扣" forState:UIControlStateNormal];
    [_couponBtn setTitleColor:UIColorFromRGB(0x8D8D8D) forState:UIControlStateNormal];
    _couponBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
//    [_couponBtn setImage:[UIImage imageNamed:@"icon_TicketArrow"] forState:UIControlStateNormal];
//    [_couponBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, autoScaleW(155), 0.0, 0.0)];
//    [_couponBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, autoScaleW(25))];
    [self addSubview:_couponBtn];
    
    //返回
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(8), self.height-autoScaleH(56), autoScaleW(110), autoScaleH(48))];
    _cancelBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
    _cancelBtn.layer.cornerRadius = autoScaleW(5);
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0xE7EDEA).CGColor;
    [_cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x9F9F9F) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    //确认还车
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cancelBtn.right+5, self.height-autoScaleH(56), autoScaleW(225), autoScaleH(48))];
    [[APPUtil share]setButtonClickStyle:_confirmBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    [_confirmBtn setTitle:@"确认还车" forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmBtn];
    
    _loadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(106), autoScaleH(15), autoScaleW(18), autoScaleW(18))];
    [_confirmBtn addSubview:_loadImgView];
}

- (void)recoverView {
    
    self.Lab1.textColor = UIColorFromRGB(0x969696);
    self.Lab2.textColor = UIColorFromRGB(0x969696);
    self.Lab3.textColor = UIColorFromRGB(0x969696);
    self.Lab4.textColor = UIColorFromRGB(0x969696);
    
    [self recoverBtn];
}

- (void)setBookingItem:(BookingItem *)bookingItem {
    
    if (_bookingItem!=bookingItem) {
        _bookingItem = bookingItem;
    }
    
    [self getData];
    
}

- (void)getData {
    
//    //获取还车时检查项
//    NSDictionary *paramDic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.bookingItem.rentNum,@"rentNum",nil];
//    
//    [[CommonRequest shareRequest] requestWithPost:getChekItemForReturnCar() isCovered:NO parameters:paramDic1 success:^(id data) {
//        
//        NSArray *result = data[@"result"][@"list"];
//        
//        
//    } failure:^(NSString *code) {
//        
//    }];
    
    //获取租赁中车辆预估租金
    NSDictionary *paramDic2 = [NSDictionary dictionaryWithObjectsAndKeys:self.bookingItem.rentNum,@"rentNum",nil];
    
    [[CommonRequest shareRequest] requestWithPost:getEstimateLeaseFee() isCovered:NO parameters:paramDic2 success:^(id data) {
        
        NSDictionary *result = data[@"result"];
        _moneyLab.text = result[@"leaseMoney"];
        
    } failure:^(NSString *code) {
    
    }];
}

#pragma mark - methods

//取消
- (void)cancelAction {
    if ([self.delegate respondsToSelector:@selector(onClickWithCancelReturnCarEvent:)]) {
        [self.delegate onClickWithCancelReturnCarEvent:self.bookingItem];
    }
}

//确定
- (void)confirmAction {
    
    [StatisticsClass eventId:HC02];
    
    _confirmBtn.backgroundColor = kBlueColor;
    [_confirmBtn.layer setMasksToBounds:NO];
    
    //还车二次确认
    XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:@"还车将结束计费并锁闭车门，请确认您在车外。" leftButtonTitle:@"取消" rightButtonTitle:@"确认还车" TopButtonTitle:@"确认还车"];
    alert.cancelBlock = ^()
    {
        [StatisticsClass eventId:HC03];
    };
    alert.doneBlock = ^()
    {
        [StatisticsClass eventId:HC04];
        
        [self returnCarAction]; //确认还车
    };
}

#pragma mark - 事件处理

//确认还车
- (void)returnCarAction {
    
    if ([self.delegate respondsToSelector:@selector(onClickWithConfirmReturnCarEvent:)]) {
        [self.delegate onClickWithConfirmReturnCarEvent:self.bookingItem];
    }
    
    _confirmBtn.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self requestStart:@"还车中..."];
        
    } completion:^(BOOL finished) {
        //确认还车
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.bookingItem.rentNum,@"rentNum",
                                  @"",@"couponId",
                                  nil];
        
        [[CommonRequest shareRequest] requestWithPost:getReturnCarUrl() isCovered:NO parameters:paramDic success:^(id data) {
            
            _confirmBtn.userInteractionEnabled = YES;
            
            NSDictionary *result = data;
            NSDictionary *resultDic = result[@"result"];
            NSString *returnStatus = resultDic[@"returnStatus"];
            
            if ([returnStatus isEqualToString:@"1"]) { //还车成功
                
                [APPUtil showToast:@"还车成功"];
                [self requestSuccess:@"还车成功"];
                
                if ([self.delegate respondsToSelector:@selector(returnCarSuccEvent:)]) {
                    [self.delegate returnCarSuccEvent:resultDic];
                }
                
            } else { //还车失败
                
                [APPUtil showToast:@"还车失败 请检查还车事项"];
                [self requestFail:@"还车失败"];
                
                NSArray *checkList = resultDic[@"list"];
                
                for (int i = 0; i<checkList.count; i++) {
                    NSDictionary *item = checkList[i];
                    
                    if ([item[@"id"] isEqualToString:@"1"]) {
                        
                        if (![item[@"passed"] isEqualToString:@"1"]) {
                            _Lab1.textColor = UIColorFromRGB(0xFF6459);
                        }
                    }
                    
//                    if ([item[@"id"] isEqualToString:@"2"]) {
//                    
//                        if (![item[@"passed"] isEqualToString:@"1"]) {
//                            _Lab3.textColor = UIColorFromRGB(0xFF6459);
//                        }
//                    }
                }
            }
            
        } failure:^(NSString *code) {
            
            if ([self.delegate respondsToSelector:@selector(returnCarFailEvent)]) {
                [self.delegate returnCarFailEvent];
            }
            
        }];
    }];
}

#pragma mark - 请求状态

//请求开始
- (void)requestStart:(NSString *)str {
    [_confirmBtn setTitle:str forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = UIColorFromRGB(0x09C58A);
    _confirmBtn.frame = CGRectMake(autoScaleW(8), self.height-autoScaleH(56), autoScaleW(340), autoScaleH(48));
    [_confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -autoScaleW(25))];
    [_confirmBtn.layer setMasksToBounds:YES];
    [APPUtil runAnimationWithCount:9 name:@"motion_BtnLoading00" imageView:_loadImgView repeatCount:0 animationDuration:0.05]; //开始加载
}

//请求成功
- (void)requestSuccess:(NSString *)str {
    
    [_confirmBtn.layer setMasksToBounds:NO];
    [_confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
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
    [_confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [_confirmBtn setTitle:str forState:UIControlStateNormal];
    _loadImgView.animationImages = nil;
    [_loadImgView setImage:[UIImage imageNamed:@"icon_fail"]];
    
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:1.5];
}

- (void)recoverBtn {
    
    [UIView animateWithDuration:0.3 animations:^{
        _cancelBtn.frame = CGRectMake(autoScaleW(8), self.height-autoScaleH(56), autoScaleW(110), autoScaleH(48));
        _cancelBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
        _confirmBtn.frame = CGRectMake(_cancelBtn.right+5, self.height-autoScaleH(56), autoScaleW(225), autoScaleH(48));
        _confirmBtn.backgroundColor = kBlueColor;
        [_confirmBtn setTitle:@"确认还车" forState:UIControlStateNormal];
        _confirmBtn.userInteractionEnabled = YES;
        [_loadImgView setImage:nil];
    } completion:^(BOOL finished) {
        
    }];
}

@end
