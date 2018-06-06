//
//  ScanUnLockView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/23.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ScanUnLockView.h"
#import "ScanCarInfoItem.h"

@interface ScanUnLockView ()
{
    UILabel *_stationLab; //网点
    UILabel *_distanceLab; //距离
    UIButton *_cancelBtn; //取消
    UIButton *_unlockCarBtn; //开锁用车
}
@end

@implementation ScanUnLockView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
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
    
    UIView *carView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, getCarFlag.bottom, self.width, autoScaleH(209))];
    [self addSubview:carView];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-autoScaleW(160))/2, 0, autoScaleW(160), autoScaleW(108))];
    [_imgView setImage:[UIImage imageNamed:@"img_car"]];
    [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    _imgView.clipsToBounds=YES;
    _imgView.exclusiveTouch=YES;
    _imgView.userInteractionEnabled = YES;
    [carView addSubview:_imgView];
    
    _carInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _imgView.bottom, self.width, autoScaleH(73))];
    [carView addSubview:_carInfoView];
    
    _imgView.alpha = 0;
    _imgView.top = 20;
    _carInfoView.alpha = 0;
    _carInfoView.top = _imgView.bottom-5;
    
    //取消
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(8), self.height-autoScaleH(56), autoScaleW(110), autoScaleH(48))];
    _cancelBtn.backgroundColor = UIColorFromRGB(0xFCFCFC);
    _cancelBtn.layer.cornerRadius = autoScaleW(5);
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0xE7EDEA).CGColor;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x9F9F9F) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    //开锁用车
    _unlockCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cancelBtn.right+5, self.height-autoScaleH(56), autoScaleW(225), autoScaleH(48))];
    [[APPUtil share]setButtonClickStyle:_unlockCarBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    [_unlockCarBtn setTitle:@"开锁用车" forState:UIControlStateNormal];
    _unlockCarBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_unlockCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_unlockCarBtn addTarget:self action:@selector(unlockCarAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_unlockCarBtn];
}

#pragma mark - methods

//取消
- (void)cancelAction {
    
    if ([self.delegate respondsToSelector:@selector(onClickWithCancelUnLockCarEvent:)]) {
        [self.delegate onClickWithCancelUnLockCarEvent:self.item];
    }
}

//开锁用车
- (void)unlockCarAction {
    
    _unlockCarBtn.backgroundColor = kBlueColor;
    [_unlockCarBtn.layer setMasksToBounds:NO];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithScanUnLockCarEvent:)]) {
        [self.delegate onClickWithScanUnLockCarEvent:self.item];
    }
}

//计费规则
- (void)priceRuleAction {
    
    [StatisticsClass eventId:YC02];
    
    if ([self.delegate respondsToSelector:@selector(onClickWithPriceRuleEvent:)]) {
        [self.delegate onClickWithPriceRuleEvent:self.item];
    }
}

- (void)setItem:(ScanCarInfoItem *)item {
    
    if (_item != item) {
        _item = item;
    }
    
    _stationLab.text = _item.addr;
    _distanceLab.text = @"0M";
    
    [_carInfoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *titleArr = @[@"可续航里程",@"计价规则",@"车辆牌号"];
    
    for (int j = 0; j<3; j++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width/3*j, autoScaleH(8), self.width/3, autoScaleH(20))];
        titleLab.text = titleArr[j];
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.textColor = UIColorFromRGB(0xDCDCDC);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_carInfoView addSubview:titleLab];
        
        UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake(self.width/3*(j+1), autoScaleH(24), 1, autoScaleH(27))];
        colLine.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [_carInfoView addSubview:colLine];
        
        UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width/3*j, titleLab.bottom, self.width/3, autoScaleH(48))];
        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.textColor = UIColorFromRGB(0xDCDCDC);
        contentLab.font = [UIFont systemFontOfSize:14];
        [_carInfoView addSubview:contentLab];
        
        if (j==0) {
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@KM",[APPUtil isBlankString:item.remainingKm]?@"0":item.remainingKm]];
            [attributedStr addAttribute:NSFontAttributeName value:kAvantiBoldSize(13) range:NSMakeRange(0, attributedStr.length-2)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x25D880) range:NSMakeRange(0, attributedStr.length-2)];
            [attributedStr addAttribute:NSFontAttributeName value:kAvantiBoldSize(1) range:NSMakeRange(attributedStr.length-2, 2)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xDCDCDC) range:NSMakeRange(attributedStr.length-2, 2)];
            contentLab.attributedText = attributedStr;
        }
        
        if (j==1) {
            NSString *priceRule = self.item.pricePerMinute;
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@/分",priceRule]];
//            NSString *priceRule = self.item.priceRule;
//
//            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@/分",[priceRule substringToIndex:3]]];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
            [attributedStr addAttribute:NSFontAttributeName value:kAvantiBoldSize(13) range:NSMakeRange(1, attributedStr.length-3)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x25D880) range:NSMakeRange(1, attributedStr.length-3)];
            contentLab.attributedText = attributedStr;
        }
        
        if (j==2) {
            contentLab.textColor = kBlueColor;
            contentLab.font = kAvantiBoldSize(1);
            contentLab.text = self.item.numberPlate;
        }
    }
    
    UIButton *priceRuleBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width/3, 0, self.width/3, autoScaleH(73))];
    priceRuleBtn.backgroundColor = [UIColor clearColor];
    [priceRuleBtn addTarget:self action:@selector(priceRuleAction) forControlEvents:UIControlEventTouchUpInside];
    [_carInfoView addSubview:priceRuleBtn];
}

@end
