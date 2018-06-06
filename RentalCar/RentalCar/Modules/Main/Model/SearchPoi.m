//
//  SearchPoi.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/28.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "SearchPoi.h"

@implementation SearchPoi

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
}

@end
