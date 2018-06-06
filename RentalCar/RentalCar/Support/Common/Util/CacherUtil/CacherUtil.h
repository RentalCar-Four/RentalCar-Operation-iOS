//
//  CacherUtil.h
//  RentalCar
//
//  Created by hu on 17/3/5.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacherUtil : NSObject


+ (id)getCacherWithKey:(NSString *)key;

+ (void)saveCacher:(NSString *) key withValue:(NSString *)value;

+ (void)clearCacher;

@end
