//
//  CircleView.m
//  RentalCar
//
//  Created by Hulk on 2017/3/13.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CircleView.h"


@interface CircleView ()



@end

@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
  
    
    
    
}
-(void)layoutSubviews{
    [self setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"]];
    NSArray *arrTit = [NSArray arrayWithObjects:@"身份证验证",@"驾照认证",@"面部识别", nil];
    
    for (int i =0; i<3; i++) {
        
        _circlebackLine = [[UIButton alloc]init];
        _circlebackLine = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/3, autoScaleH(32))];
        _circlebackLine.tag =i+1;
        [_circlebackLine setTitle:arrTit[i] forState:UIControlStateNormal];
        [_circlebackLine setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
        [_circlebackLine setTitleColor:[UIColor colorWithHexString:@"#C2C2C2"] forState:UIControlStateNormal];
        [_circlebackLine setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHexString:@"#25D880"]] forState:UIControlStateSelected];
        [_circlebackLine setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHexString:@"#F1F1F1" alpha:1]] forState:UIControlStateNormal];
        _circlebackLine.layer.masksToBounds = YES;
        
        [_circlebackLine.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_circlebackLine.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_circlebackLine];
        
        //引导进度
        _circleHead = [[UIButton alloc]init];
        _circleHead.tag =i+1;
        _circleHead = [[UIButton alloc]initWithFrame:CGRectMake(0, autoScaleW(50)/2-autoScaleW(40)/2, autoScaleW(40), autoScaleH(40))];
        NSString *titleName = [NSString stringWithFormat:@"%d",i+1];
        [_circleHead setTitle:titleName forState:UIControlStateNormal];
        
        [_circleHead.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_circleHead setTitleColor:[UIColor colorWithHexString:@"#BBBBBB"] forState:UIControlStateNormal];
        [_circleHead setTitleColor:[UIColor colorWithHexString:@"#25D880"] forState:UIControlStateSelected];
        [_circleHead setBackgroundImage:[UIImage imageNamed:@"icon_AgreeSelect"]  forState:UIControlStateHighlighted];
        [_circleHead setTitle:@"" forState:UIControlStateHighlighted];
        _circleHead.layer.masksToBounds = YES;
        _circleHead.layer.borderWidth = 0;
        //        _cirHeaderView.layer.borderColor = [UIColor]
        _circleHead.layer.cornerRadius = _circleHead.frame.size.width * 0.5;
        _circleHead.userInteractionEnabled = YES;
        [_circleHead setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_circleHead];
        //重新计算背景的坐标
        
        [_circlebackLine setFrame:CGRectMake(8+_circleHead.width/2+(i*_circlebackLine.width), (_circleHead.origin.y+5+autoScaleH(40))/2-autoScaleH(32)/2, (kScreenWidth-30)/3, autoScaleH(32))];
        
        [_circleHead setFrame:CGRectMake((5+i*_circlebackLine.width), autoScaleW(50)/2-autoScaleW(40)/2, autoScaleW(40), autoScaleH(40))];
        //判断当前选中状态
        if (_circlebackLine.tag == 1) {
            if (_tagS== 1) {
//                debugLog(@"%d",self.tagS);
                _circleHead.selected =YES;
                _circlebackLine.selected =YES;
                
            }
            
            if (_tagH == 1) {
                _circleHead.selected =NO;
                _circleHead.highlighted =YES;
                _circlebackLine.selected =NO;
            }
            
            if (_tagH == 2) {
                _circleHead.highlighted =YES;
            }
            
            if (_tagH == 3) {
                _circleHead.selected =NO;
                _circleHead.highlighted =YES;
                _circlebackLine.selected =NO;
            }
        }
        
        
        if (_circlebackLine.tag == 2) {
            if (_tagS== 2) {
//                debugLog(@"%d",self.tagS);
                _circleHead.selected =YES;
                _circlebackLine.selected =YES;
                
            }
            
            if (_tagH == 2) {
                _circleHead.selected =NO;
                _circleHead.highlighted =YES;
                _circlebackLine.selected =NO;
            }
            
            if (_tagH == 3) {
                _circleHead.selected =NO;
                _circleHead.highlighted =YES;
                _circlebackLine.selected =NO;
            }
        }
        
        if (_circlebackLine.tag == 3) {
            if (_tagS== 3) {
//                debugLog(@"%d",self.tagS);
                _circleHead.selected =YES;
                _circlebackLine.selected =YES;
                
            }
            
            if (_tagH == 3) {
                _circleHead.selected =NO;
                _circleHead.highlighted =YES;
                _circlebackLine.selected =NO;
            }
        }
        
       
        
        if (_circlebackLine.tag == 2) {
            [_circleHead setFrame:CGRectMake((12+i*_circlebackLine.width), autoScaleW(50)/2-autoScaleW(40)/2, autoScaleW(40), autoScaleH(40))];
        }
        
        if (_circlebackLine.tag == 3) {
            [_circlebackLine setFrame:CGRectMake(5+_circleHead.width/2+(i*_circlebackLine.width), (_circleHead.origin.y+5+autoScaleH(40))/2-autoScaleH(32)/2, (kScreenWidth-30)/3-12, autoScaleH(32))];
            [_circlebackLine.layer setCornerRadius:13.0];
            _circlebackLine.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        
        _circleHead.userInteractionEnabled = NO;
        _circlebackLine.userInteractionEnabled = NO;
        
    }
    
    
    
}
@end
