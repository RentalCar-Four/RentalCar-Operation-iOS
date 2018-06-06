//
//  CarReturnView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarReturnView.h"
#import "StationItem.h"

@interface CarReturnView ()
{
    UILabel *_stationLab;
    UILabel *_distanceLab;
    UIButton *_carGuideBtn;
}
@end

@implementation CarReturnView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
    self.frame = CGRectMake(autoScaleW(10), autoScaleH(667), autoScaleW(355), autoScaleH(115));
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = autoScaleW(10);
    [APPUtil setViewShadowStyle:self];
    self.alpha = 0;
    
    UILabel *getCarFlag = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, autoScaleW(60), autoScaleH(48))];
    getCarFlag.text = @"取车点";
    getCarFlag.textColor = UIColorFromRGB(0xDCDCDC);
    getCarFlag.font = [UIFont systemFontOfSize:12];
    [self addSubview:getCarFlag];
    
    UIImageView *locateFlag = [[UIImageView alloc] initWithFrame:CGRectMake(getCarFlag.right, autoScaleH(19), 10, 10)];
    locateFlag.image = [UIImage imageNamed:@"icon_PickLocation"];
    [self addSubview:locateFlag];
    
    _stationLab = [[UILabel alloc] initWithFrame:CGRectMake(locateFlag.right+5, 0, autoScaleW(200), autoScaleH(48))];
    _stationLab.text = @"五道口嘉园地面停车场";
    _stationLab.font = [UIFont systemFontOfSize:13];
    _stationLab.textColor = UIColorFromRGB(0x808080);
    [self addSubview:_stationLab];
    
    _distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(_stationLab.right, autoScaleH(14), 40, autoScaleH(20))];
    _distanceLab.backgroundColor = UIColorFromRGB(0x939393);
    _distanceLab.text = @"560M";
    _distanceLab.textAlignment = NSTextAlignmentCenter;
    _distanceLab.font = [UIFont systemFontOfSize:9];
    _distanceLab.textColor = [UIColor whiteColor];
    [self addSubview:_distanceLab];
    
    UILabel *rowLine = [[UILabel alloc] initWithFrame:CGRectMake(0, getCarFlag.bottom, self.width, 1)];
    rowLine.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self addSubview:rowLine];
    
    _carGuideBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, rowLine.bottom+6, self.width-12, 44)];
    _carGuideBtn.backgroundColor = kBlueColor;
    _carGuideBtn.layer.cornerRadius = autoScaleW(5);
    [APPUtil setViewShadowStyle:_carGuideBtn];
    [_carGuideBtn setTitle:@"开始导航" forState:UIControlStateNormal];
    _carGuideBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_carGuideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_carGuideBtn addTarget:self action:@selector(carGuideAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_carGuideBtn];
}

- (void)carGuideAction {
    if ([self.delegate respondsToSelector:@selector(onClickWithReturnCarGuideEvent:)]) {
        [self.delegate onClickWithReturnCarGuideEvent:self.stationItem];
    }
}

- (void)setStationItem:(StationItem *)stationItem {
    if (_stationItem!=stationItem) {
        _stationItem = stationItem;
    }
    
    _stationLab.text = _stationItem.stationName;
    _distanceLab.text = _stationItem.distance;
}

@end
