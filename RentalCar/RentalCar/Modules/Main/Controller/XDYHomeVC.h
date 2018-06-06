//
//  XDYHomeVC.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/7.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"

//扫描按钮的状态
typedef NS_ENUM(NSInteger, ENUMHomeScanBtnState) {
    ENUMHomeScanBtnStateNormal=0,//默认扫描状态
    ENUMHomeScanBtnShowLease,//查看行程
//    ENUMHomeScanBtnStateNormal
};


@interface XDYHomeVC : BaseController

@end
