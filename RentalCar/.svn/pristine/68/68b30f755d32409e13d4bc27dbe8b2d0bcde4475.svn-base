//
//  XDYScanVC.h
//  RentalCar
//
//  Created by zhanbing han on 17/4/10.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"
#import "BackProtocol.h"
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVFoundation.h>

@interface XDYScanVC : BaseController

@property (atomic,weak) AVCaptureVideoPreviewLayer *preView;//预览视图层
@property (atomic,strong) AVCaptureDevice *camera;
@property (atomic,strong) AVCaptureDeviceInput *input;
@property (atomic,strong) AVCaptureMetadataOutput *output;
@property (atomic,strong) AVCaptureSession *session;

@property (nonatomic, weak)  id<BackProtocol> backDelegate;

@end
