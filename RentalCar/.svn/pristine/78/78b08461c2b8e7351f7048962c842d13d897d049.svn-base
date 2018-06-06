//
//  ClusterTestVC.h
//  RentalCar
//
//  Created by zhanbing han on 17/4/11.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseController.h"
#import <MAMapKit/MAMapKit.h>

@interface ClusterTestVC : BaseController

{
    NSUInteger blocks;
    NSUInteger minimumClusterLevel;
    
    NSArray *annotationsCopy;
    
    double zoomLevel;
}

/// The number of divisions made depending on the visible rect. default is 4, maximum is 1024, minimum is 2 (lower is less accurate but faster), The actual count of divisions is this value to the power of 2.
@property (nonatomic,assign) NSUInteger blocks;
/// The maximum level when clustering is active in the Mapview. default value is 100000, maximum is 419430
@property (nonatomic,assign) NSUInteger minimumClusterLevel;

/** Specifies the receiver‚Äôs delegate object. */
@property(nonatomic,assign) id<MAMapViewDelegate> delegate;

@end
