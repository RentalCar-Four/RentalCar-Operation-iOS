//
//  scnDriveViewController.h
//  RentalCar
//
//  Created by Hulk on 2017/3/15.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"

@protocol ScnDrivePhotoDelegate <NSObject>

-(void)onImg:(UIImage*)selectImg;

@end

@interface ScnDriveViewController : UIViewController
@property(nonatomic,weak)id<ScnDrivePhotoDelegate> scnDriveDelegate;
@property(nonatomic,assign)NSInteger pushType;
@end
