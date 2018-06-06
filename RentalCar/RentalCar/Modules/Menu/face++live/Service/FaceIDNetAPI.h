//
//  FaceIDNetAPI.h
//  MegLiveDemo
//
//  Created by 张英堂 on 16/6/13.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceIDNetAPI : NSObject


/* 本网络代码示例代码基于 <AFNetWorking> 3.0 以上版本  */

/*
 
 *  FaceID verifyV2 接口调用
 *
 *  @param images    活体检测中产生的图片
 *  @param name      姓名
 *  @param cardId    身份证号
 *  @param cardImage 身份证图片
 *  @param delta     活体检测中产生
 *  @param finish    返回
- (void)verifyV2FaceImages:(NSDictionary *)images
              userCardName:(NSString *)name
                userCardID:(NSString *)cardId
             userCardImage:(UIImage *)cardImage
                     delta:(NSString *)delta
                    finish:(HttpFinishBlock)finish;
 
 
 *   FaceID  verifyv1 接口调用
 *
 *  @param images  活体检测产生的图片
 *  @param name    要验证的姓名
 *  @param cardId  要验证的身份证号
 *  @param delta   活体检测中产生的 delta
 *  @param cardImg 身份证图片
 *  @param finish  回调
 
- (void)verifyFaceImages:(NSDictionary *)images
            userCardName:(NSString *)name
              userCardID:(NSString *)cardId
                   delta:(NSString *)delta
             userCardImg:(UIImage *)cardImg
                  finish:(HttpFinishBlock)finish;

 
 
 
 
 
 
 
 */


@end
