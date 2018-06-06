//
//  XDYPickerView.h
//  RentalCar
//
//  Created by Hulk on 2017/3/10.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYPickerView : UIView

@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIPickerView *pickerView;

//快速创建
+(instancetype)pickerView;

//弹出
-(void)show;

@end
