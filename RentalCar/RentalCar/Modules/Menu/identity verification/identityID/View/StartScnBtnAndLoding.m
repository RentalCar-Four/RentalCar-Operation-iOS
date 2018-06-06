//
//  StartScnBtnAndLoding.m
//  RentalCar
//
//  Created by Hulk on 2017/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "StartScnBtnAndLoding.h"

@implementation StartScnBtnAndLoding
{

    CALayer *logoLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize bgimg,leftimg,presentlab;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgimg.layer.borderColor = [UIColor clearColor].CGColor;
        bgimg.layer.borderWidth =  1;
        bgimg.layer.cornerRadius = 5;
        [bgimg.layer setMasksToBounds:YES];
        
        [self addSubview:bgimg];
        leftimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        leftimg.layer.borderColor = [UIColor clearColor].CGColor;
        leftimg.layer.borderWidth =  1;
        leftimg.layer.cornerRadius = 5;
        [leftimg.layer setMasksToBounds:YES];
        [self addSubview:leftimg];
        
        presentlab = [[UILabel alloc] initWithFrame:bgimg.bounds];
        presentlab.textAlignment = NSTextAlignmentCenter;
        presentlab.textColor = [UIColor whiteColor];
        presentlab.font = [UIFont systemFontOfSize:16];
        [self addSubview:presentlab];
        presentlab.text = @"开始扫描";
    }
    return self;
}
-(void)setPresent:(int)present
{
    
    presentlab.text = @"认证中...";
    leftimg.frame = CGRectMake(0, 0, self.frame.size.width/self.maxValue*present, self.frame.size.height);
    [self setUserInteractionEnabled:NO];
    
    if (present == 100) {
//        debugLog(@"到头了");
    }

    

}
//成功的动画
-(void)OKAlpha{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.presentlab setOrigin:CGPointMake(0, -10)];
        [self.presentlab setAlpha:0];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.presentlab setOrigin:CGPointMake(0, 0)];
            [self.presentlab setAlpha:1];
            [self.presentlab setText:@"认证成功"];
            
        } completion:^(BOOL finished) {
            //debugLog(@"%f",bgimg.width);
            [self performSelector:@selector(endOkAlpha) withObject:nil afterDelay:1.0f];
        }];
    }];
    
    
}
//不成功的动画
-(void)NOAlpha{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.presentlab setOrigin:CGPointMake(0, -10)];
        [self.presentlab setAlpha:0];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.presentlab setOrigin:CGPointMake(0, 0)];
            [self.presentlab setAlpha:1];
            [self.presentlab setText:@"认证失败"];
            
        } completion:^(BOOL finished) {
            //debugLog(@"%f",bgimg.width);
            //[self performSelector:@selector(butAlpha) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(reRenzheng) withObject:nil afterDelay:0.5];
        }];
    }];
    
   }
//重新认证的动画
-(void)reRenzheng{
    [UIView animateWithDuration:0.5 animations:^{
        
        
        [self.leftimg setBackgroundColor:[UIColor colorWithHexString:@"#fd7f66"]];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.presentlab setText:@"重新认证"];
            [self.leftimg setBackgroundColor:[UIColor colorWithHexString:@"#26d880"]];
            
        } completion:^(BOOL finished) {
            [self.leftimg setSize:CGSizeMake(0, self.bgimg.height)];
             [self.leftimg setBackgroundColor:[UIColor colorWithHexString:@"#09c58a"]];
             [self.bgimg setBackgroundColor:[UIColor colorWithHexString:@"#26d880"]];
        }];
        
    }];
}
//认证成功结束的动画
-(void)endOkAlpha{
    [UIView animateWithDuration:0.5 animations:^{
        [self.leftimg setOrigin:CGPointMake(self.leftimg.width/2, self.leftimg.origin.y)];
        [self.bgimg setOrigin:CGPointMake(self.leftimg.width/2, self.bgimg.origin.y)];
        [self.leftimg setSize:CGSizeMake(self.leftimg.width/2, self.leftimg.height)];
        [self.bgimg setSize:CGSizeMake(self.bgimg.width/2, self.bgimg.height)];
        [self.leftimg setAlpha:0];
        [self.bgimg setAlpha:0];
        
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(onDone:)]) {
            [self.delegate onDone:self.reaNimate];
        }
    }];
}


@end
