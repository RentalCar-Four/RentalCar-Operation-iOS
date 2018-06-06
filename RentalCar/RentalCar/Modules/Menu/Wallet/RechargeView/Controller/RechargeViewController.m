//
//  RechargeViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/18.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeService.h"
#import "AlipayHeader.h"
#import "WXApi.h"
#import "waletModel.h"

@interface RechargeViewController ()<ObserverServiceDelegate>
@property (weak, nonatomic) IBOutlet UIView *butArrView;
@property (weak, nonatomic) IBOutlet UIButton *RechargeBut;
@property (weak, nonatomic) IBOutlet UIView *wechatPay;
@property (weak, nonatomic) IBOutlet UIView *alipay;
@property (weak, nonatomic) IBOutlet UIImageView *wechatpayIcon;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIcon;
@property(nonatomic,strong)RechargeService *service;
@property(nonatomic,strong)walletService *service1;
@property (weak, nonatomic) IBOutlet UILabel *nowYueLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nowYueTop;
@property(nonatomic,assign)NSInteger money;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nowYueHeight;
@property(nonatomic,strong)waletModel *qianModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLayout;
@end

@implementation RechargeViewController
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [[APPUtil share]setButtonClickStyle:self.RechargeBut Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"充值";
    _money =50;
    _topSpaceLayout.constant = NVBarAndStatusBarHeight+15;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceedAction:) name:@"paySucceedNOtifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayMsg:) name:@"WXPaySucceedNOtifi" object:nil];
    self.service =[[RechargeService alloc]init];
    self.service.serviceDelegate = self;
    self.nowYueHeight.constant =autoScaleH(56);
    self.nowYueTop.constant =autoScaleH(20);
    [self.nowYueLable setFont:kAvantiBoldSize(autoScaleH(25))];
    [self.nowYueLable setText:self.nowYue];
    
     NSDictionary *param = [[NSDictionary alloc]init];
    self.service1 =[[walletService alloc]init];
    self.service1.serviceDelegate = self;
    [self.service1 requestgetMemberAccountWithService:param success:^(id data) {
        
        
       
        
    } fail:^(NSString *error) {
        
    }];
    
    NSArray *butArr =  [self.butArrView subviews];
    
    for (int i = 0; i<butArr.count; i++) {
        UIButton *tempBut = butArr[i];
        [self setButtonStyle:tempBut];
        
    }
    if (kScreenWidth <=320) {
        self.buttonWidth.constant =90;
        self.buttonWidth2.constant =90;
        self.buttonWidth3.constant =90;
        self.buttonWidth4.constant =90;
        self.buttonWidth5.constant =90;
        self.buttonWidth6.constant =90;
   
    }
 
    [self.RechargeBut addTarget:self action:@selector(userPay:) forControlEvents:UIControlEventTouchUpInside];
    
    
     [self.wechatPay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PayList:)]];
    
   
    self.wechatPay.tag =1;
    [self.alipay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PayList:)]];
   
  
  
    
}

