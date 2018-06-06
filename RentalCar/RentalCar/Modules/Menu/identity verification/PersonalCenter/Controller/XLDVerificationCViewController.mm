//
//  XLDVerificationCViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/9.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XLDVerificationCViewController.h"
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "MyViewController.h"
#import "LiveViewController.h"
#import "IdentityIDViewController.h"
#import "BaseNavController.h"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST
#else
#import <MGBaseKit/MGBaseKit.h>
#import <MGIDCard/MGIDCard.h>
#endif



@interface XLDVerificationCViewController ()
@property (strong, nonatomic)  UIButton *cardView;
@property (strong, nonatomic)  UILabel *versionView;
@end

@implementation XLDVerificationCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST
#else
    self.versionView.text = [MGIDCardManager IDCardVersion];
#endif
    _cardView = [[UIButton alloc]init];
    [_cardView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*(4/3))];
    [_cardView setBackgroundColor:[UIColor redColor]];
    [_cardView addTarget:self action:@selector(CheckIDCard:) forControlEvents:UIControlEventTouchUpInside];
    [_cardView setTitle:@"跳转个人主页" forState:UIControlStateNormal];
    [self.view addSubview:_cardView];
    
    
    UIButton *live = [[UIButton alloc]init];
    [live setFrame:CGRectMake(0, kScreenWidth*(4/3), kScreenWidth/2, kScreenWidth*(4/3))];
    [live setBackgroundColor:[UIColor greenColor]];
    [live addTarget:self action:@selector(Checklive:) forControlEvents:UIControlEventTouchUpInside];
    [live setTitle:@"人脸识别自定义" forState:UIControlStateNormal];
    [self.view addSubview:live];
    
    
    
    UIButton *live1 = [[UIButton alloc]init];
    [live1 setFrame:CGRectMake(kScreenWidth/2, kScreenWidth*(4/3), kScreenWidth/2, kScreenWidth*(4/3))];
    [live1 setBackgroundColor:[UIColor blueColor]];
    [live1 addTarget:self action:@selector(Checklive1:) forControlEvents:UIControlEventTouchUpInside];
    [live1 setTitle:@"跳转实名认证" forState:UIControlStateNormal];
    
    [self.view addSubview:live1];
    
    
    [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
        if (License) {
            NSLog(@"授权成功");
        }else{
            NSLog(@"授权失败");
        }
    }];
    
    
    
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

- (void)CheckIDCard:(id)sender {

    
    PersonCenterViewController *perVc = [[PersonCenterViewController alloc]init];
    [self.navigationController pushViewController:perVc animated:YES];
}


- (void)Checklive:(id)sender {
    //    __unsafe_unretained UIViewController *weakSelf = self;
//    BOOL idcard = [MGIDCardManager getLicense];
//    
//    if (!idcard) {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
//        return;
//    }
//    
//    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
//    
//    [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_FRONT
//                               finish:^(MGIDCardModel *model) {
//                                   [self.cardView setImage:[model croppedImageOfIDCard] forState:UIControlStateNormal];
//                                   debugLog(@"%@",model);
//                               }
//                                 errr:^(MGIDCardError) {
//                                     //                                     weakSelf.cardView.image = nil;
//                                 }];
    
    MyViewController *myVC = [[MyViewController alloc] initWithDefauleSetting];
    
    BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:myVC];
    
    
    
    [self presentViewController:nav animated:NO completion:nil];

}

- (void)Checklive1:(id)sender {
    //    __unsafe_unretained UIViewController *weakSelf = self;
    //    BOOL idcard = [MGIDCardManager getLicense];
    //
    //    if (!idcard) {
    //        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
    //        return;
    //    }
    //
    //    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
    //
    //    [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_FRONT
    //                               finish:^(MGIDCardModel *model) {
    //                                   [self.cardView setImage:[model croppedImageOfIDCard] forState:UIControlStateNormal];
    //                                   debugLog(@"%@",model);
    //                               }
    //                                 errr:^(MGIDCardError) {
    //                                     //                                     weakSelf.cardView.image = nil;
    //                                 }];
    
//    LiveViewController *myVC = [[LiveViewController alloc] init];
//    
//    [self.navigationController pushViewController:myVC animated:YES];
    
    IdentityIDViewController *myVC = [[IdentityIDViewController alloc]init];
   [self.navigationController pushViewController:myVC animated:YES];
    
}




@end
