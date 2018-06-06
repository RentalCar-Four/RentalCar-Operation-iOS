//
//  CommonRequest.m
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#define SUCCESS 1
#define TOKEN_INVALID 2 //token不正确或已失效
#define NEED_LOGIN 8 //需要登录

#import "CommonRequest.h"
#import "UrlConfig.h"
#import "BaseItem.h"
#import "TipUtil.h"
#import "APPUtil.h"
#import "SignKeyUtil.h"
#import <YYModel.h>
#import "AFNetworking.h"
#import "LogShowView.h"

@interface CommonRequest()
@property (nonatomic , strong) LogShowView *logShowView;
@end


@implementation CommonRequest

+ (instancetype)shareRequest{
    
    static CommonRequest *requestInstance;
    static dispatch_once_t t;
    
    dispatch_once(&t, ^{
        
        requestInstance = [[self alloc]init];
        
    });
    return requestInstance;
}

- (void)requestWithGet:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure{
    [TipUtil showProgressIsCovered:NO];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *urlPath = @"";
    NSMutableDictionary *params = [param mutableCopy];
    if (params.allKeys.count==0) { //参数为空
        urlPath = [domainUrl() stringByAppendingString:url];
    } else {
        [params setObject:kNonceStr forKey:@"nonceStr"];
        NSString *signStr = [SignKeyUtil getSignByDic:params withType:@"get"];
        urlPath = [domainUrl() stringByAppendingString:[url stringByAppendingString:signStr]];
    }
    
    [manager GET:urlPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [self filterEmptyParam:responseObject];
        [self parseRequestResult:result requestUrl:url success:success failuer:failure];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,jsonStr];
        NSLog(@"%@",content)
        [self inputLogText:content];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorContent = @"网络连接错误，请稍后再试";
        failure(errorContent);
        [TipUtil showErrorTip:errorContent];
        
        [TipUtil stopProgress:NO];
        if (error.code==-1009) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetDisAppear" object:nil];
        }
        NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,errorContent];
        NSLog(@"%@",content)
        [self inputLogText:content];
    }];
}

- (void)requestWithPost:(NSString *)url isCovered:(BOOL)isCovered parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure{
    
    if (![url isEqualToString:getStationCarListUrl()]
        && ![url isEqualToString:getBookingCarUrl()]
        && ![url isEqualToString:getOpenBookingCarUrl()]
        && ![url isEqualToString:getMemberAccountUrl()]
        && ![url isEqualToString:getMemberTotalData()]
        && ![url isEqualToString:getRentPwd()]
        && ![url isEqualToString:getStationForLeaseUrl()]
        && ![url isEqualToString:getStationForReturnUrl()]
        && ![url isEqualToString:getCarInLeaseUrl()]
        && ![url isEqualToString:getAuthUrl()]
        && ![url isEqualToString:getCarInBookingUrl()]
        && ![url isEqualToString:getCarInSearchInfoUrl()]
        && ![url isEqualToString:getCarInLeaseUrl()]
        && ![url isEqualToString:getOpenCarDirectlyUrl()]
        && ![url isEqualToString:getLogoutUrl()]
        && ![url isEqualToString:uploadLatLng()]) {
        [TipUtil showProgressIsCovered:NO];
    }
    //状态栏旁边的菊花转动
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *urlPath = [domainUrl() stringByAppendingString:url];
    
    NSMutableDictionary *params = [param mutableCopy];
    //封装的签名
    [params setObject:kNonceStr forKey:@"nonceStr"];
    if ([APPUtil isLoginWithJump:NO]
        &&![url isEqualToString:getStationForLeaseUrl()]
        &&![url isEqualToString:getStationCarListUrl()]
        &&![url isEqualToString:getAreaListUrl()]
        &&![url isEqualToString:getServicePhoneUrl()]
        ) {
        [params setObject:[UserInfo share].token forKey:@"token"];
    }
    [params setObject:[SignKeyUtil getSignByDic:params withType:@"post"] forKey:@"sign"];
    
        debugLog(@"参数%@%@",urlPath,params);
    
    [manager POST:urlPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //状态栏旁边的菊花停止
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *result = [self filterEmptyParam:responseObject];
        [self parseRequestResult:result requestUrl:url success:success failuer:failure];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,jsonStr];
        NSLog(@"%@",content)
        [self inputLogText:content];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //状态栏旁边的菊花停止
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@",[error localizedDescription]);
        
        NSString *errorContent = @"网络连接错误，请稍后再试";
        failure(errorContent);
        
        if (![url isEqualToString:getAuthUrl()]
            && ![url isEqualToString:getCarInBookingUrl()]
            && ![url isEqualToString:getCarInLeaseUrl()]
            && ![url isEqualToString:getCarInSearchInfoUrl()]
            && ![url isEqualToString:uploadLatLng()]
            ) {
            [TipUtil showErrorTip:errorContent];
        }
        
        [TipUtil stopProgress:NO];
        
        NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,errorContent];
        NSLog(@"%@",content)
        [self inputLogText:content];
    }];
}

