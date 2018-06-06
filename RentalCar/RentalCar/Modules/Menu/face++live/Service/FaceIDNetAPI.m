//
//  FaceIDNetAPI.m
//  MegLiveDemo
//
//  Created by 张英堂 on 16/6/13.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import "FaceIDNetAPI.h"

@implementation FaceIDNetAPI


/*

- (void)verifyFaceImages:(NSDictionary *)images userCardName:(NSString *)name userCardID:(NSString *)cardId delta:(NSString *)delta userCardImg:(UIImage *)cardImg  finish:(HttpFinishBlock)finish{
    
    NSString *hostapi = @"https://api.faceid.com/faceid/v1/verify";
    
    NSDictionary *dic = @{@"api_key":@"key",
                          @"api_secret":@"secret",
                          @"name":name,
                          @"idcard":cardId,
                          @"delta":delta};
    
    [[AFHTTPSessionManager manager] POST:hostapi
                              parameters:parameters
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   if (images) {
                       NSArray *allKeys = [images allKeys];
                       [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           NSString *imageKey = obj;
                           NSData *imageData = [images valueForKey:imageKey];
                           
                           [formData appendPartWithFileData:imageData name:imageKey fileName:imageKey mimeType:@"image/jpeg"];
                       }];
                   }
                   if (cardImage) {
                       NSData *cardData = UIImageJPEGRepresentation(cardImage, 1.0);
                       [formData appendPartWithFileData:cardData name:@"image_idcard" fileName:@"image_idcard" mimeType:@"image/jpeg"];
                   }
               }
                                progress:^(NSProgress * _Nonnull uploadProgress) {}
                                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                                     NSDictionary *dic = responseObject;
                                     
                                     if (finish)
                                         finish(dic, operation);
                                 }
                                 failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                     
                                     if (finish)
                                         finish(error, operation);
                                 }];
}



- (void)verifyV2FaceImages:(NSDictionary *)images
              userCardName:(NSString *)name
                userCardID:(NSString *)cardId
             userCardImage:(UIImage *)cardImage
                     delta:(NSString *)delta
                    finish:(HttpFinishBlock)finish{
    
    NSDictionary *parameters = @{@"api_key":@"key",
                                 @"api_secret":@"secret",
                                 @"comparison_type":@"1",
                                 @"face_image_type":@"meglive",
                                 @"idcard_name":name,
                                 @"idcard_number":cardId,
                                 @"delta":delta};
    
    NSString *hostapi = @"https://api.megvii.com/faceid/v2/verify";
    
    [[AFHTTPSessionManager manager] POST:hostapi
                              parameters:parameters
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   if (images) {
                       NSArray *allKeys = [images allKeys];
                       [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           NSString *imageKey = obj;
                           NSData *imageData = [images valueForKey:imageKey];
                           
                           [formData appendPartWithFileData:imageData name:imageKey fileName:imageKey mimeType:@"image/jpeg"];
                       }];
                   }
                   if (cardImage) {
                       NSData *cardData = UIImageJPEGRepresentation(cardImage, 1.0);
                       [formData appendPartWithFileData:cardData name:@"image_ref1" fileName:@"image_ref1" mimeType:@"image/jpeg"];
                   }
               }
                                progress:^(NSProgress * _Nonnull uploadProgress) {}
                                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                                     NSDictionary *dic = responseObject;
                                     
                                     if (finish)
                                         finish(dic, operation);
                                 }
                                 failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                     
                                     if (finish)
                                         finish(error, operation);
                                 }];
    
}

 
 
 */
 
 
 
 
 
 

@end
