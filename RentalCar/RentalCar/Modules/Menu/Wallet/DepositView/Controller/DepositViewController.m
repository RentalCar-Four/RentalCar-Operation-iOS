//
//  DepositViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/18.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "DepositViewController.h"
#import "RechargeService.h"
#import "AlipayHeader.h"
#import "WXApi.h"
#import "XDYPickerView.h"

@interface DepositViewController ()<ObserverServiceDelegate>
{
    XDYPickerView *areaListPickview;
    NSArray *arealistArr;
    NSString *areaId;
    NSString *depositStr;
}
@property (weak, nonatomic) IBOutlet UIButton *DepositBut;
@property (weak, nonatomic) IBOutlet UIView *wechatPay;
@property (weak, nonatomic) IBOutlet UIView *alipay;
@property (weak, nonatomic) IBOutlet UIImageView *wechatpayIcon;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIcon;
@property (weak, nonatomic) IBOutlet UILabel *yajinLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLyout;
@property (weak, nonatomic) IBOutlet UIButton *selectAreaBtn;
@property(nonatomic,strong)RechargeService *service;



- (IBAction)selectAreaAction:(UIButton *)sender;
@end

@implementation DepositViewController
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [[APPUtil share] setButtonClickStyle:self.DepositBut normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    
    [[APPUtil share]setButtonClickStyle:self.DepositBut Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
    debugLog(@"%@",[UserInfo share].depositToPay);
    [self.yajinLable setText:depositStr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 支付宝支付成功
    self.title =@"用车押金";
    _topSpaceLyout.constant = NVBarAndStatusBarHeight+15;
    [self.yajinLable setFont:kAvantiBoldSize(autoScaleH(35))];
   
    
    
    self.service =[[RechargeService alloc]init];
    self.service.serviceDelegate = self;
    
    [self.wechatPay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PayList:)]];
    
    
    self.wechatPay.tag =1;
    [self.alipay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PayList:)]];
    
    [self.DepositBut addTarget:self action:@selector(userPay:) forControlEvents:UIControlEventTouchUpInside];
    
    areaId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAreaID];
    NSString *areaName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAreaName];
    if ([APPUtil isBlankString:areaId]) {
        areaId = @"";
    }else{
        [_selectAreaBtn setTitle:areaName forState:0];
    }
    
    [self getAreaListData];
    
    depositStr =  [UserInfo share].depositToPay;;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceedAction:) name:@"paySucceedNOtifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayMsg:) name:@"WXPaySucceedNOtifi" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doneVule:) name:@"needAreaValue" object:nil];
    
}

