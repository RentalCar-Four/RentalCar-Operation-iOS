//
//  HeaderView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/7.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return  self;
}

-(void)layoutSubviews{
    [self setUp];
}

- (void)setUp{

    self.cirHeaderView.frame = CGRectMake(autoScaleW(80), autoScaleW(25), autoScaleW(70), autoScaleW(70));
    [self addSubview:_cirHeaderView];
    [_cirHeaderView setContentMode:UIViewContentModeScaleAspectFill];
    float usernameY =  CGRectGetMaxY(self.cirHeaderView.frame);
    if (_username == nil) {
        _username = [[UILabel alloc]init];
    }
    [_username setFrame:CGRectMake(autoScaleW((230-200)/2), usernameY+autoScaleH(5), autoScaleW(200), autoScaleH(22))];
    [_username setTextAlignment:NSTextAlignmentCenter];
    [_username setFont:[UIFont systemFontOfSize:autoScaleW(16)]];
    [_username setTextColor:[UIColor colorWithHexString:@"#5a5a5a"]];
    [self addSubview:_username];
    
    float cirHeaderButtonY =  CGRectGetMaxY(self.username.frame);
    
    if (_cirHeaderButton == nil) {
        _cirHeaderButton = [self cirHeaderButton];
        
        [_cirHeaderButton setFrame:CGRectMake(autoScaleW((230-68)/2), cirHeaderButtonY+5, autoScaleW(68), autoScaleH(18))];
    }
    //判断每次的选中状态
    if (_cirHeaderButton.selected == YES) {
        if ([UserInfo share].mobile == NULL) {
            [_cirHeaderButton setSelected:NO];
            [self setRenzhengStatus:[UserInfo share].auditStatus];
            [_cirHeaderButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_cirHeaderButton setTitle:_HeaderButtonTit forState:UIControlStateNormal];
            [_cirHeaderButton setTitleColor:[UIColor colorWithHexString:@"#9E9E9E"] forState:UIControlStateNormal];
           [self cirHeaderButtonStyel];
            [_cirHeaderButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
        }
    }else{
        [self setRenzhengStatus:[UserInfo share].auditStatus];
        [_cirHeaderButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_cirHeaderButton setTitle:_HeaderButtonTit forState:UIControlStateNormal];
        [_cirHeaderButton setTitleColor:[UIColor colorWithHexString:@"#9E9E9E"] forState:UIControlStateNormal];
        [_cirHeaderButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
    }
    [self setRenzhengStatus:[UserInfo share].auditStatus];
    [self addSubview:_cirHeaderButton];
    
    //绑定数据
    if (![APPUtil isLoginWithJump:NO]) {
//        debugLog(@"未登录");
        _cirHeaderView.image = [UIImage imageNamed:@"img_avatar_logout"];
        _username.text = @"未登录";
        [_username setTextColor:[UIColor colorWithHexString:@"#b3b3b3"]];
        _cirHeaderButton.hidden = YES;
    } else {
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"headImg"];
        if (cachedImage == nil) {
            [_cirHeaderView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].headImgUrl] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
        }else{
            [_cirHeaderView setImage:cachedImage];
        }
        
        [_username setTextColor:[UIColor colorWithHexString:@"#5a5a5a"]];
        if (![APPUtil isBlankString:[UserInfo share].nickName]) {
            [_username setText:[UserInfo share].nickName];
        }else{
            [_username setText:[UserInfo share].mobile];
        }
        
        _cirHeaderButton.hidden = NO;
    }
}

- (UIImageView *)cirHeaderView
{
    if (!_cirHeaderView) {
        _cirHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, autoScaleW(70), autoScaleH(70))];
        _cirHeaderView.layer.masksToBounds = YES;
        [_cirHeaderView setContentMode:UIViewContentModeScaleAspectFit];
        _cirHeaderView.layer.borderWidth = 0.0;
        _cirHeaderView.layer.cornerRadius = _cirHeaderView.frame.size.width * 0.5;
        _cirHeaderView.userInteractionEnabled = YES;
        [_cirHeaderView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
//        [_cirHeaderView setBackgroundColor:[UIColor redColor]];
        
    }
    return _cirHeaderView;
}

- (UIButton *)cirHeaderButton
{
    if (!_cirHeaderButton) {
        _cirHeaderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, autoScaleW(58), autoScaleH(18))];
        _cirHeaderButton.layer.masksToBounds = YES;
        _cirHeaderButton.layer.borderWidth = 1.0;
        
        _cirHeaderButton.layer.cornerRadius = autoScaleH(10);
        _cirHeaderButton.userInteractionEnabled = YES;
        
        [self cirHeaderButtonStyel];
       
    }
    return _cirHeaderButton;
}

-(void)setRenzhengStatus:(NSString *)Status{
    
    if (Status == nil) {
        return;
    }
    if ([Status isEqualToString:@"0"]) {
        return;
    }
    if ([Status isEqualToString:@"1"]) {
        _HeaderButtonTit =@"未完成认证";
    }else if ([Status isEqualToString:@"2"]){
        _HeaderButtonTit =@"人工认证中";
    }else if ([Status isEqualToString:@"3"]){
        _HeaderButtonTit =@"人工认证失败";
    }else if ([Status isEqualToString:@"4"]){
        _HeaderButtonTit =@"已完成认证";
        [_cirHeaderButton setSelected:YES];
    }else if ([Status isEqualToString:@"5"]){
        _HeaderButtonTit =@"待开通";
    }
    else{
      
        _HeaderButtonTit =@"已完成认证";
        [_cirHeaderButton setSelected:YES];
        [_cirHeaderButton setTitleColor:[UIColor colorWithHexString:@"#25D880"] forState:UIControlStateSelected];
        [_cirHeaderButton setBackgroundColor:[UIColor colorWithHexString:@"#EFFFF8"]];
        _cirHeaderButton.layer.borderColor = [UIColor colorWithHexString:@"#25D880"].CGColor;
    }
}

-(void)cirHeaderButtonStyel{
    _cirHeaderButton.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    [_cirHeaderButton setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
}

@end
