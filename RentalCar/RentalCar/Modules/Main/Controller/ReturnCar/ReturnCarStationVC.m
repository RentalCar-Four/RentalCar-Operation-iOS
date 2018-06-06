//
//  ReturnCarStationVC.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ReturnCarStationVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAAnnotationView+RotateWithHeading.h"
#import "ErrorInfoUtility.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "ReturnCarAnnotationView.h"
#import "CarPointAnnotation.h"
#import "LocationTransform.h"

#import "XDYHomeService.h"
#import "CarGuideView.h"
#import "GPSNaviVC.h"
#import "SearchListVC.h"
#import "BaseNavController.h"

#import "BackProtocol.h"
#import "SearchPoi.h"

@interface ReturnCarStationVC ()<ObserverServiceDelegate,CarGuideDelegate, MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,BackProtocol>
{
    XDYHomeService *_homeService;
    
    //高德地图
    MAMapView *_mapView; //高德地图
    AMapLocationManager *_locationManager; //定位管理者
    CLLocation *_userLocation; //用户当前的位置
    MAPointAnnotation *_anno;
    ReturnCarAnnotationView *_carAnnoView;
    AMapSearchAPI *_search; //搜索
    CLLocationCoordinate2D _startCoordinate; /* 起始点经纬度. */
    CLLocationCoordinate2D _destinationCoordinate; /* 终点经纬度. */
    CLLocationCoordinate2D _centerCoordinate; /* 中心点经纬度. */
    
    UIButton *_searchBtn; //搜索按钮
    UIButton *_locationBtn; //定位
    
    //数据源
    NSMutableArray *_stationArr; //站点信息
    NSMutableArray *_carAnnoArr; //网点标注
    StationCarItem *_currentStationItem; //当前网点
    
    NSString *stationRadius; //站点半径
    NSString *currentCity; //当前城市
}

//懒加载
@property (nonatomic,strong) CarGuideView *carGuideView; //车辆归还导航

@end

@implementation ReturnCarStationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看还车点";
    
    _homeService = [[XDYHomeService alloc] init];
    _homeService.serviceDelegate = self;
    
    _carAnnoArr = [NSMutableArray array];
    
    [self initMapView]; //高德地图
    
    stationRadius = @"1000";

}

#pragma mark - get data

- (void)getData {
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_userLocation.coordinate.latitude andLongitude:_userLocation.coordinate.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    NSLog(@"转化后:%f, %f", afterLocation.latitude, afterLocation.longitude);
    
    [self getStationData:afterLocation];
}

//获取站点
- (void)getStationData:(LocationTransform *)location {
    
    //获取还车站点
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"paging",
                              [AreaInfo share].areaId,@"areaId",
                              [NSString stringWithFormat:@"%f",location.longitude],@"gpsLng",
                              [NSString stringWithFormat:@"%f",location.latitude],@"gpsLat",
                              stationRadius,@"distance",nil];
    [_homeService requestStationForReturnWithService:paramDic];
}

#pragma mark - init view

- (CarGuideView *)carGuideView {
    if (!_carGuideView) {
        _carGuideView = [[CarGuideView alloc] init];
        _carGuideView.delegate = self;
    }
    
    return _carGuideView;
}

//高德地图
- (void)initMapView {
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, kScreenWidth, kScreenHeight-NVBarAndStatusBarHeight)];
    _mapView.delegate = self;
    _mapView.showsCompass = NO; //隐藏指南针
    _mapView.showsScale = NO; //隐藏比例尺
    _mapView.rotateEnabled= NO; //禁止地图旋转
    _mapView.rotateCameraEnabled= NO; //禁止地图倾斜
    [self.view addSubview:_mapView];
    
    UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _mapView.height-autoScaleH(127), kScreenWidth, autoScaleH(127))];
    shadowImgView.image = [UIImage imageNamed:@"img_SearchBg"];
    [self.view addSubview:shadowImgView];
    
