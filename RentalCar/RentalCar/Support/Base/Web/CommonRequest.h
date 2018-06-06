//
//  CommonRequest.h
//  RentalCar
//
//  Created by hu on 17/3/2.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReqeustSucc)(NSDictionary* data);
typedef void (^ReqeustFailure)(NSString* content);


@interface CommonRequest : NSObject

@property(nonatomic,assign)int upType;//选择上传的类型

+ (instancetype)shareRequest;

//get
- (void)requestWithGet:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure;

//post
- (void)requestWithPost:(NSString *)url isCovered:(BOOL)isCovered parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure) failure;

//文件上传post
- (void)requestWithPostUpload:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure;

//单链接下载图片URl
- (NSString *)requestWithPostDownloadPic:(NSString *)url parameters:(NSDictionary *)param;


@end
