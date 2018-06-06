//
//  XDYScanInfoController.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/20.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYScanInfoController.h"

@interface XDYScanInfoController ()

@end

@implementation XDYScanInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    textView.font = [UIFont systemFontOfSize:16];
    textView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    textView.text = _infoString;
    [self.view addSubview:textView];
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
