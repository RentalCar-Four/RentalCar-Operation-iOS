//
//  CouponCell.h
//  RentalCar
//
//  Created by Hulk on 2017/4/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface CouponCell : UITableViewCell

//第几行
@property (nonatomic , strong) NSIndexPath *indexpath;
@property(nonatomic,assign)NSInteger cellOnPush;
@property(nonatomic,assign)int cellType;//优惠券类型//1老优惠券//2分时券
@property (nonatomic, strong) CouponModel *model;
//cell详情
- (void)setupDetailView;
-(void)OnSelected:(BOOL)selected animated:(BOOL)animated;
@end
