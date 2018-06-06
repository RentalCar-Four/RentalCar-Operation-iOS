//
//  CarRunningView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarRunningView.h"
#import "CircleProgressView.h"

@interface CarRunningView ()
{
    UILabel *_getCarLab; //取车
    UIButton *_returnCarBtn; //还车
    UILabel *_contentLab; //车牌号
    
    CircleProgressView *_circleProgressView; //环形进度
    
    UILabel *_kmLable; //行驶里程
    UILabel *_timeLable; //用车时长
    UILabel *_xhKmLable; //预计续航
    UILabel *_priceLable; //当前费用
    
    UIButton *_openDoorBtn; //开车门
    UIButton *_closeDoorBtn; //锁车门
    UIButton *_finishRunningBtn; //结束行程
    UILabel *_rentCarPswLB; //租车密码显示
}
@end

@implementation CarRunningView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
    self.frame = CGRectMake(autoScaleW(10), autoScaleH(667), autoScaleW(355), autoScaleH(470));
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = autoScaleW(10);
    [APPUtil setViewShadowStyle:self];
    self.alpha = 0;
    
    UILabel *getCarFlag = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, autoScaleW(60), autoScaleH(25))];
    getCarFlag.text = @"取车点";
    getCarFlag.textColor = UIColorFromRGB(0xDCDCDC);
    getCarFlag.font = [UIFont systemFontOfSize:12];
    [self addSubview:getCarFlag];
    
    UIImageView *locateFlag = [[UIImageView alloc] initWithFrame:CGRectMake(getCarFlag.right, autoScaleH(15.5), 10, 10)];
    locateFlag.image = [UIImage imageNamed:@"icon_PickLocation"];
    [self addSubview:locateFlag];
    
    _getCarLab = [[UILabel alloc] initWithFrame:CGRectMake(locateFlag.right+5, 7, autoScaleW(200), autoScaleH(25))];
    _getCarLab.text = @"五道口嘉园地面停车场";
    _getCarLab.font = [UIFont systemFontOfSize:12.5];
    _getCarLab.textColor = UIColorFromRGB(0x808080);
    [self addSubview:_getCarLab];
    
    UILabel *returnCarFlag = [[UILabel alloc] initWithFrame:CGRectMake(15, getCarFlag.bottom, autoScaleW(60), autoScaleH(45))];
    returnCarFlag.text = @"还车点";
    returnCarFlag.textColor = UIColorFromRGB(0xDCDCDC);
    returnCarFlag.font = [UIFont systemFontOfSize:12];
    [self addSubview:returnCarFlag];
    
    UIButton *closeViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-autoScaleW(35), 5, autoScaleW(30), autoScaleW(30))];
    [closeViewBtn setImage:[UIImage imageNamed:@"btn_close_green"] forState:UIControlStateNormal];
    [closeViewBtn setImage:[UIImage imageNamed:@"btn_close_green"] forState:UIControlStateSelected];
    [self addSubview:closeViewBtn];
    
    UIButton *clickCloseViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-autoScaleW(50), 0, autoScaleW(50), autoScaleW(50))];
    [clickCloseViewBtn addTarget:self action:@selector(hidCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickCloseViewBtn];
    
    
    UIImageView *locateFlag1 = [[UIImageView alloc] initWithFrame:CGRectMake(returnCarFlag.right, getCarFlag.bottom+autoScaleH(17), 10, 10)];
    locateFlag1.image = [UIImage imageNamed:@"icon_PickLocation"];
    [self addSubview:locateFlag1];
    
    _returnCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(locateFlag1.right+5, getCarFlag.bottom, autoScaleW(200), autoScaleH(45))];
    [_returnCarBtn setTitle:@"查看还车点" forState:UIControlStateNormal];
    [_returnCarBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    _returnCarBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_returnCarBtn addTarget:self action:@selector(returnCarAction) forControlEvents:UIControlEventTouchUpInside];
    _returnCarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_returnCarBtn];
    
    UILabel *rowLine = [[UILabel alloc] initWithFrame:CGRectMake(0, returnCarFlag.bottom, self.width, 1)];
    rowLine.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self addSubview:rowLine];
    
    
    UIView *carInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, rowLine.bottom, self.width, autoScaleH(100))];
    carInfoView.backgroundColor = UIColorFromRGB(0xFCFCFC);
    [self addSubview:carInfoView];
    
    UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(39), autoScaleH(15), autoScaleW(100), autoScaleW(68))];
    [carImgView setImage:[UIImage imageNamed:@"img_car"]];
    [carImgView setContentMode:UIViewContentModeScaleAspectFill];
    carImgView.clipsToBounds=YES;
    carImgView.exclusiveTouch=YES;
    [carInfoView addSubview:carImgView];
    
    //中间线
    UILabel *colLine = [[UILabel alloc] initWithFrame:CGRectMake(0, autoScaleH(35), autoScaleW(1), autoScaleH(23))];
    colLine.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [carInfoView addSubview:colLine];
    colLine.centerX = carInfoView.centerX;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.right+autoScaleW(69), autoScaleH(17), autoScaleW(80), autoScaleH(18))];
    titleLab.text = @"车辆牌号";
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = UIColorFromRGB(0xDCDCDC);
    titleLab.textAlignment = NSTextAlignmentLeft;
    [carInfoView addSubview:titleLab];
    
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom+2, autoScaleW(120), autoScaleH(26))];
    _contentLab.textAlignment = NSTextAlignmentCenter;
    _contentLab.textColor = UIColorFromRGB(0xA0A0A0);
    _contentLab.font = kAvantiBoldSize(3);
    _contentLab.text = @"京A 54321";
    _contentLab.textAlignment = NSTextAlignmentLeft;
    [carInfoView addSubview:_contentLab];
    
    _rentCarPswLB = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.left, _contentLab.bottom, autoScaleW(140), autoScaleW(20))];
    _rentCarPswLB.textColor = kBlueColor;
    _rentCarPswLB.font = [UIFont systemFontOfSize:12.5];
    [carInfoView addSubview:_rentCarPswLB];
    
    
    UILabel *rowLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, carInfoView.bottom, self.width, 1)];
    rowLine2.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self addSubview:rowLine2];
    
    _circleProgressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(autoScaleW(30), rowLine2.bottom+autoScaleH(35), autoScaleW(107), autoScaleW(107)) andPercent:1-0.62 andColor:[UIColor blueColor]];
    [self addSubview:_circleProgressView];
    
    UILabel *kmFlag = [[UILabel alloc] initWithFrame:CGRectMake(_circleProgressView.right+autoScaleW(35), _circleProgressView.top, autoScaleW(80), autoScaleH(15))];
    kmFlag.text = @"行驶里程";
    kmFlag.textColor = UIColorFromRGB(0xC5C5C5);
    kmFlag.font = [UIFont systemFontOfSize:13];
    kmFlag.textAlignment = NSTextAlignmentLeft;
    [self addSubview:kmFlag];
    
    _kmLable = [[UILabel alloc] initWithFrame:CGRectMake(kmFlag.left, kmFlag.bottom+autoScaleH(12), autoScaleW(80), autoScaleH(20))];
    _kmLable.text = @"17km";
    _kmLable.textColor = kBlueColor;
    _kmLable.font = kAvantiBoldSize(3);
    _kmLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_kmLable];
    
    UILabel *timeFlag = [[UILabel alloc] initWithFrame:CGRectMake(kmFlag.left, _kmLable.bottom+autoScaleH(20), autoScaleW(80), autoScaleH(15))];
    timeFlag.text = @"用车时长";
    timeFlag.textColor = UIColorFromRGB(0xC5C5C5);
    timeFlag.font = [UIFont systemFontOfSize:13];
    timeFlag.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeFlag];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(kmFlag.left, timeFlag.bottom+autoScaleH(12), autoScaleW(90), autoScaleH(20))];
    _timeLable.text = @"18:39";
    _timeLable.textColor = kBlueColor;
    _timeLable.font = kAvantiBoldSize(3);
    _timeLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_timeLable];
    
    UILabel *xhKmFlag = [[UILabel alloc] initWithFrame:CGRectMake(kmFlag.right+autoScaleW(10), _circleProgressView.top, autoScaleW(80), autoScaleH(15))];
    xhKmFlag.text = @"预计续航";
    xhKmFlag.textColor = UIColorFromRGB(0xC5C5C5);
    xhKmFlag.font = [UIFont systemFontOfSize:13];
    xhKmFlag.textAlignment = NSTextAlignmentLeft;
    [self addSubview:xhKmFlag];
    
    _xhKmLable = [[UILabel alloc] initWithFrame:CGRectMake(xhKmFlag.left, kmFlag.bottom+10, autoScaleW(80), autoScaleH(20))];
    _xhKmLable.text = @"108km";
    _xhKmLable.textColor = kBlueColor;
    _xhKmLable.font = kAvantiBoldSize(3);
    _xhKmLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_xhKmLable];
    
    UILabel *priceFlag = [[UILabel alloc] initWithFrame:CGRectMake(xhKmFlag.left, _kmLable.bottom+autoScaleH(20), autoScaleW(80), autoScaleH(15))];
    priceFlag.text = @"当前费用";
    priceFlag.textColor = UIColorFromRGB(0xC5C5C5);
    priceFlag.font = [UIFont systemFontOfSize:13];
    priceFlag.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceFlag];
    
    _priceLable = [[UILabel alloc] initWithFrame:CGRectMake(xhKmFlag.left, timeFlag.bottom+autoScaleH(12), kScreenWidth-xhKmFlag.left-15, autoScaleH(20))];
    _priceLable.text = @"￥7.5";
    _priceLable.textColor = kBlueColor;
    _priceLable.font = kAvantiBoldSize(3);
    _priceLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_priceLable];
    
    //开车门
    _openDoorBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(7), self.height-autoScaleH(110), autoScaleW(168), autoScaleH(48))];
    _openDoorBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
    [_openDoorBtn setImage:[UIImage imageNamed:@"icon_OpenDoor"] forState:UIControlStateNormal];
    [_openDoorBtn setImage:[UIImage imageNamed:@"icon_OpenDoor_pressed"] forState:UIControlStateHighlighted];
    _openDoorBtn.layer.cornerRadius = autoScaleW(5);
    _openDoorBtn.layer.borderWidth = 1;
    _openDoorBtn.layer.borderColor = UIColorFromRGB(0xE7EDEA).CGColor;
    [_openDoorBtn setTitle:@"开车门" forState:UIControlStateNormal];
    _openDoorBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_openDoorBtn setTitleColor:UIColorFromRGB(0x9F9F9F) forState:UIControlStateNormal];
    [_openDoorBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -autoScaleW(15), 0.0, 0.0)];
    [_openDoorBtn addTarget:self action:@selector(openDoorAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_openDoorBtn];
    
    //关车门
    _closeDoorBtn = [[UIButton alloc] initWithFrame:CGRectMake(_openDoorBtn.right+autoScaleW(6), self.height-autoScaleH(110), autoScaleW(168), autoScaleH(48))];
    _closeDoorBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
    [_closeDoorBtn setImage:[UIImage imageNamed:@"icon_CloseDoor"] forState:UIControlStateNormal];
    [_closeDoorBtn setImage:[UIImage imageNamed:@"icon_CloseDoor_pressed"] forState:UIControlStateHighlighted];
    _closeDoorBtn.layer.cornerRadius = autoScaleW(5);
    _closeDoorBtn.layer.borderWidth = 1;
    _closeDoorBtn.layer.borderColor = UIColorFromRGB(0xE7EDEA).CGColor;
    [_closeDoorBtn setTitle:@"关车门" forState:UIControlStateNormal];
    _closeDoorBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_closeDoorBtn setTitleColor:UIColorFromRGB(0x9F9F9F) forState:UIControlStateNormal];
    [_closeDoorBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -autoScaleW(15), 0.0, 0.0)];
    [_closeDoorBtn addTarget:self action:@selector(closeDoorAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeDoorBtn];
    
    //结束行程
    _finishRunningBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(7), self.height-autoScaleH(55), autoScaleW(342), autoScaleH(48))];
    [[APPUtil share]setButtonClickStyle:_finishRunningBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    [_finishRunningBtn setTitle:@"结束运维" forState:UIControlStateNormal];
    _finishRunningBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_finishRunningBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finishRunningBtn addTarget:self action:@selector(finishRunningAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_finishRunningBtn];
    
}

