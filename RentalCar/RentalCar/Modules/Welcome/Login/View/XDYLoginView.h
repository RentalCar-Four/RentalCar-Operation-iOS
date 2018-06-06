//
//  LoginView.h
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "ActionType.h"
#import "LoginParamItem.h"
#import "XDYPickerView.h"

@protocol XDYLoginDelegate <NSObject>


@optional
- (void)onClickWithValidateEvent:(NSString *)phone;
- (void)onClickWithLoginEvent:(LoginParamItem *)item;
- (void)onClickWithProtocolEvent;
- (void)onOptionWithProtocolEvent;
- (void)onarealist:(UIButton*)button;


@end

@interface XDYLoginView : BaseView

//@property(nonatomic,strong) UIButton *areaBut;


@property(nonatomic, strong) NSArray *arealistArr;

@property(nonatomic, copy) NSString *areaId;

@property(nonatomic, strong) LoginParamItem *item;

@property(nonatomic, weak) id<XDYLoginDelegate> loginDelegate;

@property(nonatomic, copy) NSURL *webViewUrl;


- (void)notifyStopTimer;

- (void)resetValidateCode;

- (void)showAreaView:(Boolean)isVisiable;

@end
