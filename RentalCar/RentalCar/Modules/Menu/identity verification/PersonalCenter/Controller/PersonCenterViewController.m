//
//  PersonCenterViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "PersonCenterService.h"
#import "MemberTotalDataModel.h"
#import "CarPopView.h"
#import "XDYHomeService.h"
#import "EditUserInfoViewController.h"

#if TARGET_IPHONE_SIMULATOR //模拟器
#elif TARGET_OS_IPHONE
#import "IdentityIDViewController.h"
#endif


@interface PersonCenterViewController ()<ObserverServiceDelegate>
{
    NSString *rentPsw;
}
@property(nonatomic,strong)PersonCenterService *service;
@property(nonatomic,strong)XDYHomeService *HomeService;
@property(nonatomic,strong)MemberTotalDataModel *totalModel;
@property (weak, nonatomic) IBOutlet UIView *rentalPWD;
@property(nonatomic,copy)NSString *PWD;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touxiangHeight;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property(nonatomic,assign)UInt64 auditStatus;
@property(nonatomic,strong)UIButton *editUserInfo;
@property(nonatomic,strong)UIView *viewline;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginOutHight;
@property(nonatomic,strong)UIView *viewline2;
@property(nonatomic,strong)CarPopView *carPswView;
@end

@implementation PersonCenterViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    self.headView.top = 30;
    self.userName.top = self.headView.bottom+5;
    [self.headView.layer setCornerRadius:self.headView.width *0.5];
    [self.headView.layer setMasksToBounds:YES];

    
    if (_viewline ==nil) {
        _viewline = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3, self.userInfoView.center.y-autoScaleH(21)/2, 1, autoScaleH(21))];
        [_viewline setBackgroundColor:[UIColor colorWithHexString:@"#5EEFCC"]];
        [self.view addSubview:_viewline];
    }
    
    if (_viewline2 == nil) {
        _viewline2= [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth/3)*2, self.userInfoView.center.y-(autoScaleH(21)/2), 1, autoScaleH(21))];
        [_viewline2 setBackgroundColor:[UIColor colorWithHexString:@"#5EEFCC"]];
        [self.view addSubview:_viewline2];
    }
    
    if (_editUserInfo == nil) {
        _editUserInfo =[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-autoScaleW(15)-autoScaleW(70), autoScaleH(25), autoScaleW(70), autoScaleW(40))];
        [_editUserInfo setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_editUserInfo.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_editUserInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_editUserInfo];
        [_editUserInfo addTarget:self action:@selector(editUserInfoClick) forControlEvents:UIControlEventTouchUpInside];
        if (IS_IPhoneX) {
            _editUserInfo.top = 40;
        }
    }
    

    [_loginOut.titleLabel setFont:[UIFont systemFontOfSize:autoScaleH(17)]];
    
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[UserInfo share].auditStatus isEqualToString:@"6"]) {
        self.rentalPWD.hidden = YES;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.rentalPWD.tag = 10000+0;
    self.certifyView.tag = 10000+1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump:)];
    [self.rentalPWD addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump:)];
    [self.certifyView addGestureRecognizer:tap1];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showChange:)];
    [self.rentalPWD addGestureRecognizer:longPress];
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showChange:)];
    [self.certifyView addGestureRecognizer:longPress1];
    
    //执行完拖拽之后再执行轻扫
    [tap requireGestureRecognizerToFail:longPress];
    [tap1 requireGestureRecognizerToFail:longPress1];
    
    
    

    
    if (kScreenWidth <= 320) {
        self.touxiangHeight.constant =75;
        self.loginOutHight.constant = autoScaleH(48);
    }
    [self setupWhiteBackBut:self.view];

    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    //获取用户信息
    [self.time setFont:kAvantiBoldSize(15)];
    [self.kilometre setFont:kAvantiBoldSize(15)];
    [self.kilogram setFont:kAvantiBoldSize(15)];

    [self postPersonInfoData];
   
}

