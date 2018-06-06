//
//  CarAnnotationView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/9.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CarAnnotationView.h"

@interface CarAnnotationView ()

@end

@implementation CarAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, autoScaleW(67), autoScaleW(75));
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(0), autoScaleW(8), autoScaleW(60), autoScaleW(60))];
        _imgView.image = [UIImage imageNamed:@"icon_pile_marker_selected"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        _socLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(10), autoScaleW(11), autoScaleW(40), autoScaleW(40))];
        _socLab.font = [UIFont boldSystemFontOfSize:autoScaleW(15)];
        _socLab.textColor = [UIColor whiteColor];
        _socLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_socLab];
        
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(42), autoScaleW(0), autoScaleW(20), autoScaleW(20))];
        _countLab.backgroundColor = kBlueColor;
        _countLab.layer.cornerRadius = _countLab.width/2;
        [_countLab.layer setMasksToBounds:YES];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.font = [UIFont systemFontOfSize:autoScaleW(12)];
        _countLab.textColor = [UIColor whiteColor];
        [self addSubview:_countLab];
        
        _loadImgView = [[UIImageView alloc] initWithFrame:_countLab.frame];
        _loadImgView.hidden = YES;
        _loadImgView.backgroundColor = kBlueColor;
        _loadImgView.layer.cornerRadius = _loadImgView.width/2;
        [_loadImgView.layer setMasksToBounds:YES];
        [self addSubview:_loadImgView];
    }
    
    return self;
}

- (void)setItem:(StationCarItem *)item {
    
    if ([item.showType isEqualToString:@"1"]) { //网点
        _socLab.hidden = YES;
        if ([APPUtil isBlankString:item.vehicleCnt] || [item.vehicleCnt isEqualToString:@"0"]) {
            _countLab.hidden = YES;
            _imgView.image = [UIImage imageNamed:@"icon_gray_marker"];
        } else {
            _countLab.hidden = NO;
            _countLab.text = item.vehicleCnt;
            _imgView.image = [UIImage imageNamed:@"icon_pile_marker"];
        }
    } else if ([item.showType isEqualToString:@"2"]) { //车辆
        _countLab.hidden = YES;
        _socLab.hidden = NO;
        if (![APPUtil isBlankString:item.soc]) {
            _socLab.text = [NSString stringWithFormat:@"%@%@",item.soc,@"%"];
        }
//        NSLog(@"车辆电量：%@",_socLab.text);
//        _imgView.image = [UIImage imageNamed:@"icon_car_marker"];
        NSString *imageName = @"";
        if ([item.carType integerValue]==1) { //分时
            imageName = [NSString stringWithFormat:@"car_icon_1_%@",item.carStatus];
        } else { //长租
             imageName = [NSString stringWithFormat:@"car_icon_2_%@",item.carStatus];
        }
        _imgView.image = [UIImage imageNamed:imageName];
        
    }
}

@end
