//
//  CacherUtil.m
//  RentalCar
//
//  Created by hu on 17/3/5.
//  Copyright © 2017年 xyx. All rights reserved.
//


#import "CacherUtil.h"



@implementation CacherUtil

+ (id)getCacherWithKey:(NSString *)key{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


+ (void)saveCacher:(NSString *)key withValue:(id)value{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

    [defaults setObject:value forKey:key];
    [defaults synchronize];
    
}


+ (void)clearCacher{
    
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
}
@end