#pragma mark - data 

- (void)setItem:(BookingItem *)item {
    
    if (_item != item) {
        _item = item;
    }
    
    _getCarLab.text = _item.startLocation;
    _contentLab.text = _item.numberPlate;
    
    CGFloat socPercent = 100-[_item.soc floatValue];
    NSString *socStr = [NSString stringWithFormat:@"%0.2f",socPercent/100];
    
    if ([socStr floatValue]==0) {
        [_circleProgressView reloadViewWithPercent:0.001];
    } else {
        [_circleProgressView reloadViewWithPercent:[socStr floatValue]];
    }
    
    int minutes = [item.leaseMinutes intValue];
//    NSString *str_hour = [NSString stringWithFormat:@"%02d",(minutes%3600)/60];
//    NSString *str_minute = [NSString stringWithFormat:@"%02d",minutes%60];
    _timeLable.text = [APPUtil handleTimeWithMinus:minutes];
//    [NSString stringWithFormat:@"%@:%@",str_hour,str_minute];
    
    _kmLable.text = [NSString stringWithFormat:@"%@km",[APPUtil isBlankString:item.leaseMileage]?@"0":item.leaseMileage];
    _xhKmLable.text = [NSString stringWithFormat:@"%@km",[APPUtil isBlankString:item.remainingKm]?@"0":item.remainingKm];
    _priceLable.text = [NSString stringWithFormat:@"￥%@",[APPUtil isBlankString:item.leaseMoney]?@"0":item.leaseMoney];
    NSInteger fontSize = _priceLable.width/[APPUtil unicodeLengthOfString:_priceLable.text];
    _priceLable.font = [UIFont fontWithName:@"AvantiBold" size:MIN(fontSize-1.5, 18)];
    NSString *rentPswStr = [[NSUserDefaults standardUserDefaults]objectForKey:kRentPswKey];;
    _rentCarPswLB.text = @"";
    if (![APPUtil isBlankString:rentPswStr]) {
        _rentCarPswLB.text = [NSString stringWithFormat:@"租车密码：%@",rentPswStr];
    }
    
    
}

