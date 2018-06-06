//
//  NavBarView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/26.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "NavBarView.h"
#import "ZPPOPTextField.h"


@interface NavBarView ()
{
    BaseController *_baseVC;
    
    int count;
}
@end

@implementation NavBarView

- (id)initWithFrame:(CGRect)frame withController:(BaseController *)baseVC {
    
    if (self = [super initWithFrame:frame]) {
        
        _baseVC = baseVC;
        
        count = 0;
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
      //头像
    UIView *leftNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    _leftBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 26, 26)];
    _leftBtn.contentMode = UIViewContentModeScaleAspectFill;
    _leftBtn.layer.cornerRadius = _leftBtn.width/2;
    [_leftBtn.layer setMasksToBounds:YES];
    _leftBtn.image = [UIImage imageNamed:@"img_avatar_logout"];
    [leftNavView addSubview:_leftBtn];
    
    
    [leftNavView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftMenu)]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavView];
    
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -autoScaleW(8);
    
    //将两个BarButtonItem都返回给NavigationItem
    _baseVC.navItem.leftBarButtonItems = @[spaceItem,leftItem];
    
    //Logo、区域
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 14.0f, 55.0f, 16.0f)];//初始化图片视图控件
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    [logoImgView setImage:[UIImage imageNamed:@"img_Logo"]];
    [titleView addSubview:logoImgView];
    
    _cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(logoImgView.right+5, 13.5, 80, 16)];
    [_cityBtn setImage:[UIImage imageNamed:@"icon_Dropdown"] forState:UIControlStateNormal];
    [_cityBtn setTitleColor:UIColorFromRGB(0x4D4D4D) forState:UIControlStateNormal];
    [_cityBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(-2.0, 36, 0.0, 0)];
    [_cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5)];
    _cityBtn.hidden = YES;
    [titleView addSubview:_cityBtn];
    
    UIButton *clickCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(logoImgView.left, 0, 140, 44)];
    [clickCityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:clickCityBtn];
    
    _loadingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(logoImgView.right+8, 13, 20, 20)];
    _loadingImgView.hidden = YES;
    _loadingImgView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:_loadingImgView];
    
    _baseVC.navItem.titleView = titleView;//设置导航栏的titleView为titleView
    
    //切换服务器(测试)
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, 0, 50, 44)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setImage:[UIImage imageNamed:@"sousuo"] forState:0];
    [rightBtn addTarget:self action:@selector(searchCarInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _baseVC.navItem.rightBarButtonItem = rightItem;
}

//显示侧滑菜单
- (void)showLeftMenu {
    
    if ([self.delegate respondsToSelector:@selector(onClickWithShowLeftMenuEvent)]) {
        [self.delegate onClickWithShowLeftMenuEvent];
    }
}

//选择城市
- (void)selectCity {
    
    if ([self.delegate respondsToSelector:@selector(onClickWithSelectCityEvent)]) {
        [self.delegate onClickWithSelectCityEvent];
    }
}

//切换服务器
- (void)searchCarInfo {
    
    ZPPOPTextField *popView =  [[ZPPOPTextField alloc] initWithTitle:@"请输入车牌号码" textFieldInitialValue:@"请输入车牌号码" textFieldTextMaxLength:50 textFieldText:^(NSString *textFieldText) {
        DebugLog(@"string%@",textFieldText);
        if ([self.delegate respondsToSelector:@selector(onClickWithSearchCarInfo:)]&&textFieldText.length>0) {
            [self.delegate onClickWithSearchCarInfo:[textFieldText uppercaseString]];
        }
    }];
    [popView show];
}

@end