#pragma mark -  请求数据
- (void)postPersonInfoData{
    if (self.service == nil) {
        self.service =[[PersonCenterService alloc]init];
        self.service.serviceDelegate = self;
    }
    
    if (self.HomeService ==nil) {
        self.HomeService =[[XDYHomeService alloc]init];
        self.HomeService.serviceDelegate = self;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *token =[UserInfo share].token;
    [param setObject:token forKey:@"token"];

    [self.service requestgetMemberTotalDataWithService:param success:^(id data) {
        //        debugLog(@"%@",data);
        _totalModel = [MemberTotalDataModel yy_modelWithJSON:[data objectForKey:@"result"]];
        //添加单位换算
        [self.time setText:[self totalVule:_totalModel.totalMinutes]];
        [self.kilometre setText:[self totalVule:_totalModel.totalMileage]];
        [self.kilogram setText:[self totalVule:_totalModel.totalCarbon]];
        
    } fail:^(NSString * error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //刷新用户数据
    [self.HomeService requestUserAuthState];
    _auditStatus = [[UserInfo share].auditStatus intValue];
    [self setRenzhengStatus:[NSString stringWithFormat:@"%llu",_auditStatus]];
    //隐藏系统导航条
    self.navBar.hidden = YES;
    //隐藏系统导航条
    [self.navigationController setNavigationBarHidden:YES];

    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"headImg"];
    if (cachedImage == nil) {
        [_headView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].headImgUrl] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
    }else{
        [_headView setImage:cachedImage];
    }
//    debugLog(@"%@",[UserInfo share].nickName);
    
    if ([[UserInfo share].nickName isEqualToString:@""]) {
        NSString * mobileNum = [UserInfo share].mobile;
//        debugLog(@"%@",[UserInfo share].mobile);
        [self.userName setText:mobileNum];
    }else{
        [self.userName setText:[UserInfo share].nickName];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //隐藏系统导航条
    
}

//实名与驾照认证
-(void)pushVerView{
//    debugLog(@"点击跳转");
    if (_auditStatus ==1 || _auditStatus ==2 || _auditStatus ==3) {
        
#if TARGET_IPHONE_SIMULATOR //模拟器
#elif TARGET_OS_IPHONE
        IdentityIDViewController *myVC = [[IdentityIDViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
#endif
    }else{
        [TipUtil showSuccTip:@"已完成身份认证"];
    }
    
}

-(void)loginOutLogin:(UIButton *)button{
    button.layer.borderColor =[UIColor colorWithHexString:@"EEEEEE"].CGColor;
    button.backgroundColor = [UIColor colorWithHexString:@"#FCFCFC"];
    [button.layer setMasksToBounds:NO];
    XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:@"您确定要退出小灵狗吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确认退出" TopButtonTitle:@"提示"];
    alert.doneBlock = ^()
    {
        
        //退出登录
        NSDictionary *paramDic = [NSDictionary dictionary];
        
        [[CommonRequest shareRequest] requestWithPost:getLogoutUrl() isCovered:YES parameters:paramDic success:^(id data) {
            
            [APPUtil logout:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *code) {
            
        }];
    };
}


#pragma mark 查看租车密码
-(void)rentalPWDClick{
    //获取车机密码
    rentPsw = [[NSUserDefaults standardUserDefaults]objectForKey:kRentPswKey];;
    if ([APPUtil isBlankString:rentPsw]) {
        rentPsw = @"";
    }
    if ([APPUtil isBlankString:rentPsw]) {
        if (self.PWD == nil) {
            [self.HomeService requestGetRentPwdService];
        }
    }else{
        [self showRentPswView];
    }
}

-(void)setRenzhengStatus:(NSString *)Status{
    if ([Status isEqualToString:@"0"]) {
        return;
    }
    if ([Status isEqualToString:@"1"]) {
        [self.renzhengLable setText:@"未完成认证"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#B5B5B5"]];
    }else if ([Status isEqualToString:@"2"]){
        [self.renzhengLable setText:@"人工认证中"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#B5B5B5"]];
    }else if ([Status isEqualToString:@"3"]){
        [self.renzhengLable setText:@"人工认证失败"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#ff4c4c"]];
    }else if ([Status isEqualToString:@"4"]){
        [self.renzhengLable setText:@"已完成认证"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#B5B5B5"]];
    }else if ([Status isEqualToString:@"5"]){
        [self.renzhengLable setText:@"待开通"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#B5B5B5"]];
    }else if(Status == NULL){
        [self.renzhengLable setText:@"未登录"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#B5B5B5"]];
        
    }else{
        [self.renzhengLable setText:@"已完成认证"];
        [self.renzhengLable setTextColor:[UIColor colorFromHexCode:@"#B5B5B5"]];
    }
}

-(void)onSuccess:(id)data withType:(ActionType)type{
    switch (type) {
        case _REQUEST_GetRentPwd_:
        {
            rentPsw = data;
            [self showRentPswView];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)showRentPswView{
    //车机密码弹框
    _carPswView = [[CarPopView alloc] initWithImageName:@"img_password" contentText:[NSString stringWithFormat:@"租车密码 %@",rentPsw] descText:@"请在驾驶D1车型前，于车内中控屏前输入您的专属6位密码以解锁车辆" range:NSMakeRange(0, 0) leftButtonTitle:@"" rightButtonTitle:@"我知道了"];
    
    [self.view addSubview:_carPswView];
    
    __weak CarPopView *popSelf = _carPswView;
    _carPswView.confirmBlock = ^(){ //我知道了
        
        [popSelf closeAction];
    };
}


-(void)editUserInfoClick{
    EditUserInfoViewController *editUserInfo =[[EditUserInfoViewController alloc]init];
    [self.navigationController pushViewController:editUserInfo animated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //白色
    return UIStatusBarStyleLightContent;
}
//单位转换
-(NSString *)totalVule:(NSString *)Vule{
    float newValue;
    if ([Vule integerValue] >9999) {
       newValue = [Vule floatValue]/10000;
        NSString *newString = [NSString stringWithFormat:@"%@w",[APPUtil multiplyingBy:@(newValue) and:@"1"]];
        return newString;
    }else{
        return [APPUtil multiplyingBy:Vule and:@"1"];
    }
}

//解决设置阴影方法之间冲突问题
-(void)setLoginOut:(UIButton *)loginOut{
    
    [loginOut addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [loginOut addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpOutside];
    [loginOut addTarget:self action:@selector(loginOutLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    loginOut.backgroundColor =[UIColor colorWithHexString:@"#FCFCFC"];
    loginOut.layer.borderColor = [UIColor colorWithHexString:@"#E7EDEA"].CGColor;
    loginOut.layer.cornerRadius = autoScaleH(5);
    [loginOut.layer setBorderWidth:1];
    
}

-(void)downClick:(UIButton *)button{
    button.layer.borderColor =[UIColor colorWithHexString:@"EEEEEE"].CGColor;
    button.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [button.layer setMasksToBounds:YES];
    
}

-(void)doneClick:(UIButton *)button{
    button.layer.borderColor =[UIColor colorWithHexString:@"EEEEEE"].CGColor;
    button.backgroundColor = [UIColor colorWithHexString:@"#FCFCFC"];
    [button.layer setMasksToBounds:NO];
}

#pragma mark - 点击事件
- (void)jump:(UITapGestureRecognizer *)tap {
    UIView *clickView = (UIView *)tap.view;
    clickView.backgroundColor = UIColorFromRGB(0xFBFBFB);
    switch (tap.state) {
        case UIGestureRecognizerStateEnded:
            [self performSelector:@selector(revertChange) withObject:nil afterDelay:0.0f];
            break;
            
        default:
            break;
    }
    
    int index = (int)clickView.tag - 10000;
    if (index==0) {
        [self rentalPWDClick];
    }
    if (index==1) {
        [self pushVerView];
    }
}

#pragma mark - 恢复背景改变
- (void)revertChange {
    for (int i = 0; i<2; i++) {
        UIView *clickView = [self.view viewWithTag:10000+i];
        clickView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - 长按手势，让背景改变
- (void)showChange:(UILongPressGestureRecognizer *)longPress {
    UIView *clickView = (UIView *)longPress.view;
    clickView.backgroundColor = UIColorFromRGB(0xFBFBFB);
    switch (longPress.state) {
        case UIGestureRecognizerStateEnded:
            clickView.backgroundColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

@end
