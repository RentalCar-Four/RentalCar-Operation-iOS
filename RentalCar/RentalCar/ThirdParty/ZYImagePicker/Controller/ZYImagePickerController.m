//
//  ZYImagePickerController.m
//  ZYImagePicker
//
//  Created by 石志愿 on 2017/8/25.
//  Copyright © 2017年 石志愿. All rights reserved.
//

#import "ZYImagePickerController.h"
#import "ZYClipViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SystemUtils.h"

@interface ZYImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@end

@implementation ZYImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置UINavigationBar的样式
    [[UINavigationBar appearance] setTintColor:kBlueColor];
    [UINavigationBar appearance].barTintColor=[UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:kTitleFont,NSForegroundColorAttributeName:kTitleColor}];
    //将导航条默认黑线改成阴影
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage imageNamed:@"NavbarShadow"]; //阴影图片
    
    [self setUp];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUp];
}

- (void)setUp {
    self.delegate = self;
    self.allowsEditing = NO;
    
    if (self.imageSorceType == sourceType_camera) {
        if (![SystemUtils isAppCameraAccessAuthorized]) {
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        if (![SystemUtils isAppPhotoLibraryAccessAuthorized]) {
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

#pragma mark - 相册

- (void)clipImage:(UIImage *)image {
    
    ZYClipViewController *clipViewController = [[ZYClipViewController alloc]init];
    clipViewController.resizableClipArea = self.resizableClipArea;
    clipViewController.clipSize = self.clipSize;
    clipViewController.originalImage = image;
    clipViewController.borderColor = self.borderColor;
    clipViewController.borderWidth = self.borderWidth;
    clipViewController.slideColor = self.slideColor;
    clipViewController.slideWidth = self.slideWidth;
    clipViewController.slideLength = self.slideLength;
    __weak typeof(self)weakSelf = self;
    clipViewController.clippedBlock = ^(UIImage *clippedImage) {
        [weakSelf clipped:clippedImage];
    };
    clipViewController.cancelClipBlock = ^{
        if (weakSelf.sourceType == UIImagePickerControllerSourceTypeCamera) {

            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [self presentViewController:clipViewController animated:NO completion:nil];
}

- (void)clipped:(UIImage *)image {
    if (self.clippedBlock) {
        self.clippedBlock(image);
    }
    [self saveImageToPhotoAlbum:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

///MARK: 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage {
    
//    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error){
        NSLog(@"保存图片失败");
    }else{
        NSLog(@"保存图片成功");
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 选择照片之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    if (_isResizable==NO) {
        if (self.clippedBlock) {
            self.clippedBlock(originalImage);
        }
    }else{
    [self clipImage:originalImage];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end
