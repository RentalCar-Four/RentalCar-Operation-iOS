//
//  StartScnBtnAndLoding.h
//  RentalCar
//
//  Created by Hulk on 2017/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LodingDelegate <NSObject>

-(void)onDone:(int)reaNimate;

@end

@interface StartScnBtnAndLoding : UIButton

@property(nonatomic, retain)UIImageView *bgimg;//背景色
@property(nonatomic, retain)UIImageView *leftimg;//前景色
@property(nonatomic, retain)UILabel *presentlab;//成功的title
@property(nonatomic,assign)float maxValue;
@property(nonatomic,assign)id<LodingDelegate> delegate;
@property(nonatomic,assign)int reaNimate;

-(void)setPresent:(int)present;

-(void)OKAlpha;
-(void)NOAlpha;
@end