//打印接口内容
- (void)inputLogText:(NSString *)content {
//    if (!KOnline) {
        _logShowView = [LogShowView shareInstance];
        _logShowView.textViews.text = [NSString stringWithFormat:@"时间%@\n%@\n\n\n\n\n\n%@",[APPUtil getCurrentDate],content,_logShowView.textViews.text];
//    }
}

//上传文件的post
- (void)requestWithPostUpload:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure{
    
    [TipUtil showProgressIsCovered:NO];
    //状态栏旁边的菊花停止
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *urlPath = [domainUrl() stringByAppendingString:url];
    
    NSMutableDictionary *params = [param mutableCopy];
    //获取图片
    UIImage *first = [[UIImage alloc]init];
    NSData *data;
    NSString *key;
    NSArray *tempImgArr;
    
    switch (self.upType) {
        case 0:
        {
            key = @"imgIdFront";
            first = [UIImage imageWithContentsOfFile:[params objectForKey:@"imgIdFront"]];
            data = UIImagePNGRepresentation(first);
        }
            break;
            
        case 1:
        {
            key = @"imgDriver";
            first = [UIImage imageWithContentsOfFile:[params objectForKey:@"imgDriver"]];
            data = UIImagePNGRepresentation(first);
        }
            break;
            
        case 2:
        {
            key = @"imgFace";
            data = [params objectForKey:@"imgFace"];
        }
            break;
            
        case 3:
        {
            key = @"headImg";
            data = [params objectForKey:@"headImg"];
            first = [UIImage imageWithContentsOfFile:[params objectForKey:@"headImg"]];
            data = UIImagePNGRepresentation(first);
        }
            break;
            
        case 4:
        {
            key = @"tempImgArr";
            tempImgArr = [param objectForKey:@"tempImgArr"];
        }
            break;
            
            
        default:
            break;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@and.jpg", str];
    [params removeObjectForKey:key];
    //封装的签名
    [params setObject:kNonceStr forKey:@"nonceStr"];
    [params setObject:[SignKeyUtil getSignByDic:params withType:@"post"] forKey:@"sign"];
    [manager POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *tempKey;
        if (self.upType == 4) {
            for (int i = 0; i < 3; i ++) {
                UIImage *image = tempImgArr[i];
                if (i == 0) {
                    tempKey =@"imgIdFront";
                }else if (i == 1){
                    tempKey =@"imgDriver";
                }else{
                    tempKey =@"imgHandID";
                }
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:tempKey fileName:fileName mimeType:@"multipart/form-data"];
            }
        }else{
            
            [formData appendPartWithFileData:data name:key fileName:fileName mimeType:@"multipart/form-data"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //        debugLog(@"进度:%f",uploadProgress.fractionCompleted);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IdentityUploadProgress" object:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //状态栏旁边的菊花停止
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *result = [self filterEmptyParam:responseObject];
        [self parseRequestResult:result requestUrl:url success:success failuer:failure];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,jsonStr];
        NSLog(@"%@",content)
        [self inputLogText:content];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //状态栏旁边的菊花停止
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *errorContent = @"网络连接错误，请稍后再试";
        failure(errorContent);
        [TipUtil showErrorTip:errorContent];
        [TipUtil stopProgress:NO];
        NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,errorContent];
        NSLog(@"%@",content)
        [self inputLogText:content];
    }];
    
}

