//
//  ProtocolController.m
//  RentalCar
//
//  Created by hu on 17/3/5.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYProtocolController.h"

@implementation XDYProtocolController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp{
    
    
    self.title = @"租赁协议";
    self.view.backgroundColor = kBgColor;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onBackClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    
    
}

- (void)onBackClick{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
