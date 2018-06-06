//
//  PickerView.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/7.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "PickerView.h"

@interface PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *doneBtn;

@property (nonatomic,strong) NSString *value;

@end

@implementation PickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    //弹出视图
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, kScreenWidth, autoScaleH(280))];
    [self.topView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.topView];
    
    //城市展示
    self.pickerView = [[UIPickerView alloc] init];
    [self.pickerView setFrame:CGRectMake(0, 0, kScreenWidth, autoScaleH(280-58))];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.topView addSubview:self.pickerView];
    
    //确定
    self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(10), self.pickerView.bottom, kScreenWidth-autoScaleW(20), autoScaleW(48))];
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneBtn.backgroundColor = UIColorFromRGB(0x25D880);
    [self.doneBtn.layer setCornerRadius:5];
    [APPUtil setViewShadowStyle:self.doneBtn];
    [self.doneBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneBtn];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self quit];
}

//快速创建
+ (instancetype)pickerView {
    
    return [[self alloc]init];
}

//弹出
- (void)show {
    
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    
    [view addSubview:self];
    
    // 浮现
    [UIView animateWithDuration:0.3 animations:^{
        
        self.topView.frame = CGRectMake(0, self.height- autoScaleH(280), kScreenWidth, autoScaleH(280));
    } completion:^(BOOL finished) {
        
    }];
}

-(void)quit
{
    if ([APPUtil isBlankString:_value]) {
        _value = [self.array[0] objectForKey:@"prefix"];
    }
    !self.doneBlock ? : self.doneBlock(_value);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.topView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerView 代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return autoScaleH(30);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.array.count;
}

// 返回第component列第row行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *name=[self.array[row] objectForKey:@"prefix"];
    
    return name;
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _value = [self.array[row] objectForKey:@"prefix"];
}

@end