#pragma mark - methods

//查看还车点
- (void)returnCarAction {
    
    [StatisticsClass eventId:XC02];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithReturnCarEvent)]) {
        [self.delegate onClickWithReturnCarEvent];
    }
}

//开车门
- (void)openDoorAction {
    
    [StatisticsClass eventId:XC03];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithOpenCarDoorEvent:)]) {
        [self.delegate onClickWithOpenCarDoorEvent:self.item];
    }
}

//关车门
- (void)closeDoorAction {
    
    [StatisticsClass eventId:XC04];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithCloseCarDoorEvent:)]) {
        [self.delegate onClickWithCloseCarDoorEvent:self.item];
    }
}

//结束行程
- (void)finishRunningAction {
    
    [StatisticsClass eventId:XC05];
    
    _finishRunningBtn.backgroundColor = kBlueColor;
    [_finishRunningBtn.layer setMasksToBounds:NO];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithFinishRunningEvent:)]) {
        [self.delegate onClickWithFinishRunningEvent:self.item];
    }
}

//关闭当前页面
- (void)hidCurrentView{
    
    _finishRunningBtn.backgroundColor = kBlueColor;
    [_finishRunningBtn.layer setMasksToBounds:NO];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithCloseViewEvent:)]) {
        [self.delegate onClickWithCloseViewEvent:self.item];
    }

}


@end
