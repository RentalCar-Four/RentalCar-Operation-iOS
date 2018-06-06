//
//  AreaInfo.m
//  RentalCar
//
//  Created by Jason on 2018/1/3.
//  Copyright © 2018年 xyx. All rights reserved.
//

#import "AreaInfo.h"

static AreaInfo *_areaInfo = nil;
static NSUserDefaults *_defaults = nil;

@implementation AreaInfo

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _areaInfo = [[AreaInfo alloc] init];
        _defaults = [NSUserDefaults standardUserDefaults];
    });
    return _areaInfo;
}

- (void)getAreaInfo {
    NSDictionary *areaDic = [_defaults objectForKey:@"AreaInfo"];
    if (areaDic) {
        [self loadAreaDic:areaDic];
    }
}

- (void)setAreaInfo:(NSDictionary *)areaDic {
    [_defaults setObject:areaDic forKey:@"AreaInfo"];
    [_defaults synchronize];
    
    [self loadAreaDic:areaDic];
}

- (void)loadAreaDic:(NSDictionary *)userDic {
    self.areaId = [APPUtil isBlankString:userDic[@"areaId"]]?@"":userDic[@"areaId"];
    self.areaName = [APPUtil isBlankString:userDic[@"areaName"]]?@"":userDic[@"areaName"];
    self.deposit = [APPUtil isBlankString:userDic[@"deposit"]]?@"0":userDic[@"deposit"];
    self.lat = [APPUtil isBlankString:userDic[@"lat"]]?@"0":userDic[@"lat"];
    self.lng = [APPUtil isBlankString:userDic[@"lng"]]?@"0":userDic[@"lng"];
    self.areaStatus = [APPUtil isBlankString:userDic[@"areaStatus"]]?@"":userDic[@"areaStatus"];
    [self getFirstCharacter:self.areaName];
}

- (void)setAreaName:(NSString *)areaName {
    _areaName = areaName;
    [self getFirstCharacter:_areaName];
}

- (void)getFirstCharacter:(NSString *)areaName {
    if (![APPUtil isBlankString:areaName]) {
        NSString *pinyin = [APPUtil chineseToPinyin:areaName];
        if (pinyin.length>0) {
            self.firstCharacter = [pinyin substringToIndex:1];
        }
        NSLog(@"城市拼音首字母：%@",self.firstCharacter);
    }
}

@end
