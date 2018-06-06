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
#import "REVClusterBlock.h"
#import "REVClusterPin.h"

@interface REVClusterManager : NSObject {
    
}

+ (NSArray *) clusterForMapView:(MAMapView *)mapView forAnnotations:(NSArray *)pins ;
+ (NSArray *) clusterAnnotationsForMapView:(MAMapView *)mapView forAnnotations:(NSArray *)pins blocks:(NSUInteger)blocks minClusterLevel:(NSUInteger)minClusterLevel;

+ (BOOL) clusterAlreadyExistsForMapView:(MAMapView *)mapView andBlockCluster:(REVClusterBlock *)cluster;
- (NSInteger)getGlobalTileNumberFromMapView:(MAMapView *)mapView forLocalTileNumber:(NSInteger)tileNumber;
+ (MAPolygon *)polygonForMapRect:(MAMapRect)mapRect;

@end
