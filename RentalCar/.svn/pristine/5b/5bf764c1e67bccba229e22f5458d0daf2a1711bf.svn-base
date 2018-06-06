//
//  ClusterTestVC.m
//  RentalCar
//
//  Created by zhanbing han on 17/4/11.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ClusterTestVC.h"
#import "REVClusterMapView.h"
#import "REVClusterMap.h"
#import "ClusterAnnotationView.h"

@interface ClusterTestVC ()<MAMapViewDelegate>
{
    MAMapView *_mapview;
}

@end

@implementation ClusterTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聚合";
    
    annotationsCopy = nil;
    
    self.minimumClusterLevel = 100000;
    self.blocks = 4;
    
    [self addMapViewAndeAnnotations];
    
    zoomLevel = _mapview.visibleMapRect.size.width * _mapview.visibleMapRect.size.height;
}

- (void)addMapViewAndeAnnotations
{
    _mapview                = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _mapview.delegate       = self;
    [self.view addSubview:_mapview];
    
    //广州市经纬度中心点
    CLLocationCoordinate2D coordinate;
    coordinate.latitude     = 23.117055306224895;
    coordinate.longitude    = 113.2759952545166;
    _mapview.region         = MACoordinateRegionMakeWithDistance(coordinate, 100000, 100000);
    
    NSBundle *bundle        = [NSBundle mainBundle];
    NSURL *listurl          = [bundle URLForResource:@"MapLabeling" withExtension:@"plist"];
    NSDictionary *dict      = [NSDictionary dictionaryWithContentsOfURL:listurl];
    
    NSMutableArray *pins    = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dict count]; i++) {
        NSString *key = [[NSString alloc] initWithFormat:@"%i",i+1];
        NSDictionary *tmpdic = [dict objectForKey:key];
        
        REVClusterPin *pin  = [[REVClusterPin alloc] init];
        pin.title           = [tmpdic objectForKey:@"name"];
        pin.subtitle        = [tmpdic objectForKey:@"address"];
        CLLocationCoordinate2D coord    = {[[tmpdic objectForKey:@"lat"] doubleValue],[[tmpdic objectForKey:@"lon"] doubleValue]};
        pin.coordinate      = coord;
        
        [pins addObject:pin];
    }
    
    NSLog(@"哈哈哈哈%@",pins);
    
    [_mapview addAnnotations:pins];
}

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([annotation class] == MAUserLocation.class) {
        return nil;
    }
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MAAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        annView = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (ClusterAnnotationView *)[[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        [(ClusterAnnotationView *)annView setClusterText:[NSString stringWithFormat:@"%lu",(unsigned long)[pin nodeCount]]];
        annView.canShowCallout = YES;
    } else {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] ;
        
        annView.image = [UIImage imageNamed:@"iconfont-mark.png"];
        annView.canShowCallout = YES;
    }
    
    return annView;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    //获取标题和副标题
    //REVClusterPin *pin = (REVClusterPin *)(view.annotation);
    //获取view
    //    MyAnnotationView *annview = (MyAnnotationView*)view;
    //    NSLog(@"lat=%f",annview.coordinate.latitude);
    //    NSLog(@"lon=%f",annview.coordinate.longitude);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_mapview removeAnnotations:_mapview.annotations];
    _mapview.frame = self.view.bounds;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if( [self mapViewDidZoom] )
    {
        [_mapview removeAnnotations:_mapview.annotations];
        _mapview.showsUserLocation = _mapview.showsUserLocation;
    }
    
    NSArray *add = [REVClusterManager clusterAnnotationsForMapView:_mapview forAnnotations:annotationsCopy blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
    //NSLog(@"count:: %i",[add count]);
    [_mapview addAnnotations:add];
}

- (BOOL) mapViewDidZoom
{
    
    if( zoomLevel == _mapview.visibleMapRect.size.width * _mapview.visibleMapRect.size.height )
    {
        zoomLevel = _mapview.visibleMapRect.size.width * _mapview.visibleMapRect.size.height;
        return NO;
    }
    zoomLevel = _mapview.visibleMapRect.size.width * _mapview.visibleMapRect.size.height;
    return YES;
}

- (void) addAnnotations:(NSArray *)annotations
{
#if !__has_feature(objc_arc)
    [annotationsCopy release];
#endif
    annotationsCopy = [annotations copy];
    
    NSArray *add = [REVClusterManager clusterAnnotationsForMapView:_mapview forAnnotations:annotations blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
    
    [_mapview addAnnotations:add];
}


- (void) setMaximumClusterLevel:(NSUInteger)value
{
    if ( value > 419430 )
        minimumClusterLevel = 419430;
    else
        minimumClusterLevel = round(value);
}

- (void) setBlocks:(NSUInteger)value
{
    if( value > 1024 )
        blocks = 1024;
    else if ( value < 2 )
        blocks = 2;
    else
        blocks = round(value);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
