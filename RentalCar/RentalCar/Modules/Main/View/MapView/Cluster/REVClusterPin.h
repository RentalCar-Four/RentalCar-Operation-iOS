//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class StationItem;

@interface REVClusterPin : MAPointAnnotation {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    
    NSArray *nodes;
}
@property(nonatomic, retain) NSArray *nodes;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property (nonatomic,retain) StationItem *item;

/** 标注点的protocol，提供了标注类的基本信息函数*/
@property (nonatomic,weak) id<MAAnnotation> delegate;

- (NSUInteger) nodeCount;

@end