//获取区域数据
- (void)getAreaListData{
    [[CommonRequest shareRequest] requestWithGet:getAreaListUrl() parameters:nil success:^(id data) {
        
       
        NSDictionary *result = [data objectForKey:@"result"];
       
        arealistArr = [result objectForKey:@"list"];
        
        
    } failure:^(NSString *code) {
        
//        [self onFailMessageWithType:_REQUEST_LOGIN_];
        
    }];
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

-(void)PayList:(UITapGestureRecognizer *)recognizer{
//    debugLog(@"%ld",recognizer.view.tag);
    
    if (recognizer.view.tag == 1) {
        [self.wechatpayIcon setImage:[UIImage imageNamed:@"icon_AgreeSelect"]];
        [self.alipayIcon setImage:[UIImage imageNamed:@"icon_Agree"]];
        self.DepositBut.tag =100;
    }else{
        [self.wechatpayIcon setImage:[UIImage imageNamed:@"icon_Agree"]];
        [self.alipayIcon setImage:[UIImage imageNamed:@"icon_AgreeSelect"]];
        self.DepositBut.tag = 200;
    }
    
    
    
}

-(void)userPay:(UIButton *)button{
    if ([depositStr floatValue]==0) {
        [APPUtil showToast:@"押金不能为0"];
        return;
    }
    if (button.tag == 200) {
        //支付宝支付
        [StatisticsClass eventId:QB05];
        [self userAlipay];
    }else{
        [StatisticsClass eventId:QB06];
        [self weixiPay];
        
    }

}

- (void)userAlipay
{
    // 判断后台异步URL数据是否请求到
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *userDepositToPay =  [UserInfo share].depositToPay;
    [param setObject:depositStr forKey:@"totalFee"];//金额(元)
//    [param setObject:@"0.1" forKey:@"totalFee"];//金额(元)
    [param setObject:depositStr forKey:@"deposit"];//充值押金(元)
    [param setObject:@"0" forKey:@"useFee"];//账户余额
    [param setObject:@"7" forKey:@"type"];//充值类型（1：充值 5：套餐  7：交保证金）
    NSString *token =[UserInfo share].token;
    [param setObject:token forKey:@"token"];
     [param setObject:areaId forKey:@"areaId"];//设置区域id
    
    [self.service requestRechargeAlipayWithService:param success:^(id result) {
        debugLog(@"%@",result);
        NSString *payInfo = result[@"result"][@"payInfo"];
        [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"XDYLease3" callback:^(NSDictionary *resultDic) {
            
//            debugLog(@"%@",resultDic);
            
        }];
    } fail:^(NSString * fail) {
//        debugLog(@"%@",fail);
    }];
     
}


- (void)paySucceedAction:(NSNotification *)nfi
{
    NSDictionary *userInfo = nfi.userInfo;
    
    if ([userInfo[@"resultStatus"] intValue]==9000) {
        
        [CustomAlertView alertWithMessage:@"支付成功"];
       [[NSNotificationCenter defaultCenter]postNotificationName:kPostUserInfoNotification object:nil];;
    } else {
         [CustomAlertView alertWithMessage:@"支付失败"];
    }
     [self.navigationController popViewControllerAnimated:YES];
    //[self _loadUserData];
    
    //    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [errorView show];
}
- (void)weixiPay
{
    if (![APPUtil isInstallWinXinApp]) {
        return ;
    }
    // 判断后台异步URL数据是否请求到
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *userDepositToPay =  [UserInfo share].depositToPay;
    [param setObject:depositStr forKey:@"totalFee"];//金额(元)
    [param setObject:depositStr forKey:@"deposit"];//充值押金(元)
    [param setObject:@"0" forKey:@"useFee"];//账户余额
    [param setObject:@"7" forKey:@"type"];//充值类型（1：充值 5：套餐  7：交保证金）
    [param setObject:areaId forKey:@"areaId"]; //设置区域id
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

-(void)WXPayMsg:(NSNotification *)nfi{
    NSString *userInfo = nfi.object;
   [[NSNotificationCenter defaultCenter]postNotificationName:kPostUserInfoNotification object:nil];;
    [self.navigationController popViewControllerAnimated:YES];
     [CustomAlertView alertWithMessage:userInfo];
}

- (IBAction)selectAreaAction:(UIButton *)sender {
    //        debugLog(@"%@",data);
    if (arealistArr.count==0) {
        [CustomAlertView alertWithMessage:@"请稍后重试"];
        return;
    }
    areaListPickview = [XDYPickerView pickerView];
    areaListPickview.array = arealistArr;
    [self.view addSubview:areaListPickview];
    [areaListPickview show];
    
}

-(void)doneVule:(NSNotification *)sender{
    //    debugLog(@"%@",sender.object);
    if (sender.object) {
        NSString *titleName = [sender.object objectForKey:@"areaName"];
        //    [self.areaBut setTitle:titleName forState:UIControlStateNormal];
        areaId = [sender.object objectForKey:@"areaId"];
        
        depositStr = [NSString stringWithFormat:@"%@",[APPUtil multiplyingBy:[sender.object objectForKey:@"deposit"] and:@"1"]];
        [self.yajinLable setText:depositStr];
        [_selectAreaBtn setTitle:titleName forState:0];
    }
    
}


@end
