//
//  PersonCenterViewController.h
//  RentalCar
//
//  Created by Hulk on 2017/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"

@interface PersonCenterViewController : BaseController
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *kilometre;
@property (weak, nonatomic) IBOutlet UILabel *kilogram;
@property (weak, nonatomic) IBOutlet UIView *certifyView;
@property (weak, nonatomic) IBOutlet UIButton *loginOut;
@property (weak, nonatomic) IBOutlet UILabel *renzhengLable;

@property (weak, nonatomic) IBOutlet UILabel *userPwdCar;


@end
