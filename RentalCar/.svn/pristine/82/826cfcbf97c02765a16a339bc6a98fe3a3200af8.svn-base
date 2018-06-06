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
#import "REVAnnotationsCollection.h"

@interface REVClusterBlock : NSObject {
    REVAnnotationsCollection *annotationsCollection;
    
    MAMapRect blockRect;
}

@property MAMapRect blockRect;

- (void) addAnnotation:(id<MAAnnotation>)annotation;
- (id<MAAnnotation>) getClusteredAnnotation;
- (id<MAAnnotation>) getAnnotationForIndex:(NSInteger)index;
- (NSInteger) count;

@end