- (void)parseRequestResult:(NSDictionary *)responseObject requestUrl:(NSString *)url success:(ReqeustSucc)success failuer:(ReqeustFailure)failure{
    
    BaseItem *item = [BaseItem yy_modelWithJSON:responseObject];
    if (!item) {
        
        NSString *errorContent = @"解析网络数据出错";
        
        if (![url isEqualToString:getAuthUrl()]
            && ![url isEqualToString:getCarInBookingUrl()]
            && ![url isEqualToString:getCarInLeaseUrl()]
            && ![url isEqualToString:getCarInSearchInfoUrl()]
            && ![url isEqualToString:uploadLatLng()]) {
            [TipUtil showErrorTip:errorContent];
        }
        
        failure(errorContent);
        [TipUtil stopProgress:NO];
        return;
    }
    
    if (item.status != SUCCESS) {
        
        if (item.status == TOKEN_INVALID || item.status == NEED_LOGIN) {
            
            if ([url isEqualToString:getAuthUrl()]
                || [url isEqualToString:getCarInBookingUrl()]
                || [url isEqualToString:getCarInLeaseUrl()]
                || [url isEqualToString:getCarInSearchInfoUrl()]
                || [url isEqualToString:uploadLatLng()]) {
                
                [APPUtil logout:NO];
                
                return;
            }
            //退出登录
            [APPUtil logout:YES];
            
            NSString *errorContent = @"登录失效 请重新登录";
            [TipUtil showErrorTip:errorContent];
            [TipUtil stopProgress:NO];
            
            failure(@"token失效");
            
        }else{
            
            [TipUtil stopProgress:NO];
            
            if (![url isEqualToString:getAuthUrl()]
                && ![url isEqualToString:getCarInBookingUrl()]
                && ![url isEqualToString:getCarInLeaseUrl()]
                && ![url isEqualToString:getCarInSearchInfoUrl()]
                && ![url isEqualToString:uploadLatLng()]) {
                [TipUtil showErrorTip:item.msg];
            }
            
            if ([url isEqualToString:getReturnCarUrl()]) { //还车成功
                success(responseObject);
            } else {
                failure(item.msg);
            }
        }
        
    }else{
        
        [TipUtil stopProgress:YES];
        success(responseObject);
    }
    
}

- (id)filterEmptyParam:(id)result
{
    
    NSMutableArray *output = [NSMutableArray array];
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    if ([result isKindOfClass:[NSDictionary class]]) {
        for (id item in result) {
            if ([[result objectForKey:item] isKindOfClass:[NSDictionary class]] || [[result objectForKey:item] isKindOfClass:[NSArray class]] ) {
                [tmpDic setObject:[self filterEmptyParam:[result objectForKey:item]] forKey:item];
            }else if ([[result objectForKey:item] isEqual:[NSNull null]]) {
                [tmpDic setObject:@"" forKey:item];
            }else{
                [tmpDic setObject:[NSString stringWithFormat:@"%@",[result objectForKey:item]] forKey:item];
            }
        }
        return tmpDic;
        
    }else if ([result isKindOfClass:[NSArray class]]){
        for (id obj in result) {
            [output addObject:[self filterEmptyParam:obj]];
        }
        return output;
    }
    return nil;
}

- (NSString *)requestWithPostDownloadPic:(NSString *)url parameters:(NSDictionary *)param{
    [TipUtil showProgressIsCovered:NO];
    NSMutableDictionary *params = [param mutableCopy];
    NSString *urlPath = [domainUrl() stringByAppendingString:url];
    
    [params setObject:kNonceStr forKey:@"nonceStr"];
    [params setObject:[UserInfo share].token forKey:@"token"];
    [params setObject:[SignKeyUtil getSignByDic:params withType:@"post"] forKey:@"sign"];
    NSString *picType = [params objectForKey:@"picType"];
    NSString *newUrl =@"";
    if (self.upType == 5) {
        newUrl = [NSString stringWithFormat:@"%@?nonceStr=%@&sign=%@&token=%@&picType=%@",urlPath,[params objectForKey:@"nonceStr"],[params objectForKey:@"sign"],[params objectForKey:@"token"],picType];
    }else{
        newUrl = [NSString stringWithFormat:@"%@?nonceStr=%@&sign=%@&token=%@",urlPath,[params objectForKey:@"nonceStr"],[params objectForKey:@"sign"],[params objectForKey:@"token"]];
    }
    
    NSString *content = [NSString stringWithFormat:@"参数%@ %@\n返回结果：%@",urlPath,params,newUrl];
    NSLog(@"%@",content)
    [self inputLogText:content];
    return newUrl;
}

@end

