//
//  AboutViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/22.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutService.h"
#import "BaseWebController.h"

@interface AboutViewController ()<ObserverServiceDelegate>
{
    UIImageView *iconImgView;
    UILabel *companyLab;
    int count;
}
@property (weak, nonatomic) IBOutlet UIView *userHelp;
@property (weak, nonatomic) IBOutlet UIView *serviceNumber;
@property (weak, nonatomic) IBOutlet UIView *updateVison;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIView *line2View;
@property (weak, nonatomic) IBOutlet UIView *line3View;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usesrHelpTopConstraint;

@property(nonatomic,copy)NSString *webViewUrl;
@property(nonatomic,strong)AboutService *Service;

@end

@implementation AboutViewController
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _usesrHelpTopConstraint.constant = NVBarAndStatusBarHeight+10;
    [self.num setText:_aboutServicePhoneNum];
    _Service =[[AboutService alloc]init];
    _Service.serviceDelegate =self;
    //    [self cellShadow:self.self.serviceNumber];
    //    [self cellShadow:self.updateVison];
    
    //获取app当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [NSString stringWithFormat:@"%@",infoDic[@"CFBundleShortVersionString"]];
    self.versionLab.text = [NSString stringWithFormat:@"V%@",currentVersion];
    
    NSString *server = [CacherUtil getCacherWithKey:kTestServerKey];
    
//    if (KOnline) {
//        self.title =@"关于";
//    } else
    if ([APPUtil isBlankString:server]) {
        self.title =@"关于(测试)";
    } else {
        self.title =@"关于";
    }
    
    _line1View.height = autoScaleH(1);
    _line1View.backgroundColor = UIColorFromRGB(0xF5F5F5);
    _line2View.height = autoScaleH(1);
    _line2View.backgroundColor = UIColorFromRGB(0xF5F5F5);
    _line3View.height = autoScaleH(1);
    _line3View.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-autoScaleW(30), kScreenHeight-autoScaleH(115), autoScaleW(60), autoScaleW(60))];
    iconImgView.image = [UIImage imageNamed:@"img_AboutLogo"];
    [self.view addSubview:iconImgView];
    
    companyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-autoScaleH(37), kScreenWidth, autoScaleH(16))];
    companyLab.text = @"© 宁波轩悦行电动汽车服务有限公司";
    companyLab.textAlignment = NSTextAlignmentCenter;
    companyLab.textColor = UIColorFromRGB(0xB5B5B5);
    companyLab.font = [UIFont systemFontOfSize:autoScaleH(13)];
    [self.view addSubview:companyLab];
    
    [self.serviceNumber addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNumber)]];
    NSDictionary *param = [[NSDictionary alloc]init];
    [_Service requestgetMemberTotalDataWithService:param success:^(id data) {
//        debugLog(@"%@",data);
        _webViewUrl =[data[@"result"] objectForKey:@"url"];
    } fail:^(NSString * error) {
//        debugLog(@"%@",error);
    }];
    
    [self.userHelp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserHelpView)]];

    //显示/隐藏调试功能(测试)
    count = 0;
    UIButton *testBtn = [[UIButton alloc] initWithFrame:_updateVison.frame];
    [testBtn addTarget:self action:@selector(showTestView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

//切换服务器
- (void)showTestView {
    
    if (count<4) {
        count++;
    } else {
        
//        if (KOnline) { return; }
        
        NSString *test = [CacherUtil getCacherWithKey:kTestViewKey];
        
        if ([APPUtil isBlankString:test]) {
            [CacherUtil saveCacher:kTestViewKey withValue:@"测试"];
        }
        
        if ([test isEqualToString:@"测试"]) {
            [CacherUtil saveCacher:kTestViewKey withValue:@""];
        }
        
        exit(0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cellShadow:(UIView*)view{
    CGRect shadowPath = CGRectMake(0, view.height, view.width, 2);
    view.layer.shadowOffset =  CGSizeMake(0, 2); //阴影偏移量
    view.layer.shadowOpacity = 0.9; //透明度
    view.layer.shadowColor = [UIColor colorWithHexString:@"#f5f5f5"].CGColor; //阴影颜色
    view.layer.shadowRadius = 5; //模糊度
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowPath] CGPath];
    [view.layer setMasksToBounds:NO];
}

-(void)onNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_aboutServicePhoneNum];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)pushUserHelpView{
    //        BaseWebController *webVC = [[BaseWebController alloc] init];
    //        webVC.homeUrl = @"https://www.baidu.com/";
    //        webVC.webTitle = @"用户指南";
    ////        webVC.delegate =self;
    [BaseWebController showWithContro:self withUrlStr:_webViewUrl withTitle:@"用户指南" isPresent:YES];
    //        [self.navigationController pushViewController:webVC animated:YES];
}
@end
