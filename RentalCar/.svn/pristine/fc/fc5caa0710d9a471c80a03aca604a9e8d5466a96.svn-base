
//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterMapView.h"
#import "REVClusterManager.h"

@interface REVClusterMapView (Private)
- (void) setup;
- (BOOL) mapViewDidZoom;
@end

@implementation REVClusterMapView

@synthesize minimumClusterLevel;
@synthesize blocks;
@synthesize delegate1;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void) setup
{
    annotationsCopy = nil;
    
    self.minimumClusterLevel = 100000;
    self.blocks = 4;
    
    super.delegate = self;
    
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [annotationsCopy release];
    [super dealloc];
}
#endif

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([delegate1 respondsToSelector:@selector(mapView:rendererForOverlay:)]) {
        return [delegate1 mapView:mapView rendererForOverlay:overlay];
    }
    return nil;
}
    
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if( [delegate1 respondsToSelector:@selector(mapView:viewForAnnotation:)] )
    {
        return [delegate1 mapView:mapView viewForAnnotation:annotation];
    } 
    return nil;
}


- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if( [delegate1 respondsToSelector:@selector(mapView:regionWillChangeAnimated:)] )
    {
        [delegate1 mapView:mapView regionWillChangeAnimated:animated];
    } 
}

- (void)mapViewWillStartLoadingMap:(MAMapView *)mapView
{
    if( [delegate1 respondsToSelector:@selector(mapViewWillStartLoadingMap:)] )
    {
        [delegate1 mapViewWillStartLoadingMap:mapView];
    }
}
- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView
{
    if( [delegate1 respondsToSelector:@selector(mapViewDidFinishLoadingMap:)] )
    {
        [delegate1 mapViewDidFinishLoadingMap:mapView];
    }
}
- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error
{
    if( [delegate1 respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)] )
    {
        [delegate1 mapViewDidFailLoadingMap:mapView withError:error];
    }
}
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if( [delegate1 respondsToSelector:@selector(mapView:didAddAnnotationViews:)] )
    {
        [delegate1 mapView:mapView didAddAnnotationViews:views];
    }
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if( [delegate1 respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)] )
    {
        [delegate1 mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if( [delegate1 respondsToSelector:@selector(mapView:didSelectAnnotationView:)] )
    {
        [delegate1 mapView:mapView didSelectAnnotationView:view];
    }
}
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if( [delegate1 respondsToSelector:@selector(mapView:didDeselectAnnotationView:)] )
    {
        [delegate1 mapView:mapView didDeselectAnnotationView:view];
    }
}

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    if( [delegate1 respondsToSelector:@selector(mapViewWillStartLocatingUser:)] )
    {
        [delegate1 mapViewWillStartLocatingUser:mapView];
    }
}
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    if( [delegate1 respondsToSelector:@selector(mapViewDidStopLocatingUser:)] )
    {
        [delegate1 mapViewDidStopLocatingUser:mapView];
    }
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if ([delegate1 respondsToSelector:@selector(mapView:didUpdateUserLocation:updatingLocation:)]) {
        [delegate1 mapView:mapView didUpdateUserLocation:userLocation updatingLocation:updatingLocation];
    }
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if( [delegate1 respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)] )
    {
        [delegate1 mapView:mapView didFailToLocateUserWithError:error];
    }
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState 
   fromOldState:(MAAnnotationViewDragState)oldState
{
    if( [delegate1 respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)] )
    {
        [delegate1 mapView:mapView annotationView:view didChangeDragState:newState fromOldState:oldState];
    }
}

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)overlayRenderers
{
    if ([delegate1 respondsToSelector:@selector(mapView:didAddOverlayRenderers:)]) {
        [delegate1 mapView:mapView didAddOverlayRenderers:overlayRenderers];
    }
}

- (void) mapView:(MAMapView *)mapView regionDidChangeAnimated
                :(BOOL)animated
{
    
    if( [self mapViewDidZoom] )
    {
        [super removeAnnotations:self.annotations];
        self.showsUserLocation = self.showsUserLocation;
    }
    
    NSArray *add = [REVClusterManager clusterAnnotationsForMapView:self forAnnotations:annotationsCopy blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
    //NSLog(@"count:: %i",[add count]);
    [super addAnnotations:add];
    
    if( [delegate1 respondsToSelector:@selector(mapView:regionDidChangeAnimated:)] )
    {
        [delegate1 mapView:mapView regionDidChangeAnimated:animated];
    }
}

- (BOOL) mapViewDidZoom
{
    
    if( zoomLevel == self.visibleMapRect.size.width * self.visibleMapRect.size.height )
    {
        zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
        return NO;
    }
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
    return YES;
}

- (void) addAnnotations:(NSArray *)annotations
{
    #if !__has_feature(objc_arc)
    [annotationsCopy release];
#endif
    annotationsCopy = [annotations copy];
    
    NSArray *add = [REVClusterManager clusterAnnotationsForMapView:self forAnnotations:annotations blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
    
    [super addAnnotations:add];
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

@end