//    //自定义地图样式(加载json)
//    NSString *path = [NSString stringWithFormat:@"%@/style_json.json", [NSBundle mainBundle].bundlePath];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    [_mapView setCustomMapStyle:data];
//    [_mapView setCustomMapStyleEnabled:YES];  //自定义地图样式生效
    
    //自定义地图样式(加载data)
    NSString *path = [NSString stringWithFormat:@"%@/map_style_water.data", [NSBundle mainBundle].bundlePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [_mapView setCustomMapStyleWithWebData:data];
    [_mapView setCustomMapStyleEnabled:YES];  //自定义地图样式生效
    
    //开启定位
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    //创建定位管理者
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [self setLocationManagerForAccuracyBest]; //十米精确度
    //开始定位
    [_locationManager startUpdatingLocation];
    
    //搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    
    //搜索按钮
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(autoScaleW(10), self.view.height-autoScaleW(78), kScreenWidth-autoScaleW(20), autoScaleW(48))];
    _searchBtn.backgroundColor = [UIColor whiteColor];
    [_searchBtn.layer setCornerRadius:autoScaleW(10.0)];
    _searchBtn.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
    _searchBtn.layer.shadowOpacity = 0.2; //透明度
    _searchBtn.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    _searchBtn.layer.shadowRadius = autoScaleW(6); //模糊度
    _searchBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_searchBtn.bounds] CGPath];
    [_searchBtn.layer setMasksToBounds:NO];
    [_searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"搜索目的地附近还车点" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:UIColorFromRGB(0xB4B4B4) forState:UIControlStateNormal];
    [_searchBtn.titleLabel setFont:[UIFont systemFontOfSize:autoScaleW(16)]];
    [_searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -autoScaleW(130), 0.0, 0.0)];
    [_searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, autoScaleW(100))];
    [_searchBtn addTarget:self action:@selector(searchNearStation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    //定位
    _locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-autoScaleW(54), self.view.height-autoScaleH(132), autoScaleW(44), autoScaleW(44))];
    [_locationBtn setImage:[UIImage imageNamed:@"icon_Location"] forState:UIControlStateNormal];
    _locationBtn.backgroundColor = [UIColor whiteColor];
    [_locationBtn.layer setCornerRadius:autoScaleW(10.0)];
    [APPUtil setViewShadowStyle:_locationBtn];
    [_locationBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationBtn];
    
}

#pragma mark - methods

//搜索附近网点
- (void)searchNearStation {
    
    [StatisticsClass eventId:XC06];
    
    SearchListVC *searchVC = [[SearchListVC alloc] init];
    searchVC.backDelegate = self;
    searchVC.city = currentCity;
    BaseNavController *nc = [[BaseNavController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nc animated:YES completion:nil];
}

//定位
- (void)location {
    //设置地图中心点
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setZoomLevel:17 animated:YES];
    });
    
    [self getData]; //获取数据
    
    //开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - Animation 动画

//选择标注动画
- (void)selectAnnoAnimation {
    
    _carAnnoView.countLabel.hidden = YES;
    
    /*创建弹性动画
     damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
     velocity:弹性复位的速度
     */
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if ([_currentStationItem.entityPileCount integerValue]>0) {
            _carAnnoView.imgView.image = [UIImage imageNamed:@"entity_pile_selected"];
        } else {
            _carAnnoView.imgView.image = [UIImage imageNamed:@"virtual_pile_selected"];
        }
        _carAnnoView.imgView.frame = CGRectMake(0, autoScaleW(8), autoScaleW(67), autoScaleW(67));
    } completion:nil];
}

//还车导航动画
- (void)showReturnCarAnimation {
    //大弹框动画
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.carGuideView.alpha = 1;
        self.carGuideView.top = autoScaleH(667-12)-self.carGuideView.height;
        _locationBtn.top = self.carGuideView.top-_locationBtn.height-8;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideReturnCarAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.carGuideView.alpha = 0;
        self.carGuideView.top = autoScaleH(667);
        _locationBtn.top = self.view.height-autoScaleH(132);
        
    } completion:^(BOOL finished) {
    
    }];
}

#pragma mark - ObserverServiceDelegate 代理

