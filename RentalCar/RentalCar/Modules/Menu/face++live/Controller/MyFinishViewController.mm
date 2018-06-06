//
//  MyFinishViewController.m
//  MegLiveDemo
//
//  Created by 张英堂 on 16/6/15.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import "MyFinishViewController.h"


@interface MyFinishViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *messageView;


@end

@implementation MyFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do  additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self creatView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)creatView{
    if (self.checkOK) {
        //活体检测的数据
        NSData *bestImageData = [self.faceData.images valueForKey:@"image_best"];
        NSString *delta =self.faceData.delta;
//        debugLog(@"%@",delta);
        UIImage *bestImage = [UIImage imageWithData:bestImageData scale:1.0];
        self.imageView.image = bestImage;
        UIImageWriteToSavedPhotosAlbum(bestImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        self.messageView.text = @"活体检测成功";
    }else{
        
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
