//
//  HomeCustomView.h
//  SMMenuButton
//
//  Created by zhanbing han on 2017/10/16.
//  Copyright © 2017年 朱思明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Addition.h"

@interface HomeCustomView : UIView

@property (nonatomic , retain)NSArray *buttonNameArr;
@property (nonatomic , retain)NSArray *buttonIconSelectArr;
@property (nonatomic , retain)NSArray *buttonIconNormalArr;
@property (nonatomic , copy)void (^TouchAction)(NSString *title,NSInteger index);
- (void)resetView;

@end
