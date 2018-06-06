//
//  CarFeeDetailView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/29.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarFeeDetailView.h"

@interface CarFeeDetailView ()
{
    UIView      *_mainView;
    UIView      *_topView;
    UIView      *_middleView;
    UIView      *_bottomView;
    
    UILabel     *_startAddress;
    UILabel     *_overAddress;
    
    UILabel     *_moneyLab;
    
    UIButton    *_doneBtn;
}
@end

@implementation CarFeeDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp{
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:1];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:beffect];
    blurView.frame = self.bounds;
    blurView.alpha = 1;
    [self addSubview:blurView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(28), autoScaleH(110), autoScaleW(320), autoScaleH(390))];
    _mainView.layer.cornerRadius = autoScaleW(10);
    _mainView.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
    _mainView.layer.shadowOpacity = 0.2; //透明度
    _mainView.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    _mainView.layer.shadowRadius = autoScaleW(6); //模糊度
    _mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:_mainView];
    
    /******上*******/
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, autoScaleW(320), autoScaleH(156))];
    _topView.backgroundColor = [UIColor whiteColor];
    //上面左、右圆角
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(autoScaleW(10), autoScaleW(10))];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _topView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    _topView.layer.mask = maskLayer1;
    [APPUtil setViewShadowStyle:_topView];
    [_mainView addSubview:_topView];
    
    UIImageView *startPoint = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(32), autoScaleH(34), autoScaleW(10), autoScaleW(10))];
    startPoint.image = [UIImage imageNamed:@"icon_ListStart"];
    [_topView addSubview:startPoint];
    
    UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.left+autoScaleW(20), autoScaleH(32), 100, autoScaleH(14))];
    startLab.text = @"取车点";
    startLab.textColor = UIColorFromRGB(0x888888);
    startLab.font = [UIFont systemFontOfSize:autoScaleW(14)];
    [_topView addSubview:startLab];
    
    _startAddress = [[UILabel alloc] initWithFrame:CGRectMake(startLab.left, startLab.bottom+autoScaleH(10), autoScaleW(230), autoScaleH(14))];
    _startAddress.text = @"五道口优盛大厦地面停车场1024#停车位";
    _startAddress.font = [UIFont systemFontOfSize:autoScaleW(12)];
    _startAddress.textColor = UIColorFromRGB(0xBEBEBE);
    [_topView addSubview:_startAddress];
    
    UIImageView *overPoint = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(32), autoScaleH(92), autoScaleW(10), autoScaleW(10))];
    overPoint.image = [UIImage imageNamed:@"icon_ListOver"];
    [_topView addSubview:overPoint];
    
    UILabel *overLab = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.left+autoScaleW(20), autoScaleH(90), 100, autoScaleH(14))];
    overLab.text = @"还车点";
    overLab.textColor = UIColorFromRGB(0x888888);
    overLab.font = [UIFont systemFontOfSize:autoScaleW(14)];
    [_topView addSubview:overLab];
    
    _overAddress = [[UILabel alloc] initWithFrame:CGRectMake(overLab.left, overLab.bottom+autoScaleH(10), autoScaleW(230), autoScaleH(14))];
    _overAddress.text = @"回龙观华联商场地面停车场2048#停车位";
    _overAddress.font = [UIFont systemFontOfSize:autoScaleW(12)];
    _overAddress.textColor = UIColorFromRGB(0xBEBEBE);
    [_topView addSubview:_overAddress];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(35), _topView.bottom-autoScaleH(2), autoScaleW(250), autoScaleH(2))];
    lineView.backgroundColor = UIColorFromRGB(0x979797);
    lineView.alpha = 0.1;
    [_topView addSubview:lineView];
    
    
    /******中*******/
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bottom-autoScaleH(1), _mainView.width, autoScaleH(118))];
    _middleView.backgroundColor = [UIColor whiteColor];
    [_mainView addSubview:_middleView];
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, autoScaleH(390-117), _mainView.width, autoScaleH(30))];
    lineImgView.image = [UIImage imageNamed:@"img_DetailBg"];
    [_mainView addSubview:lineImgView];
    
    /******下*******/
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, lineImgView.bottom-1, _mainView.width, autoScaleH(87))];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [APPUtil setViewShadowStyle:_bottomView];
    //下面左、右圆角
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(autoScaleW(10), autoScaleW(10))];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _bottomView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _bottomView.layer.mask = maskLayer2;
    [_mainView addSubview:_bottomView];
    
    UILabel *feeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, autoScaleH(26), _mainView.width, autoScaleH(12))];
    feeLab.text = @"行程费用小计";
    feeLab.textColor = UIColorFromRGB(0xBDBDBD);
    feeLab.font = [UIFont systemFontOfSize:12];
    feeLab.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:feeLab];
    
    _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, feeLab.bottom, _mainView.width, autoScaleH(24))];
    //_moneyLab.text = @"4.5元";
    _moneyLab.font = [UIFont systemFontOfSize:12];
    _moneyLab.textColor = UIColorFromRGB(0x969696);
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_moneyLab];
    
    //我知道了
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(_mainView.left,  _mainView.bottom+autoScaleH(10), _mainView.width, autoScaleH(48))];
    [[APPUtil share]setButtonClickStyle:_doneBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    
    [_doneBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneBtn];
}