- (void)onSuccess:(id)data withType:(ActionType)type{
    
    switch (type) {
            
        case _REQUEST_STATIONFORLEASE_:
        {
            _stationArr = [data mutableCopy];
            
            [_mapView removeAnnotations:_carAnnoArr];
            [_carAnnoArr removeAllObjects];
            
            for (int i = 0; i<_stationArr.count; i++) {
                StationCarItem *item = _stationArr[i];
                CarPointAnnotation *anno = [[CarPointAnnotation alloc] init];
                
                //GPS转化为高德
                LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:[item.gpsLat doubleValue] andLongitude:[item.gpsLng doubleValue]];
                LocationTransform *afterLocation = [beforeLocation transformFromGPSToGD];
                item.gpsLat = [NSString stringWithFormat:@"%f",afterLocation.latitude];
                item.gpsLng = [NSString stringWithFormat:@"%f",afterLocation.longitude];
                
                anno.coordinate = CLLocationCoordinate2DMake([item.gpsLat doubleValue],[item.gpsLng doubleValue]);
                anno.item = item;
                //将大头针添加到地图中
                [_mapView addAnnotation:anno];
                [_carAnnoArr addObject:anno];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)onFailureWithType:(ActionType)type{
    
    switch (type) {
        case _REQUEST_STATIONFORLEASE_:
            
            
            break;
            
        default:
            break;
    }
}

#pragma mark - CarReturnDelegate 代理

//导航
- (void)onClickWithReturnCarGuideEvent:(StationCarItem *)item {
    
    [StatisticsClass eventId:XC07];
    
    GPSNaviVC *naviVC = [[GPSNaviVC alloc] init];
    naviVC.startCoordinate = _startCoordinate;
    naviVC.destinationCoordinate = _destinationCoordinate;
    [self.navigationController pushViewController:naviVC animated:YES];
}

#pragma mark - BackProtocol 代理

- (void)mapSearchBackAction:(SearchPoi *)poi {
    
    NSLog(@"搜索经纬度：%f  %f",poi.latitude,poi.longitude);
    
    //设置地图中心点
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.latitude,poi.longitude) animated:YES];
    
    //创建大头针
    [_mapView removeAnnotation:_anno];
    _anno = [[MAPointAnnotation alloc] init];
    _anno.coordinate = CLLocationCoordinate2DMake(poi.latitude,poi.longitude);
    _anno.title = poi.name;
    //将大头针添加到地图中
    [_mapView addAnnotation:_anno];
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:poi.latitude andLongitude:poi.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    NSLog(@"转化后:%f, %f", afterLocation.latitude, afterLocation.longitude);
    
    [self getStationData:afterLocation];
}

#pragma mark - mapView 代理方法

//定位结果回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    // 定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    //更新用户位置
    _userLocation = location;
    //设置地图中心点
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
    
    //反地理编码出地理位置
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    regeo.requireExtension =YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch:regeo];
    
    // 停止定位
    [_locationManager stopUpdatingLocation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setZoomLevel:17 animated:YES];
    });
    
    [self getData]; //获取数据
}

//当位置(经纬度/方向)更新时，会进行定位回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        //更新用户位置
        _userLocation = userLocation.location;
        
        //取得用户大头针视图
        MAAnnotationView *userView = [mapView viewForAnnotation:mapView.userLocation];
        //取方向信息
        CLHeading *userHeading = userLocation.heading;
        //根据方向旋转箭头
        [userView rotateWithHeading:userHeading];
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if (response.regeocode !=nil ) {
        
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.city);
        
        currentCity = response.regeocode.addressComponent.city;
    }
}

//单击地图
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.view endEditing:YES];
    
    //隐藏选择车辆
    [self hideReturnCarAnimation];
}

//地图缩放开始
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    
    _mapView.showsScale = YES; //显示比例尺
}

//地图缩放结束
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    
    _mapView.showsScale = NO; //隐藏比例尺
    
    CGPoint leftTopPoint = CGPointMake(0, 0);
    CGPoint rightBottomPoint = CGPointMake(_mapView.width, _mapView.height);
    
    CLLocationCoordinate2D leftTopCoordinate = [_mapView convertPoint:leftTopPoint toCoordinateFromView:_mapView];
    CLLocationCoordinate2D rightBottomCoordinate = [_mapView convertPoint:rightBottomPoint toCoordinateFromView:_mapView];
    
    MAMapPoint p1 = MAMapPointForCoordinate(leftTopCoordinate);
    MAMapPoint p2 = MAMapPointForCoordinate(rightBottomCoordinate);
    
    CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
    stationRadius = [NSString stringWithFormat:@"%d",(int)distance/2];
