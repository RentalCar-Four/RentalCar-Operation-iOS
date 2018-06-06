//
//  APPUtil.m
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "APPUtil.h"
#import "LoginItem.h"
#import "CacherUtil.h"
#import <Accelerate/Accelerate.h>
#import "XDYLoginController.h"
#import "sys/utsname.h"
#import <AddressBook/AddressBook.h>
#import "TZImageManager.h"
#import <AVFoundation/AVFoundation.h>
#import "TipUtil.h"
#import "BaseNavController.h"
#import "IdentityIDViewController.h"
#import "DepositViewController.h"
#import "NetworkUtil.h"
#import "ToastView.h"
#import "RechargeViewController.h"
#import "WXApi.h"
#import "Toast.h"
#import <Photos/Photos.h>

@interface APPUtil ()
{
    UIColor *buttonNormalColor;
    UIColor *buttonSelectedColor;
    UIColor *buttonNormalBorderColor;
    UIColor *buttonSelectedBorderColor;
}
@end

static APPUtil *_appUtil = nil;

@implementation APPUtil

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appUtil = [[APPUtil alloc] init];
    });
    return _appUtil;
}

+(NSString *)getCurrentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *fom = [[NSDateFormatter alloc]init];
    fom.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fom stringFromDate:date];
}

+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

+ (BOOL)isLoginWithJump:(BOOL)isJump{
    
    if (![APPUtil isBlankString:[UserInfo share].memberId]) {
        
        return YES;
        
    } else {
        
        if (isJump==YES) {
            XDYLoginController *loginVC = [[XDYLoginController alloc] init];
            [[self getCurrentVC] presentViewController:loginVC animated:YES completion:nil];
        }
        
        return NO;
    }
}

+ (BOOL)isAccountStatePass:(UIViewController *)vc{
    
    int auditStatus = [[UserInfo share].auditStatus intValue];
    int memberStatus = [[UserInfo share].memberStatus intValue];
    int accountStatus = [[UserInfo share].accountStatus intValue];
    if (memberStatus==2) { //禁用
        if (vc != nil) {
            [APPUtil showToast:@"您的账户暂被禁用，请联系客服"];
        }
        return NO;
    }
    if (auditStatus != 6) { //认证状态（ 1 未认证， 2 待认证， 3 认证失败， 4 已认证， 5 待开通， 6 已开通， 7 退款中）
        
        NSString *msg = @"请先完成实名认证";
        NSString *msgTitle = @"提示";
        NSString *butTitle1 = @"取消";
        NSString *butTitle2 = @"确定";
        
        switch (auditStatus) {
            case 1:
                butTitle2 = @"前往认证";
                break;
            case 2:
                msg = @"认证中，请留意认证信息";
                break;
            case 3:
                msgTitle = @"认证未通过";
                msg = [UserInfo share].auditRemark;
                if ([APPUtil isBlankString:msg]) {
                    msg = @"";
                }
                butTitle2 = @"重新认证";
                break;
            case 4:
                msg = @"认证已通过，请缴纳押金";
                butTitle2 = @"缴纳押金";
                break;
            case 7:
                msg = @"您正在申请退款，无法使用租赁服务";
                break;
                
            default:
                break;
        }
        
        if (vc != nil) {
            if (auditStatus==1||auditStatus==3 ||auditStatus==2) {
                
                XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:msg leftButtonTitle:butTitle1 rightButtonTitle:butTitle2 TopButtonTitle:msgTitle];
                alert.doneBlock = ^()
                {
                    IdentityIDViewController *myVC = [[IdentityIDViewController alloc]init];
                    [vc.navigationController pushViewController:myVC animated:YES];
                };
            }
            
            if (auditStatus==4) {
                
                XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:msg leftButtonTitle:butTitle1 rightButtonTitle:butTitle2 TopButtonTitle:msgTitle];
                alert.doneBlock = ^()
                {
                    DepositViewController *depositVc = [[DepositViewController alloc]init];
                    [vc.navigationController pushViewController:depositVc animated:YES];
                };
            }
            
            if (auditStatus==7) {
                
                XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:msg leftButtonTitle:@"" rightButtonTitle:butTitle2 TopButtonTitle:msgTitle];
                alert.doneBlock = ^()
                {
                    
                };
            }
        }
        
        return NO;
    }
    if (accountStatus==2) { //欠费
        if (vc != nil) {
            XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:@"余额不足，请充值" leftButtonTitle:@"取消" rightButtonTitle:@"去充值" TopButtonTitle:@"提示"];
            alert.doneBlock = ^()
            {
                RechargeViewController *depositVc = [[RechargeViewController alloc]init];
                [vc.navigationController pushViewController:depositVc animated:YES];
            };
        }
        return NO;
    }
    
    return YES;
    
}