- (void)setResultDic:(NSDictionary *)resultDic {
    
    if (_resultDic!=resultDic) {
        _resultDic = resultDic;
    }
    
    _startAddress = [APPUtil isBlankString:resultDic[@"rentAddress"]]?@"":resultDic[@"rentAddress"];
    _overAddress = [APPUtil isBlankString:resultDic[@"alsoAddress"]]?@"":resultDic[@"alsoAddress"];
    
    NSArray *leftTitleArr = @[@"用车时长(18分39秒)",@"封顶减免",@"活动减免",@"优惠券抵扣"];
    NSArray *rightTitleArr = @[@"0.0 元",@"6.0 元",@"0.0 元",@"-1.5 元"];
    
    NSArray *feeDetailArr = resultDic[@"feeDetail"];
    
    for (int i = 0; i<feeDetailArr.count; i++) {
        
        NSDictionary *typeDic = feeDetailArr[i];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(35), autoScaleH(132-93)/2+autoScaleH(27)*i, autoScaleW(250), autoScaleH(12))]; //3：66 4：93
        [_middleView addSubview:bgView];
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, autoScaleW(150), bgView.height)];
        leftLab.text = typeDic[@"name"];
        leftLab.textColor = UIColorFromRGB(0xBDBDBD);
        leftLab.font = [UIFont systemFontOfSize:autoScaleW(12)];
        [bgView addSubview:leftLab];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLab.right, 0, autoScaleW(100), bgView.height)];
        rightLab.text = [NSString stringWithFormat:@"%@ 元",typeDic[@"fee"]];
        rightLab.textColor = UIColorFromRGB(0xBDBDBD);
        rightLab.font = [UIFont systemFontOfSize:autoScaleW(12)];
        rightLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:rightLab];
    }
    
    NSString *totalFee = [APPUtil isBlankString:resultDic[@"totalFee"]]?@"":resultDic[@"totalFee"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",totalFee]];
    [attributedStr addAttribute:NSFontAttributeName value:kAvantiBoldSize(9) range:NSMakeRange(0, totalFee.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x787878) range:NSMakeRange(0, totalFee.length)];
    _moneyLab.attributedText = attributedStr;
}

#pragma mark - methods

-(void)downClick:(UIButton *)button{
    
    button.backgroundColor = UIColorFromRGB(0x09C58A);
    [_doneBtn.layer setMasksToBounds:YES];
}

//显示动画
- (void)showAnimation {
    _mainView.top = autoScaleH(110)+30;
    _mainView.alpha = 0;
    _doneBtn.top = _mainView.bottom+autoScaleH(10);
    _doneBtn.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.top = autoScaleH(110);
        _mainView.alpha = 1;
        _doneBtn.top = _mainView.bottom+autoScaleH(10);
        _doneBtn.alpha = 1;
    } completion:nil];
}

//消失动画
- (void)hideAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        _mainView.top = autoScaleH(110)+30;
        _mainView.alpha = 0;
        _doneBtn.top = _mainView.bottom+autoScaleH(10);
        _doneBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//我知道了
- (void)doneAction {
    
    _doneBtn.backgroundColor = kBlueColor;
    [_doneBtn.layer setMasksToBounds:NO];
    
    [self hideAnimation];
    
    if (self.doneBlock) {
        self.doneBlock();
    }
}

@end
