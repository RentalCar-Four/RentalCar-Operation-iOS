//
//  defaultDataView.h
//  RentalCar
//
//  Created by Hulk on 2017/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol defaultDataViewDelegate <NSObject>

-(void)backMap;
-(void)openInvalid:(UIButton*)buton;

@end

@interface defaultDataView : UIView
@property(nonatomic,assign) id <defaultDataViewDelegate> delegate;
@property(nonatomic,assign)int PushType;//0行程空 1优惠券空 2无有效优惠券
@end
