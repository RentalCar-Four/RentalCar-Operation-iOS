//
//  ViewController.m
//  MegLiveDemo
//
//  Created by 张英堂 on 16/1/28.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import "LiveViewController.h"

#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGLivenessDetection.h>


@interface LiveViewController ()


@property (strong, nonatomic)  UIButton *userImage;
@property (strong, nonatomic)  UILabel *messageView;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.userImage = [[UIButton alloc]init];
    [self.userImage setFrame:CGRectMake(0, 0, 200, 200)];
    [self.userImage setBackgroundColor:[UIColor redColor]];
    [self.userImage setTitle:@"活体检测" forState:UIControlStateNormal];
    [self.userImage addTarget:self action:@selector(liveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userImage];
    
    self.messageView = [[UILabel alloc]init];
    
    [self.messageView setFrame:CGRectMake(0, 200, 200, 200)];
    
    [self.view addSubview:self.messageView];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)liveAction:(id)sender {
    
    [self.userImage setImage:nil forState:UIControlStateNormal];
    [self.messageView setText:@""];
    
    if (![MGLiveManager getLicense]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
        return;
    }
    
    MGLiveManager *manager = [[MGLiveManager alloc] init];
    manager.detectionWithMovier = NO;
    manager.actionCount = 3;
    
    [manager startFaceDecetionViewController:self finish:^(FaceIDData *finishDic, UIViewController *viewController) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        
        NSData *header = [[finishDic images] valueForKey:@"image_best"];
        UIImage *image = [UIImage imageWithData:header];
        [self.userImage setImage:image forState:UIControlStateNormal];
        [self.messageView setText:@"活体检测成功"];
//        debugLog(@"%@",finishDic);
        
    } error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        
        [self showErrorString:errorType];
    }];
}

- (void)showErrorString:(MGLivenessDetectionFailedType)errorType{
    switch (errorType) {
        case DETECTION_FAILED_TYPE_ACTIONBLEND:
        {
            [self.messageView setText:@"活体检测未成功\n请按照提示完成动作"];
        }
            break;
        case DETECTION_FAILED_TYPE_NOTVIDEO:
        {
            [self.messageView setText:@"活体检测未成功"];
        }
            break;
        case DETECTION_FAILED_TYPE_TIMEOUT:
        {
            [self.messageView setText:@"活体检测未成功\n请在规定时间内完成动作"];
        }
            break;
        default:
        {
            [self.messageView setText:@"检测失败"];
        }
            break;
    }
}

@end
