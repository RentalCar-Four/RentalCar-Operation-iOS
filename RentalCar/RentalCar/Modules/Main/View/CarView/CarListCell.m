//
//  CarListCell.m
//  RentalCar
//
//  Created by MEyo on 2018/5/30.
//  Copyright © 2018年 xyx. All rights reserved.
//

#import "CarListCell.h"

@interface CarListCell ()

@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UILabel *licenseLabel;   //车牌
@property (nonatomic, strong) UILabel *apartLabel;     //离你多远
@property (nonatomic, strong) UILabel *batteryLabel;   //电池剩余
@property (nonatomic, strong) UILabel *distanceLabel;  //续航距离

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _carImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(90, 75));
        }];
        
        imageView;
    });
    
    _licenseLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"0x05C247"];
        label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(24);
            make.left.equalTo(self.carImageView.mas_right).offset(15);
        }];
        
        label;
    });
    
    _apartLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:8];
        label.backgroundColor = UIColorFromValue(195,208,212);
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.licenseLabel.mas_right).offset(8);
            make.centerY.equalTo(self.licenseLabel);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        label;
    });
    
    UIImageView *batteryImgView = [[UIImageView alloc] init];
    batteryImgView.image = [UIImage imageNamed:@"icon_battery"];
    [self.contentView addSubview:batteryImgView];
    
    [batteryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.licenseLabel);
        make.top.equalTo(self.licenseLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    _batteryLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(batteryImgView.mas_right).offset(10);
            make.centerY.equalTo(batteryImgView);
        }];
        
        label;
    });
    
    UIImageView *distanceImgView = [[UIImageView alloc] init];
    distanceImgView.image = [UIImage imageNamed:@"icon_distance"];
    [self.contentView addSubview:distanceImgView];
    
    [distanceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.batteryLabel.mas_right).offset(25);
        make.centerY.equalTo(batteryImgView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    _distanceLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(distanceImgView.mas_right).offset(10);
            make.centerY.equalTo(batteryImgView);
        }];
        
        label;
    });
}

- (void)setModel:(StationCarItem *)model {
    
    _carImageView.image = [UIImage imageNamed:@"icon_car_list"];
    
    _licenseLabel.text = model.numberPlate;
    _apartLabel.text = model.distance;
    
    NSString *remainingSoc = [APPUtil isBlankString:model.soc] ? @"0" : model.soc;
    NSMutableAttributedString *attributedSoc = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", remainingSoc, @"%"]];
    [attributedSoc addAttribute:NSFontAttributeName value:kAvantiBoldSize(8) range:NSMakeRange(0, attributedSoc.length - 2)];
    [attributedSoc addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedSoc.length - 2)];
    [attributedSoc addAttribute:NSFontAttributeName value:kAvantiBoldSize(1) range:NSMakeRange(attributedSoc.length - 1, 1)];
    [attributedSoc addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xDCDCDC) range:NSMakeRange(attributedSoc.length - 1, 1)];
    _batteryLabel.attributedText = attributedSoc;
    
    NSString *remainingKM = [APPUtil isBlankString:model.remainingKm] ? @"0" : model.remainingKm;
    NSMutableAttributedString *attributedKM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", remainingKM, @"km"]];
    [attributedKM addAttribute:NSFontAttributeName value:kAvantiBoldSize(8) range:NSMakeRange(0, attributedKM.length - 3)];
    [attributedKM addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedKM.length - 3)];
    [attributedKM addAttribute:NSFontAttributeName value:kAvantiBoldSize(1) range:NSMakeRange(attributedKM.length - 2, 2)];
    [attributedKM addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xDCDCDC) range:NSMakeRange(attributedKM.length - 2, 2)];
    _distanceLabel.attributedText = attributedKM;
}

@end