//    if (distance/2>700) {
//        stationRadius = @"700";
//    } else {
        stationRadius = [NSString stringWithFormat:@"%d",(int)distance/2];
//    }
    
    //中心点经纬度
    CGPoint centerPoint = _mapView.center;
    _centerCoordinate = [_mapView convertPoint:centerPoint toCoordinateFromView:_mapView];
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_centerCoordinate.latitude andLongitude:_centerCoordinate.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
    
    [self getStationData:afterLocation];
}

//地图移动结束
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    if (wasUserAction==YES) {
        
//        NSLog(@"用户移动地图结束");
        
        CGPoint centerPoint = _mapView.center;
        
        _centerCoordinate = [_mapView convertPoint:centerPoint toCoordinateFromView:_mapView];
        
//        NSLog(@"屏幕中心点经纬度：%f %f",_centerCoordinate.latitude,_centerCoordinate.longitude);
        
        LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_centerCoordinate.latitude andLongitude:_centerCoordinate.longitude];
        //高德转化为GPS
        LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
        
        [self getStationData:afterLocation];
    }
}

//设置标注图
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) //自定义定位标注样式
    {
        static NSString *userAnnotationIdentifer = @"userAnnotationIdentifer";
        MAAnnotationView *userView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:userAnnotationIdentifer];
        if (userView == nil)
        {
            userView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userAnnotationIdentifer];
        }
        userView.image = [UIImage imageNamed:@"img_Location"];
        return userView;
    }
    
    if ([annotation isKindOfClass:[CarPointAnnotation class]]) { //自定义站点标注
        static NSString *reuseIndetifier = @"annotationIndetifier";
        ReturnCarAnnotationView *annotationView = (ReturnCarAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[ReturnCarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        CarPointAnnotation *pointAnno = (CarPointAnnotation *)annotationView.annotation;
        annotationView.item = pointAnno.item;
        
        //设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
//        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(autoScaleW(4), autoScaleW(-24));
        
        return annotationView;
    }
    
    return nil;
}

//选中标注触发方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[ReturnCarAnnotationView class]]) {
        
        //获取站点数据
        CarPointAnnotation *pointAnno = (CarPointAnnotation *)view.annotation;
        StationCarItem *item = pointAnno.item;
        _currentStationItem = item;
        NSLog(@"选中站点ID：%@",item.stationId);
        
        _carAnnoView = (ReturnCarAnnotationView *)view;
        
        _startCoordinate = _userLocation.coordinate;
        _destinationCoordinate = CLLocationCoordinate2DMake([item.gpsLat doubleValue], [item.gpsLng doubleValue]);
        
        //选择车辆
        [self.view addSubview:self.carGuideView];
        self.carGuideView.stationItem = _currentStationItem;
        
        [self selectAnnoAnimation]; //选中标注动画
        [self showReturnCarAnimation]; //还车导航动画
    }
}

//取消选中标注触发方法
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
    
    if ([view isKindOfClass:[ReturnCarAnnotationView class]]) {
        
        if ([_currentStationItem.entityPileCount integerValue]>0) {
            _carAnnoView.countLabel.hidden = NO;
            _carAnnoView.imgView.image = [UIImage imageNamed:@"entity_pile"];
        } else {
            _carAnnoView.countLabel.hidden = YES;
            _carAnnoView.imgView.image = [UIImage imageNamed:@"virtual_pile"];
        }
        _carAnnoView.imgView.frame = CGRectMake(0, autoScaleW(8), autoScaleW(67), autoScaleW(67));
    } else {
        //隐藏选择车辆
        [self hideReturnCarAnimation];
    }
}

//设置百米精确度
-(void)setLocationManagerForHundredMeters{
    
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //2.定位超时时间，最低2s，此处设置为2s
    _locationManager.locationTimeout =2;
    
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    _locationManager.reGeocodeTimeout = 2;
}

//设置十米精确度
-(void)setLocationManagerForAccuracyBest{
    
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //2定位超时时间，最低2s，此处设置为10s
    _locationManager.locationTimeout =10;
    
    //3.逆地理请求超时时间，最低2s，此处设置为10s
    _locationManager.reGeocodeTimeout = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
