//
//  MyTravelCell.h
//  RentalCar
//
//  Created by Hulk on 2017/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTravelModel.h"

@interface MyTravelCell : UITableViewCell
@property (nonatomic, strong) MyTravelModel *model;
//主cell
+ (instancetype)cellWithTableView:(UITableView *)tablView indexPath:(NSIndexPath *)indexPath;

//第几行
@property (nonatomic , strong) NSIndexPath *indexpath;

//cell详情
- (void)setupDetailView;
@end
