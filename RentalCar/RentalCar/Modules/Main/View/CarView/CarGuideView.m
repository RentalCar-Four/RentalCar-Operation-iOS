//
//  CarReturnView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarGuideView.h"
#import "StationCarItem.h"

@interface CarGuideView ()
{
    UILabel *_stationLab;
     UILabel *_stationNameLab;
    UILabel *_distanceLab;
    UILabel *_getCarFlag;
    UIView  *_pileView;
    UILabel *_pileFlag;
    UILabel *_pileCountLab;
    UILabel *_rowLine;
    UIButton *_carGuideBtn;
}
@end

@implementation CarGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
    self.frame = CGRectMake(autoScaleW(10), autoScaleH(667), autoScaleW(355), autoScaleH(163));
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = autoScaleW(10);
    [APPUtil setViewShadowStyle:self];
    self.alpha = 0;
    
    _getCarFlag = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, autoScaleW(60), autoScaleH(48))];
    _getCarFlag.text = @"取车点";
    _getCarFlag.textColor = UIColorFromRGB(0xDCDCDC);
    _getCarFlag.font = [UIFont systemFontOfSize:12];
    [self addSubview:_getCarFlag];
    
    UIImageView *locateFlag = [[UIImageView alloc] initWithFrame:CGRectMake(_getCarFlag.right, autoScaleH(18), autoScaleW(12), autoScaleW(12))];
    locateFlag.image = [UIImage imageNamed:@"icon_PickLocation"];
    [self addSubview:locateFlag];
    
    _stationNameLab = [[UILabel alloc] initWithFrame:CGRectMake(locateFlag.right+5, 0, autoScaleW(200), autoScaleH(48))];
    _stationNameLab.text = @"五道口嘉园地面停车场";
    _stationNameLab.font = [UIFont systemFontOfSize:13];
    _stationNameLab.textColor = UIColorFromRGB(0x808080);
    [self addSubview:_stationNameLab];
    
    _distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(_stationNameLab.right, autoScaleH(14), 40, autoScaleH(20))];
    _distanceLab.backgroundColor = UIColorFromRGB(0x939393);
    _distanceLab.text = @"560M";
    _distanceLab.textAlignment = NSTextAlignmentCenter;
    _distanceLab.font = [UIFont systemFontOfSize:9];
    _distanceLab.textColor = [UIColor whiteColor];
    [self addSubview:_distanceLab];
    
    _pileView = [[UIView alloc] initWithFrame:CGRectMake(0, _getCarFlag.bottom, self.width, autoScaleH(30))];
    [self addSubview:_pileView];
    
    _pileFlag = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, autoScaleW(90), autoScaleH(20))];
    _pileFlag.text = @"实体充电桩";
    _pileFlag.textColor = UIColorFromRGB(0xDCDCDC);
    _pileFlag.font = [UIFont systemFontOfSize:12];
    [_pileView addSubview:_pileFlag];
    
    UIImageView *pileFlag = [[UIImageView alloc] initWithFrame:CGRectMake(_pileFlag.right, autoScaleH(4), autoScaleW(12), autoScaleW(12))];
    pileFlag.image = [UIImage imageNamed:@"icon_pile_flag"];
    [_pileView addSubview:pileFlag];
    
    _stationLab = [[UILabel alloc] initWithFrame:CGRectMake(pileFlag.right+5, 0, autoScaleW(200), autoScaleH(20))];
    _stationLab.text = @"1个";
    _stationLab.font = [UIFont systemFontOfSize:13];
    _stationLab.textColor = UIColorFromRGB(0x808080);
    [_pileView addSubview:_stationLab];
    
    
    _rowLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _pileView.bottom, self.width, 1)];
    _rowLine.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self addSubview:_rowLine];
    
    _carGuideBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, _rowLine.bottom+6, self.width-12, autoScaleH(48))];
    [[APPUtil share]setButtonClickStyle:_carGuideBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    [_carGuideBtn setTitle:@"开始导航" forState:UIControlStateNormal];
    _carGuideBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_carGuideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_carGuideBtn addTarget:self action:@selector(carGuideAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_carGuideBtn];
}

- (void)carGuideAction {
    
    _carGuideBtn.backgroundColor = kBlueColor;
    [_carGuideBtn.layer setMasksToBounds:NO];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithReturnCarGuideEvent:)]) {
        [self.delegate onClickWithReturnCarGuideEvent:self.stationItem];
    }
}

- (void)setStationItem:(StationCarItem *)stationItem {
    if (_stationItem!=stationItem) {
        _stationItem = stationItem;
    }
    
    _stationNameLab.text = _stationItem.stationName;
    _distanceLab.text = _stationItem.distance;
    if ([_stationItem.entityPileCount integerValue]>0) {
        self.height = [self getHeight:YES];
        _pileView.hidden = NO;
        _stationLab.text = [NSString stringWithFormat:@"%@个",_stationItem.entityPileCount];
        _rowLine.top = _pileView.bottom;
    } else {
        self.height = [self getHeight:NO];
        _pileView.hidden = YES;
        _rowLine.top = _getCarFlag.bottom;
    }
    _carGuideBtn.top = _rowLine.bottom+6;
}

- (CGFloat)getHeight:(BOOL)isHavePile {
    if (isHavePile==YES) {
        return autoScaleH(145);
    } else {
        return autoScaleH(115);
    }
}

@end