+ (void)logout:(BOOL)isJumpLoginVC {
    
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserAreaID]; //清除用户注册区域信息
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserAreaName];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kRentPswKey];
    [[SDImageCache sharedImageCache] removeImageForKey:@"headImg" fromDisk:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driveID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"proId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"holdProId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
    
    if (isJumpLoginVC==YES) {
        //跳转到登录页面
        XDYLoginController *loginVC = [[XDYLoginController alloc] init];
        [[self getCurrentVC] presentViewController:loginVC animated:YES completion:nil];
    }
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (BOOL)isBlankString:(id)string
{
    string = [NSString stringWithFormat:@"%@",string];
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if([string isEqualToString:@"<null>"])
    {
        return YES;
    }
    if([string isEqualToString:@" "])
    {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return YES;
    }
    
    return NO;
}

//判断网络状态
+ (BOOL)getNetStatus {
    if ([APPUtil isBlankString:[CacherUtil getCacherWithKey:kNoNetworkKey]]) { //有网
        return YES;
    } else {
        return NO;
    }
}

//仿安卓消息提示
+ (void)showToast:(NSString *)message {
[[Toast shareInstance] makeToast:message duration:MIN(message.length*0.40, 6)];
//    ToastView *toastView = [[ToastView alloc] initWithText:message];
//    [toastView show];
}
    
+ (void)setViewShadowStyle:(UIView *)view {
    view.layer.shadowOffset =  CGSizeMake(0, autoScaleW(2)); //阴影偏移量
    view.layer.shadowOpacity = 0.2; //透明度
    view.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    view.layer.shadowRadius = autoScaleW(5); //模糊度
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    [view.layer setMasksToBounds:NO];
}
//按钮点击效果方法
- (void)setButtonClickStyle:(UIButton *)btn Shadow:(BOOL)Shadow normalBorderColor: (UIColor *)normalBorderColor selectedBorderColor: (UIColor *)selectedBorderColor BorderWidth:(int)BorderWidth normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor cornerRadius:(CGFloat)radius {
    
    buttonNormalColor = normalColor;
    buttonSelectedColor = selectedColor;
    buttonNormalBorderColor =normalBorderColor;
    buttonSelectedBorderColor =selectedBorderColor;
    btn.layer.borderColor =normalBorderColor.CGColor;
    [btn.layer setBorderWidth:BorderWidth];
    btn.backgroundColor = normalColor;
    btn.layer.cornerRadius = radius;
    if (Shadow == YES) {
        [APPUtil setViewShadowStyle:btn];
    }
    
    
    [btn addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpOutside];
}



#pragma mark - methods

- (void)downClick:(UIButton *)button{
    button.layer.borderColor =buttonSelectedBorderColor.CGColor;
    button.backgroundColor = buttonSelectedColor;
    [button.layer setMasksToBounds:YES];
}

- (void)doneClick:(UIButton *)button{
    button.layer.borderColor =buttonNormalBorderColor.CGColor;
//    debugLog(@"%@",buttonNormalColor);
    button.backgroundColor = buttonNormalColor;
    
    [button.layer setMasksToBounds:NO];
}

+ (UIImage *)snapshotSingleView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
     
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (void)runAnimationWithCount:(int)count name:(NSString *)name imageView:(UIImageView *)imageView repeatCount:(int)repeatCount animationDuration:(CGFloat)animationDuration {
    if (imageView.isAnimating) // 判断是否已经开始动画
        return;
    // 1.加载所有的动画图片
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:10000]; // 定义一个图片数组
    [images removeAllObjects];
    for(int i = 0;i < count;i++){
        // 计算文件名，即加载对应的图片。图片命名方式为name_00.
        NSString *fileName = [NSString stringWithFormat:@"%@%02d.png",name,i];
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:fileName ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        // 将图片添加到图片数组中
        [images addObject:image];
    }
    imageView.animationImages = images;
    // 2.设置图片的播放次数
    imageView.animationRepeatCount = repeatCount;
    // 3.设置图片的播放时间
    imageView.animationDuration = images.count*animationDuration; // 图片的总数乘于animationDuration
    [imageView startAnimating]; // 开始播放动画
    // 4.设置动画放完1秒后清除内存
//    if (repeatCount==1) {
//        CGFloat delay = imageView.animationDuration + 1.0;
//        [imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:delay];
//    }
}

+ (NSString*) doDevicePlatform
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //    NSLog(@"设备%@", platform);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    // wb加
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

#pragma mark - 系统权限判断

