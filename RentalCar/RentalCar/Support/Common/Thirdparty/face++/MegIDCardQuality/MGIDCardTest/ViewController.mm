//
//  ViewController.m
//  MGIDCardTest
//
//  Created by 张英堂 on 16/1/25.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import "ViewController.h"

#import <MGBaseKit/MGBaseKit.h>
#import <MGIDCard/MGIDCard.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *versionView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.versionView.text = [MGIDCardManager IDCardVersion];
    
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
- (IBAction)CheckIDCard:(id)sender {
    __unsafe_unretained ViewController *weakSelf = self;
    BOOL idcard = [MGIDCardManager getLicense];
    
    if (!idcard) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
        return;
    }
    
    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];

    [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_FRONT
                               finish:^(MGIDCardModel *model) {
                                   weakSelf.cardView.image = [model croppedImageOfIDCard];
                                   
                               }
                                 errr:^(MGIDCardError) {
                                     weakSelf.cardView.image = nil;
                                 }];
}


@end