-(void)onSuccess:(id)data withType:(ActionType)type{
    switch (type) {
        case _REQUEST_MemberAccount_:
        {
            _qianModel = [waletModel yy_modelWithJSON:[data objectForKey:@"result"]];
            [self.nowYueLable setText:_qianModel.amount];
           
        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setButtonStyle:(UIButton *)button{
    
    [button.layer setCornerRadius:5];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[UIColor colorWithHexString:@"#F0F0F0"].CGColor];
    [button.layer setMasksToBounds:YES];
    [button setBackgroundImage:[UIColor imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHexString:@"#25D880"]] forState:UIControlStateSelected];
    if ([button.titleLabel.text isEqualToString:@"50 元"]) {
        [button setAttributedTitle:[self changeLabelColorOriginalString:button.titleLabel.text changeString1:@"50" changeString2:@"元"] forState:UIControlStateNormal];
        
        [button setAttributedTitle:[self SelectedChangeLabelColorOriginalString:button.titleLabel.text changeString1:@"50" changeString2:@"元"] forState:UIControlStateSelected];
    }else if ([button.titleLabel.text isEqualToString:@"100 元"]){
        [button setAttributedTitle:[self changeLabelColorOriginalString:button.titleLabel.text changeString1:@"100" changeString2:@"元"] forState:UIControlStateNormal];
        
        
        [button setAttributedTitle:[self SelectedChangeLabelColorOriginalString:button.titleLabel.text changeString1:@"100" changeString2:@"元"] forState:UIControlStateSelected];
        
    }else if ([button.titleLabel.text isEqualToString:@"300 元"]){
        [button setAttributedTitle:[self changeLabelColorOriginalString:button.titleLabel.text changeString1:@"300" changeString2:@"元"] forState:UIControlStateNormal];
        
        [button setAttributedTitle:[self SelectedChangeLabelColorOriginalString:button.titleLabel.text changeString1:@"300" changeString2:@"元"] forState:UIControlStateSelected];
    }else if ([button.titleLabel.text isEqualToString:@"500 元"]){
       [button setAttributedTitle:[self changeLabelColorOriginalString:button.titleLabel.text changeString1:@"500" changeString2:@"元"] forState:UIControlStateNormal];
        
        [button setAttributedTitle:[self SelectedChangeLabelColorOriginalString:button.titleLabel.text changeString1:@"500" changeString2:@"元"] forState:UIControlStateSelected];
    }else if ([button.titleLabel.text isEqualToString:@"1000 元"]){
        [button setAttributedTitle:[self changeLabelColorOriginalString:button.titleLabel.text changeString1:@"1000" changeString2:@"元"] forState:UIControlStateNormal];
        
        
        [button setAttributedTitle:[self SelectedChangeLabelColorOriginalString:button.titleLabel.text changeString1:@"1000" changeString2:@"元"] forState:UIControlStateSelected];
    }else{
        [button setAttributedTitle:[self changeLabelColorOriginalString:button.titleLabel.text changeString1:@"1500" changeString2:@"元"] forState:UIControlStateNormal];
        
        
        [button setAttributedTitle:[self SelectedChangeLabelColorOriginalString:button.titleLabel.text changeString1:@"1500" changeString2:@"元"] forState:UIControlStateSelected];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(ClickMoney:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)ClickMoney:(UIButton *)sender{

   NSArray *butArr =  [self.butArrView subviews];
    
    for (int i = 0; i<butArr.count; i++) {
        UIButton *tempBut = butArr[i];
        [tempBut setSelected:NO];
        [tempBut.layer setBorderWidth:1];
       
        
    }
    [sender setSelected:YES];
    switch (sender.tag) {
        case 50:
        {
            
            _money =sender.tag;
            
            [sender.layer setBorderWidth:0];
        }
            break;
        case 100:
        {
            _money =sender.tag;
            
            [sender.layer setBorderWidth:0];
        }
            break;
        case 300:
        {
            _money =sender.tag;
            
            [sender.layer setBorderWidth:0];
        }
            break;
        case 500:
        {
            _money =sender.tag;
            
            [sender.layer setBorderWidth:0];
        }
            break;
            
        case 1000:
        {
            _money =sender.tag;
            
            [sender.layer setBorderWidth:0];
        }
            break;
            
        case 1500:
        {
            _money =sender.tag;
            [sender.layer setBorderWidth:0];
        }
            break;
            
        default:
            break;
    }
}


-(void)PayList:(UITapGestureRecognizer *)recognizer{
//    debugLog(@"%ld",recognizer.view.tag);
    
    if (recognizer.view.tag == 1) {
        [self.wechatpayIcon setImage:[UIImage imageNamed:@"icon_AgreeSelect"]];
        [self.alipayIcon setImage:[UIImage imageNamed:@"icon_Agree"]];
        self.RechargeBut.tag =100;
    }else{
        [self.wechatpayIcon setImage:[UIImage imageNamed:@"icon_Agree"]];
        [self.alipayIcon setImage:[UIImage imageNamed:@"icon_AgreeSelect"]];
        self.RechargeBut.tag = 200;
    }
}

-(void)userPay:(UIButton *)button{
    self.RechargeBut.backgroundColor = kBlueColor;
    [self.RechargeBut.layer setMasksToBounds:NO];
//    debugLog(@"%ld",(long)button.tag);
//    debugLog(@"点击支付")
    if (button.tag == 200) {
        //支付宝支付
        [self userAlipay];
        [StatisticsClass eventId:QB05];
    }else{
        [StatisticsClass eventId:QB06];
        [self weixiPay];
    }
}


- (void)userAlipay
{
    // 判断后台异步URL数据是否请求到
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
#warning 支付宝测试支付
//    [param setObject:@"0.1" forKey:@"totalFee"];//金额(元)
    [param setObject:[NSString stringWithFormat:@"%ld",(long)_money] forKey:@"totalFee"];//金额(元)
    [param setObject:@"1" forKey:@"type"];//充值类型（1：充值 5：套餐  7：交保证金）
    NSString *token =[UserInfo share].token;
    [param setObject:token forKey:@"token"];
   
    [self.service requestRechargeAlipayWithService:param success:^(id result) {
//        debugLog(@"%@",result);
        NSString *payInfo = result[@"result"][@"payInfo"];
        [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"XDYLease3" callback:^(NSDictionary *resultDic) {
//            debugLog(@"%@",resultDic);
        }];
    } fail:^(NSString * fail) {
//        debugLog(@"%@",fail);
    }];
    
}


- (void)weixiPay
{
    if (![APPUtil isInstallWinXinApp]) {
        return ;
    }
    // 判断后台异步URL数据是否请求到
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setObject:@"0.1" forKey:@"totalFee"];//金额(元)
    [param setObject:[NSString stringWithFormat:@"%ld",(long)_money] forKey:@"totalFee"];//金额(元)
    [param setObject:@"1" forKey:@"type"];//充值类型（1：充值 5：套餐  7：交保证金）
    NSString *token =[UserInfo share].token;
    [param setObject:token forKey:@"token"];
    
    [self.service requestRechargeWXpayWithService:param success:^(id result) {
//        debugLog(@"%@",result);
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = result[@"result"][@"partnerid"];
        request.prepayId = result[@"result"][@"prepayid"];
        request.package = result[@"result"][@"packageValue"];
        request.nonceStr = result[@"result"][@"noncestr"];
        request.timeStamp = [(result[@"result"][@"timestamp"]) intValue];
        request.sign = result[@"result"][@"sign"];
        [WXApi sendReq:request];
//        debugLog(@"%d",[WXApi sendReq:request]);
    } fail:^(NSString * fail) {
//        debugLog(@"%@",fail);
    }];
}

- (void)paySucceedAction:(NSNotification *)nfi
{
    NSDictionary *userInfo = nfi.userInfo;
    
    if ([userInfo[@"resultStatus"] intValue]==9000) {
        [CustomAlertView alertWithMessage:@"支付成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [CustomAlertView alertWithMessage:@"支付失败"];
    }
    
}

-(void)WXPayMsg:(NSNotification *)nfi{
    NSString *userInfo = nfi.object;
//    debugLog(@"%@",userInfo);
    [self.navigationController popViewControllerAnimated:YES];
    [CustomAlertView alertWithMessage:userInfo];
}



//按钮富文本默认样式
- (NSMutableAttributedString *)changeLabelColorOriginalString:(NSString *)originalString changeString1:(NSString *)changeString1 changeString2:(NSString *)changeString2{
    NSRange changeStringRange1 = [originalString rangeOfString:changeString1];
    NSRange changeStringRange2 = [originalString rangeOfString:changeString2];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
   
            [attributedString addAttribute:NSFontAttributeName value:kAvantiBoldSize(autoScaleH(3)) range:changeStringRange1];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#747474"] range:changeStringRange1];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:autoScaleH(12) weight:1] range:changeStringRange2];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#747474"] range:changeStringRange2];
            return attributedString;
  
    return attributedString;
    
}


- (NSMutableAttributedString *)SelectedChangeLabelColorOriginalString:(NSString *)originalString changeString1:(NSString *)changeString1 changeString2:(NSString *)changeString2{
    NSRange changeStringRange1 = [originalString rangeOfString:changeString1];
    NSRange changeStringRange2 = [originalString rangeOfString:changeString2];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    
    [attributedString addAttribute:NSFontAttributeName value:kAvantiBoldSize(autoScaleH(3)) range:changeStringRange1];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFFFFF"] range:changeStringRange1];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:autoScaleH(12) weight:1] range:changeStringRange2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFFFFF"] range:changeStringRange2];
    return attributedString;
    
    return attributedString;
    
}



@end