+ (BOOL)isCameraPermissionOn {
    //相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [self permissionSetup:@"“小灵狗”想访问您的相机"];
            return NO;
        } else {
            return YES;
        }
    } else {
        [TipUtil showErrorTip:@"没有相机功能"];
        return NO;
    }
}

+ (BOOL)isPhotoPermissionOn {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        [self permissionSetup:@"“小灵狗”想访问您的相册"];
        return NO;
    } else {
        return YES;
    }
}

+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block {
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        if (!granted){
            [self permissionSetup:@"“小灵狗”想访问您的麦克风"];
            block(NO);
        } else {
            block(YES);
        }
    }];
}

//跳转到系统权限设置页面
+ (void)permissionSetup:(NSString *)title {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到系统设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    //弹出提示框；
    [[APPUtil getCurrentVC] presentViewController:alert animated:true completion:nil];
}

+ (NSString *)urlEncoding:(NSString *)urlString {
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)urlDecoding:(NSString *)str {
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)stringByEncodingURLFormat:(NSString*)_key {
    NSString *encodedString = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_key, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8));
    //由于ARC的存在，这里的转换需要添加__bridge，原因我不明。求大神讲解
    return encodedString;
}

+ (CGFloat)getTextWidth:(NSString *)text font:(UIFont *)font forHeight:(CGFloat)height {
    
    CGSize contentSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    contentSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return contentSize.width;
}

+ (CGFloat)getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width {
    CGSize contentSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    contentSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return contentSize.height;
}

- (NSString *)handleDataForSecurity:(NSString *)dataStr{
    if ([dataStr isEqualToString:@""]) {
        return @"";
    }
    NSString *originTel = dataStr;
    NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    return tel;
}


+(BOOL)isInstallWinXinApp{
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi])
    {
        [APPUtil showToast:@"请安装最新版微信客户端"];
        return NO;
    }
    return YES;
}

#pragma mark - 计算两个数相乘，单个数想转字符串，num2传1即可
+(NSString *)multiplyingBy:(NSString *)num1 and:(NSString *)num2{
    //保留小数点后两位
    
    NSDecimalNumberHandler*roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSString *num1Str = [NSString stringWithFormat:@"%@",num1];
    NSString *num2Str = [NSString stringWithFormat:@"%@",num2];
    
    NSDecimalNumber*subtotal = [NSDecimalNumber decimalNumberWithString:num1Str];
    
    NSDecimalNumber*discount = [NSDecimalNumber decimalNumberWithString:num2Str];
    NSDecimalNumber*total = [subtotal decimalNumberByMultiplyingBy:discount
                             
                                                      withBehavior:roundUp];
    
    return [NSString stringWithFormat:@"%@",total];
    
    
}
+ (NSString *)handleTimeWithMinus:(NSInteger)mins{
    NSString *timeStr = @"";
    NSInteger day = 0;
    NSInteger totalMin = mins;
    if (totalMin / 60 / 24>=1){
        day = totalMin / 60 / 24;
        totalMin = totalMin - day * 24 * 60;
    }
    
    NSInteger hour = totalMin / 60;
    NSInteger minut = totalMin - hour * 60;
    if (day>0){
        timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%@天 ",@(day)]];
    }
    if (hour<10){
        timeStr = [timeStr stringByAppendingString:@"0"];
    }
    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%@:",@(hour)]];
    if (minut<10){
        timeStr = [timeStr stringByAppendingString:@"0"];
    }
    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%ld",minut]];
    return timeStr;
}
+ (BOOL)isCanUsePhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
         [APPUtil showToast:@"请打开相册权限"];
        return NO;
    }
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        }];
        return NO;
    }
    
    return YES;
}

+(BOOL)isCurrentCityName{
    NSString *curLocCityName = [CacherUtil getCacherWithKey:kLocationAreaName];;//地区定位的城市ID
    NSString *selectCityName = [AreaInfo share].areaName;//用户选中的城市ID
    return ([curLocCityName isEqualToString:selectCityName]&&curLocCityName.length>0);
}

//用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，如果需要去掉音标，则继续使用kCFStringTransformStripCombiningMarks方法即可
+ (NSString *)chineseToPinyin:(NSString *)chinese {
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}

+(UIViewController *)getVCWithUIView:(UIView *)view{
    id responder = view.nextResponder;
    while (![responder isKindOfClass: [UIViewController class]] && ![responder isKindOfClass: [UIWindow class]])
    {
        responder = [responder nextResponder];
    }
    if ([responder isKindOfClass: [UIViewController class]])
    {
        // responder就是view所在的控制器
        // do something
        return responder;
    }
    return nil;
}


@end
