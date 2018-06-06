//
//  HomeMapView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/26.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "HomeMapView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAAnnotationView+RotateWithHeading.h"
#import "ErrorInfoUtility.h"
#import "CommonUtility.h"
#import "CarPointAnnotation.h"
#import "LocationTransform.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "StationCarItem.h"
#import <TZLocationManager.h>
#import "NSTimer+EocBlockSupports.h"

@interface HomeMapView ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    //高德地图
    AMapSearchAPI *_search; //搜索
    AMapWalkingRouteSearchRequest *_navi; //步行路径规划
    AMapRoute *_route; //路线
    CLLocationCoordinate2D _startCoordinate; /* 起始点经纬度. */
    CLLocationCoordinate2D _destinationCoordinate; /* 终点经纬度. */
    CLLocationCoordinate2D _centerCoordinate; /* 中心点经纬度. */
    
    //数据源
    NSMutableArray *_carAnnoArr; //网点标注
    NSMutableDictionary *_carSelectedAnnoDic; //选中车标注
    BOOL isShowCar;
    CGFloat zoomLevel;
    
    NSTimer *_timer; //定时器
    UIBackgroundTaskIdentifier taskID;
    UIImageView *centerImgview;

    UIButton *tempMenuButton;
    NSInteger typeMenuIndex;
    NSInteger statusMenuIndex;
    UIButton *leftMenuBtn;
    UIButton *rightMenuBtn;
}
@end

@implementation HomeMapView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _carAnnoArr = [NSMutableArray array];
        _carSelectedAnnoDic = [NSMutableDictionary dictionary];
        
        [self setUp];
        [self checkLocationOn];
    }
    
    return  self;
}

- (void)setUp {
    
    zoomLevel = kZoomLevel;
    self.frame = CGRectMake(0, NVBarAndStatusBarHeight, kScreenWidth, kScreenHeight-NVBarAndStatusBarHeight);
    if (IS_IOS_11&&IS_IPhoneX) {//让iPhone x底部留白
//        self.height = kScreenHeight-64- 10;
//        self.clipsToBounds = YES;
    }
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    _mapView.delegate = self;
    _mapView.showsCompass = NO; //隐藏指南针
    _mapView.showsScale = YES; //隐藏比例尺
    _mapView.rotateEnabled= NO; //禁止地图旋转
    _mapView.rotateCameraEnabled= NO; //禁止地图倾斜
    [self addSubview:_mapView];
    
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
    [_locationManager setPausesLocationUpdatesAutomatically:NO]; //设置不允许系统暂停定位
    //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
    } //设置允许在后台定位
    [self setLocationManagerForHundredMeters]; //百米精确度
    //开始定位
    [_locationManager startUpdatingLocation];
    
    //搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    _navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    //提示视图1
    _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, autoScaleH(30))];
    _tipView.backgroundColor = UIColorFromARGB(0xFF8476, 0.9);
    [APPUtil setViewShadowStyle:_tipView];
    _tipView.alpha = 0;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(10), autoScaleH(7), autoScaleW(16), autoScaleW(16))];
    iconView.image = [UIImage imageNamed:@"icon_err"];
    [_tipView addSubview:iconView];
    
    _tipTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(36), 0, kScreenWidth-autoScaleW(50), _tipView.height)];
    _tipTitleLab.text = @"无法连接服务器，请检查您的网络。";
    _tipTitleLab.font = [UIFont systemFontOfSize:autoScaleW(12)];
    _tipTitleLab.textColor = [UIColor whiteColor];
    [_tipView addSubview:_tipTitleLab];
    [self addSubview:_tipView];
    
    //提示视图2
    _tipView1 = [[UIView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, autoScaleH(30))];
    _tipView1.backgroundColor = UIColorFromARGB(0xFF8476, 0.9);
    [APPUtil setViewShadowStyle:_tipView1];
    _tipView1.alpha = 0;
    UIImageView *iconView1 = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(10), autoScaleH(7), autoScaleW(16), autoScaleW(16))];
    iconView1.image = [UIImage imageNamed:@"icon_err"];
    [_tipView1 addSubview:iconView1];
    _tipTitleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(36), 0, kScreenWidth-autoScaleW(50), _tipView.height)];
    _tipTitleLab1.text = @"无法连接服务器，请检查您的网络。";
    _tipTitleLab1.font = [UIFont systemFontOfSize:autoScaleW(12)];
    _tipTitleLab1.textColor = [UIColor whiteColor];
    [_tipView1 addSubview:_tipTitleLab1];
    [self addSubview:_tipView1];
    
    //切换车辆/车桩
    _exchangeCarPileBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-autoScaleW(50), autoScaleH(60), autoScaleW(50), autoScaleW(50))];
    [_exchangeCarPileBtn setBackgroundImage:[UIImage imageNamed:@"icon_station"] forState:UIControlStateNormal];
    [_exchangeCarPileBtn addTarget:self action:@selector(exchangeCarPile) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exchangeCarPileBtn];
    
    //显示车辆列表
    _showCarListBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-autoScaleW(50), autoScaleH(110), autoScaleW(50), autoScaleW(50))];
    [_showCarListBtn setBackgroundImage:[UIImage imageNamed:@"icon_pile"] forState:UIControlStateNormal];
    [_showCarListBtn addTarget:self action:@selector(showCarList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_showCarListBtn];
    
    //扫码用车
    CGFloat fromTop = _mapView.height-autoScaleH(83);
//    if (IS_IPhoneX) {
//        fromTop = _mapView.height-autoScaleW(147);
//        _exchangeCarPileBtn.top =  autoScaleH(10+22);
//    }
    _scanUseCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, fromTop, autoScaleW(165), autoScaleH(83))];
    _scanUseCarBtn.centerX = self.mapView.centerX;
    [_scanUseCarBtn setImage:[UIImage imageNamed:@"btn_scanUseCar"] forState:UIControlStateNormal];
    [_scanUseCarBtn addTarget:self action:@selector(scanUseCar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scanUseCarBtn];
    
    //当前位置定位
    _locationBtn = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(35), _mapView.height - autoScaleH(75), autoScaleW(48), autoScaleH(48))];
    _locationBtn.contentMode = UIViewContentModeScaleAspectFit;
    _locationBtn.image = [UIImage imageNamed:@"icon_Location"];
    _locationBtn.backgroundColor = [UIColor clearColor];
//    [APPUtil setViewShadowStyle:_locationBtn];
    [self addSubview:_locationBtn];
    
    //刷新
    _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - autoScaleW(75), _mapView.height - autoScaleH(75), autoScaleW(42), autoScaleH(42))];
    _refreshBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_refreshBtn setImage:[UIImage imageNamed:@"motion_refresh0000"] forState:UIControlStateNormal];
    _refreshBtn.backgroundColor = [UIColor whiteColor];
    [_refreshBtn.layer setCornerRadius:autoScaleW(21.0)];
    [APPUtil setViewShadowStyle:_refreshBtn];
     [_refreshBtn addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_refreshBtn];
    
    
    _clickLocateBtn = [[UIButton alloc] initWithFrame:_locationBtn.frame];
    _clickLocateBtn.backgroundColor = [UIColor clearColor];
    [_clickLocateBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clickLocateBtn];
    
    
    //地图中心点添加
    centerImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    centerImgview.image = [UIImage imageNamed:@"icon_map_center_pin"];
    centerImgview.contentMode = UIViewContentModeScaleAspectFit;
    [_mapView addSubview:centerImgview];
    centerImgview.center = CGPointMake(_mapView.centerX, _mapView.centerY-centerImgview.height/2.0);
    
    // 如果是模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        [self test]; //放大、缩小按钮
    }
    leftMenuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-1)/2.0,  MIN(autoScaleH(50), 60))];
    leftMenuBtn.backgroundColor = [UIColor whiteColor];
    [leftMenuBtn setTitle:@"全部类型" forState:0];
    [leftMenuBtn setTitleColor:[UIColor darkGrayColor] forState:0];
    leftMenuBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [leftMenuBtn addTarget:self action:@selector(leftMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftMenuBtn];
    
    rightMenuBtn = [[UIButton alloc]initWithFrame:CGRectMake(1+leftMenuBtn.right, leftMenuBtn.top,leftMenuBtn.width, leftMenuBtn.height)];
    rightMenuBtn.backgroundColor = [UIColor whiteColor];
    [rightMenuBtn setTitle:@"全部状态" forState:0];
    rightMenuBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [rightMenuBtn setTitleColor:[UIColor darkGrayColor] forState:0];
    [rightMenuBtn addTarget:self action:@selector(leftMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightMenuBtn];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(leftMenuBtn.width-autoScaleW(45), autoScaleH(7), autoScaleH(36), autoScaleH(36))];
    img1.image = [UIImage imageNamed:@"xl_dd"];
    [leftMenuBtn addSubview:img1];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(leftMenuBtn.width-autoScaleW(45), autoScaleH(7), autoScaleH(36), autoScaleH(36))];
    img2.image = [UIImage imageNamed:@"xl_dd"];
    [rightMenuBtn addSubview:img2];
    typeMenuIndex = 0;
    statusMenuIndex = 0 ;
}

- (void)leftMenuAction:(UIButton *)sender{
    UIView *coverView = [[UIApplication sharedApplication].keyWindow viewWithTag:201712];
    NSArray *tempArr;
    tempMenuButton = sender;
    NSInteger index;
    if (sender.centerX<self.centerX) {
        tempArr = LeftMenuNameArr;
        index = typeMenuIndex;
    }else{
        tempArr = RightMenuNameArr;
        index = statusMenuIndex;;

    }
    if (coverView==nil) {
        [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:tempArr itemsClickBlock:^(NSString *str, NSInteger tag) {
            [tempMenuButton setTitle:str forState:0];
            if (tempMenuButton.centerX<self.centerX) {
                typeMenuIndex = tag;
            }else{
                statusMenuIndex = tag;
                
            }
            if ([self.delegate respondsToSelector:@selector(getCarStatusWithDic:)]) {
                NSDictionary *dic = @{@"carType":CarStatusKeyValue[leftMenuBtn.currentTitle],@"carStatus":CarStatusKeyValue[rightMenuBtn.currentTitle]};
                [self.delegate getCarStatusWithDic:dic];
                [self handleImgViewWithButton:tempMenuButton andRoate:NO];
            }
        } backViewTap:^{
            [self handleImgViewWithButton:tempMenuButton andRoate:NO];
        }];
    }else{
        [CommonMenuView updateMenuItemsWith:tempArr WithIndex:index];
    }
    CGFloat yyy = [sender.superview convertRect:sender.frame toView:self].origin.y;
    
    [CommonMenuView showMenuAtPoint:CGPointMake(sender.centerX, yyy+sender.height-10)];
    [self handleImgViewWithButton:tempMenuButton andRoate:YES];
}

- (void)handleImgViewWithButton:(UIButton *)sender andRoate:(BOOL)status{
    UIImageView *imageView ;
    for (id view in sender.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            imageView = view;
            break;
        }
    }
    float roateValue = -M_PI;
    if (status==NO) {
        roateValue = M_PI;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform transform = imageView.transform;
        imageView.transform = CGAffineTransformRotate(transform, roateValue);
    }];
}


- (void)uploadLoction {
    if ([APPUtil isLoginWithJump:NO]&&[APPUtil isAccountStatePass:nil]) {
        __weak HomeMapView *weakSelf = self;
        // 倒计时
        taskID=  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [weakSelf endBack];
        }];
        // 定时器关闭
        if (_timer) {
            [_timer invalidate];
            [self endBack];
            _timer = nil;
        }
        
        _timer = [NSTimer eocScheduledTimerWithTimeInterval:UploadLocationTime block:^{
            
            [weakSelf timerFire];
        } repeats:YES];
    } else {
        // 定时器关闭
        if (_timer) {
            [_timer invalidate];
            [self endBack];
            _timer = nil;
        }
    }
}

-(void)endBack
{
    [[UIApplication sharedApplication] endBackgroundTask:taskID];
    taskID = UIBackgroundTaskInvalid;
}

#pragma mark - 时间控制器方法（定时上传地理位置）
- (void)timerFire
{
    if ([APPUtil isLoginWithJump:NO]&&[APPUtil isAccountStatePass:nil]) {
        
        double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kLongitude];
        double latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kLatitude];
        if (longitude>0 && latitude>0) {
            
            //上传定位信息到后台
            NSLog(@"上传定位信息到后台");
            
        }
    } else {
        // 定时器关闭
        if (_timer) {
            [_timer invalidate];
            [self endBack];
            _timer = nil;
        }
    }
}

//测试
- (void)test {
    NSArray *btnArr = @[@"缩小",@"放大"];
    for (int i=0; i<2; i++) {
        //宁海按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-autoScaleW(64), self.height/2.0+autoScaleH(54*i)-54, autoScaleW(44), autoScaleW(44))];
        btn.tag = 10000+i;
        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:kBlueColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn.layer setCornerRadius:autoScaleW(10.0)];
        [APPUtil setViewShadowStyle:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

#pragma mark - methods

- (void)btnClick:(UIButton *)btn {

    switch (btn.tag-10000) {
        case 0: //缩小
            zoomLevel--;
            [_mapView setZoomLevel:zoomLevel animated:YES];
            break;
        case 1: //放大
            zoomLevel++;
            [_mapView setZoomLevel:zoomLevel animated:YES];
            break;
        default:
            break;
    }
}

//切换城市处理
- (void)changeCity:(NSDictionary *)areaDic {
    [[AreaInfo share] setAreaInfo:areaDic]; //缓存当前切换的城市
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[AreaInfo share].lat doubleValue], [[AreaInfo share].lng doubleValue]);
    //设置地图中心点
    [_mapView setCenterCoordinate:location animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        zoomLevel = kZoomLevel;
        [_mapView setZoomLevel:zoomLevel animated:YES];
    });
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:location.latitude andLongitude:location.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
    if ([self.delegate respondsToSelector:@selector(locationSuccess:withRadius:)]) {
        [self.delegate locationSuccess:afterLocation withRadius:self.stationRadius];
    }
}

//查看车辆列表
- (void)exchangeCarPile {
    
    if ([self.delegate respondsToSelector:@selector(onClickWithExchangeCarPileEvent)]) {
        [self.delegate onClickWithExchangeCarPileEvent];
    }
}

//查看车辆列表
- (void)showCarList {
    
    if ([self.delegate respondsToSelector:@selector(onClickWithShowCarListEvent)]) {
        [self.delegate onClickWithShowCarListEvent];
    }
}

//扫码用车
- (void)scanUseCar {
    
//    _scanUseCarBtn.backgroundColor = kBlueColor;
    //    [_scanUseCarBtn.layer setMasksToBounds:NO];

    if ([self.delegate respondsToSelector:@selector(onClickWithScanUseCarEvent)]) {
        [self.delegate onClickWithScanUseCarEvent];
    }
}

//刷新数据
- (void)refreshData{
    if ([self.delegate respondsToSelector:@selector(onclickWithRefresh)]) {
        [self.delegate onclickWithRefresh];
    }

}

//定位
- (void)location {
    [self checkLocationOn];
    
    //设置地图中心点
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
    //取得用户大头针视图
    MAAnnotationView *userView = [_mapView viewForAnnotation:_mapView.userLocation];
    [self mapView:_mapView didDeselectAnnotationView:userView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setZoomLevel:zoomLevel animated:YES];
    });
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_userLocation.coordinate.latitude andLongitude:_userLocation.coordinate.longitude];
    //高德转化为GPS
//    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
//    if ([self.delegate respondsToSelector:@selector(locationSuccess:withRadius:)]) {
//        [self.delegate locationSuccess:afterLocation withRadius:self.stationRadius];
//    }
        //开始定位
    [_locationManager startUpdatingLocation];
}

//检测是否有请求地图权限
- (BOOL)checkLocationOn {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        [[TZLocationManager manager] startLocation];
        //定位功能可用
        return YES;
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\"，允许“小灵狗”使用您的位置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alertView show];
        
        return NO;
    }
    return YES;
}

#pragma mark - mapView 代理方法

//定位结果回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    // 定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    // 保存用户经纬度
    [[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.latitude forKey:kLatitude];
    [[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.longitude forKey:kLongitude];
    
    //更新用户位置
    _userLocation = location;
    //设置地图中心点
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
    
    //反地理编码出地理位置
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    regeo.requireExtension =YES;
    //发起逆地理编码
    if (![APPUtil isCurrentCityName]) {
        [_search AMapReGoecodeSearch:regeo];
    }
    
    // 停止定位
    [_locationManager stopUpdatingLocation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setZoomLevel:zoomLevel animated:YES];
    });
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_userLocation.coordinate.latitude andLongitude:_userLocation.coordinate.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
    if ([self.delegate respondsToSelector:@selector(locationSuccess:withRadius:)]) {
        [self.delegate locationSuccess:afterLocation withRadius:self.stationRadius];
    }
    
}

//当位置(经纬度/方向)更新时，会进行定位回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
                //创建大头针
//                if (!_anno) {
//                    [_mapView removeAnnotation:_anno];
//                    _anno = [[CarPointAnnotation alloc] init];
//                    _anno.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//                    //将大头针添加到地图中
//                    [_mapView addAnnotation:_anno];
//                }
        
        //更新用户位置
        _userLocation = userLocation.location;
        
        //保存用户经纬度
        [[NSUserDefaults standardUserDefaults] setDouble:_userLocation.coordinate.latitude forKey:kLatitude];
        [[NSUserDefaults standardUserDefaults] setDouble:_userLocation.coordinate.longitude forKey:kLongitude];
        
        //取得用户大头针视图
        MAAnnotationView *userView = [mapView viewForAnnotation:mapView.userLocation];
        //取方向信息
        CLHeading *userHeading = userLocation.heading;
        //根据方向旋转箭头
        [userView rotateWithHeading:userHeading];
    }
}

#pragma mark - 获取区域ID

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if (response.regeocode !=nil ) {
        
        NSString *province = response.regeocode.addressComponent.province;
        NSString *city = response.regeocode.addressComponent.city;
        NSString *district = response.regeocode.addressComponent.district;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:province forKey:@"province"];
        [dic setObject:city forKey:@"city"];
        [dic setObject:district forKey:@"district"];
        
        if ([self.delegate respondsToSelector:@selector(returnReGeocodeCityResult:)]) {
            [self.delegate returnReGeocodeCityResult:dic];
        }
    }
}

//单击地图
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if ([self.delegate respondsToSelector:@selector(singleTappedMapView)]) {
        [self.delegate singleTappedMapView];
    }
}

//地图区域改变完成
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //    [_mapView removeFromSuperview];
    //    [self.view addSubview:mapView];
}

//地图缩放开始
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    
    if (_stationArr.count==0||isShowCar==YES) {
        return;
    }
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
    self.stationRadius = [NSString stringWithFormat:@"%d",(int)distance/2];
    
    //中心点经纬度
    CGPoint centerPoint = _mapView.center;
    _centerCoordinate = [_mapView convertPoint:centerPoint toCoordinateFromView:_mapView];
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_centerCoordinate.latitude andLongitude:_centerCoordinate.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
    if (!_carAnnoView.selected) {
        if ([self.delegate respondsToSelector:@selector(userMoveMapViewEnd:withRadius:)]) {
            [self.delegate userMoveMapViewEnd:afterLocation withRadius:self.stationRadius];
        }
    }
}

//地图移动结束
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    if (wasUserAction==YES) {
        
//        NSLog(@"用户移动地图结束");
        
        CGPoint centerPoint = _mapView.center;
        
        _centerCoordinate = [_mapView convertPoint:centerPoint toCoordinateFromView:_mapView];
        
        NSLog(@"屏幕中心点经纬度：%f %f",_centerCoordinate.latitude,_centerCoordinate.longitude);
        
        LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_centerCoordinate.latitude andLongitude:_centerCoordinate.longitude];
        //高德转化为GPS
        LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
        
        if ([self.delegate respondsToSelector:@selector(userMoveMapViewEnd:withRadius:)]) {
            [self.delegate userMoveMapViewEnd:afterLocation withRadius:self.stationRadius];
        }
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
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CarAnnotationView *annotationView = (CarAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[CarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        if (_stationArr.count==0&&isShowCar==NO) {
            
            _carAnnoView = annotationView;
            [self selectAnnoAnimation];
            
            isShowCar = YES;
        }
        
        CarPointAnnotation *pointAnno = (CarPointAnnotation *)annotation;
        StationCarItem *item = pointAnno.item;
        item.showType = @"2"; //车辆
        annotationView.item = item;
        
        //设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
//        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(autoScaleW(4), autoScaleW(-24));
       

        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:routePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = [UIImage imageNamed:@"img_BluePoint"];
         [self shakeToShow:poiAnnotationView];
        return poiAnnotationView;
    }
    
    return nil;
}

- (void) shakeToShow:(UIView*)aView

{
//    aView.transform = CGAffineTransformMakeScale(0.05, 0.05);
//
//    [UIView animateWithDuration:1
//                     animations:^{
//                         aView.transform = CGAffineTransformMakeScale(1.2, 1.2);
//                     }completion:^(BOOL finish){
//                         [UIView animateWithDuration:1
//                                          animations:^{
//                                              aView.transform = CGAffineTransformMakeScale(0.9, 0.9);
//                                          }completion:^(BOOL finish){
//                                              [UIView animateWithDuration:1
//                                                               animations:^{
//                                                                   aView.transform = CGAffineTransformMakeScale(1, 1);
//                                                               }completion:^(BOOL finish){
//                                                                   
//                                                               }];
//                                          }];
//                     }];
//    
}


//选中标注触发方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    if (_forbidAnnoClick==YES) {
        return;
    }
    
    if ([view isKindOfClass:[CarAnnotationView class]]) {
        
        //获取站点数据
        CarPointAnnotation *pointAnno = (CarPointAnnotation *)view.annotation;
        StationCarItem *item = pointAnno.item;
        NSLog(@"选中站点ID：%@",item.stationId);
        
        _stationItem = item;
        _carAnnoView = (CarAnnotationView *)view;
        _carAnnoView.loadImgView.hidden = NO;
        [APPUtil runAnimationWithCount:19 name:@"motion_loading00" imageView:_carAnnoView.loadImgView repeatCount:0 animationDuration:0.03]; //开始加载
        
        NSArray *allkeys = [_carSelectedAnnoDic allKeys];
        
        for (int i=0;i<allkeys.count;i++) {
            
            NSString *key = allkeys[i];
            
            if (![key isEqualToString:[NSString stringWithFormat:@"%@;%@",item.stationId,item.vehicleCnt]]) {
                CarAnnotationView *anno = [_carSelectedAnnoDic objectForKey:key];
                [anno.loadImgView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
                anno.loadImgView.hidden = YES;
                
                NSArray *array = [key componentsSeparatedByString:@";"];
                anno.countLab.text = array[1];
            }
        }
        
        [_carSelectedAnnoDic removeAllObjects];
        [_carSelectedAnnoDic setObject:_carAnnoView forKey:[NSString stringWithFormat:@"%@;%@",item.stationId,item.vehicleCnt]];
        
        self.mapView.userInteractionEnabled = NO;
        
#pragma mark - 根据车牌号获取车辆信息
        
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"paging",[AreaInfo share].areaId,@"areaId",item.numberPlate,@"plate",nil];
        
        [[CommonRequest shareRequest] requestWithPost:getCarInfo() isCovered:NO parameters:paramDic success:^(id data) {
            
            NSDictionary *result = data;
            NSArray *carArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
            
            if ([self.delegate respondsToSelector:@selector(selectAnnotationView:andCarArr:)]) {
                [self.delegate selectAnnotationView:item andCarArr:[carArr mutableCopy]];
            }
            
            if ([APPUtil isCurrentCityName]) {
                //路径规划
                _startCoordinate = _userLocation.coordinate;
                _destinationCoordinate = CLLocationCoordinate2DMake([item.gpsLat doubleValue], [item.gpsLng doubleValue]);
                /* 提供备选方案*/
                _navi.multipath = 1;
                /* 出发点. */
                _navi.origin = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude longitude:_startCoordinate.longitude];
                /* 目的地. */
                _navi.destination = [AMapGeoPoint locationWithLatitude:_destinationCoordinate.latitude longitude:_destinationCoordinate.longitude];
                [_search AMapWalkingRouteSearch:_navi];
            } else {
                [self selectAnnoAnimation]; //选中标注动画
                if ([self.delegate respondsToSelector:@selector(routeSearchSuccess)]) {
                    [self.delegate routeSearchSuccess];
                }
            }
            self.mapView.userInteractionEnabled = YES;
        } failure:^(NSString *code) {
            self.mapView.userInteractionEnabled = YES;
            [_carAnnoView.loadImgView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
            _carAnnoView.loadImgView.hidden = YES;
        }];
    }
}

//显示车的路线规划
- (void)showCarRoute:(BookingItem *)item {
    
    //路径规划
    _startCoordinate = _userLocation.coordinate;
    
    //GPS转化为高德
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:[item.gpsLat doubleValue] andLongitude:[item.gpsLng doubleValue]];
    LocationTransform *afterLocation = [beforeLocation transformFromGPSToGD];
    item.gpsLat = [NSString stringWithFormat:@"%f",afterLocation.latitude];
    item.gpsLng = [NSString stringWithFormat:@"%f",afterLocation.longitude];
    
    _destinationCoordinate = CLLocationCoordinate2DMake([item.gpsLat doubleValue], [item.gpsLng doubleValue]);
    /* 提供备选方案*/
    _navi.multipath = 1;
    /* 出发点. */
    _navi.origin = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude longitude:_startCoordinate.longitude];
    /* 目的地. */
    _navi.destination = [AMapGeoPoint locationWithLatitude:_destinationCoordinate.latitude longitude:_destinationCoordinate.longitude];
    [_search AMapWalkingRouteSearch:_navi];
    
    if (_stationArr.count==0) {
        [_mapView removeAnnotations:_carAnnoArr];
        [_carAnnoArr removeAllObjects];
        [_mapView removeAnnotation:_anno];
        _anno = [[CarPointAnnotation alloc] init];
        _anno.coordinate = CLLocationCoordinate2DMake(_destinationCoordinate.latitude,_destinationCoordinate.longitude);
        _anno.item = _stationItem;
        //将大头针添加到地图中
        [_mapView addAnnotation:_anno];
    }
    
}

//移除选中标注
- (void)removeSelectAnno {
    if (_anno) {
        [_mapView removeAnnotation:_anno];
    }
}

//移除所有标注
- (void)removeAllAnnos {
    
    [_mapView removeAnnotations:_carAnnoArr];
    [_carAnnoArr removeAllObjects];
}

//取消选中标注触发方法
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
    if (_forbidAnnoClick==YES) {
        return;
    }
    
//    _carAnnoView.imgView.frame = CGRectMake(autoScaleW(0), autoScaleW(8), autoScaleW(67), autoScaleW(67));
    
//    _carAnnoView.socLab.textColor = kBlueColor;
//    _carAnnoView.imgView.image = [UIImage imageNamed:@"icon_car_marker"];
    
    if ([self.delegate respondsToSelector:@selector(deselectAnnotationView)]) {
        [self.delegate deselectAnnotationView];
    }
}

#pragma mark - AMapSearchDelegate 代理

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil || response.count<=0)
    {
        [_carAnnoView.loadImgView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
        _carAnnoView.loadImgView.hidden = YES;
        
        if ([APPUtil isBlankString:_stationItem.vehicleCnt] || [_stationItem.vehicleCnt isEqualToString:@"0"]) {
            _carAnnoView.countLab.hidden = YES;
        } else {
            _carAnnoView.countLab.hidden = NO;
            _carAnnoView.countLab.text = _stationItem.vehicleCnt;
        }
        
        [self selectAnnoAnimation]; //选中标注动画
        
        if ([self.delegate respondsToSelector:@selector(routeSearchFail)]) {
            [self.delegate routeSearchFail];
        }
        
        return;
    }
    
    //解析response获取路径信息
    _route = response.route;
    
    if (response.count > 0)
    {
        /* 清空地图上已有的路线. */
        [_naviRoute removeFromMapView];
        /* 展示当前路线方案. */
        MANaviAnnotationType type = MANaviAnnotationTypeWalking;
        _naviRoute = [MANaviRoute naviRouteForPath:_route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:_startCoordinate.latitude longitude:_startCoordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:_destinationCoordinate.latitude longitude:_destinationCoordinate.longitude]];
        [_naviRoute addToMapView:_mapView];
        
        [self selectAnnoAnimation]; //选中标注动画
        
        if ([self.delegate respondsToSelector:@selector(routeSearchSuccess)]) {
            [self.delegate routeSearchSuccess];
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth = autoScaleW(6);
        polylineRenderer.strokeColor = UIColorFromARGB(0x008FFF,0.7);
        polylineRenderer.lineDash = NO;
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = autoScaleW(6);
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.strokeColor = UIColorFromARGB(0x008FFF,0.7);
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 6;
        polylineRenderer.strokeColors = [_naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

//设置百米精确度
-(void)setLocationManagerForHundredMeters{
    
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //2.定位超时时间，最低2s，此处设置为2s
    _locationManager.locationTimeout =2;
    
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    _locationManager.reGeocodeTimeout = 2;
    
    //4.设定定位的最小更新距离。默认为kCLDistanceFilterNone
//    _locationManager.distanceFilter = 5;
}

//设置十米精确度
-(void)setLocationManagerForAccuracyBest{
    
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //2定位超时时间，最低2s，此处设置为10s
    _locationManager.locationTimeout =10;
    
    //3.逆地理请求超时时间，最低2s，此处设置为10s
    _locationManager.reGeocodeTimeout = 10;
    
    //4.设定定位的最小更新距离。默认为kCLDistanceFilterNone
//    _locationManager.distanceFilter = 5;
}

- (void)setStationItem:(StationCarItem *)stationItem {
    
    if (_stationItem != stationItem) {
        _stationItem = stationItem;
    }
    
    isShowCar = NO;
}

- (void)setStationArr:(NSMutableArray *)stationArr {
    
    if (_stationArr != stationArr) {
        _stationArr = stationArr;
    }
    
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
        if (i==0&&_isSearchFlag) {
            [_mapView setCenterCoordinate:anno.coordinate animated:YES];
        }
    }
}

//选择标注动画
- (void)selectAnnoAnimation {
    
    _carAnnoView.socLab.textColor = [UIColor whiteColor];
//    _carAnnoView.imgView.image = [UIImage imageNamed:@"icon_car_marker_selected"];
    _carAnnoView.loadImgView.hidden = YES;
    [_carAnnoView.loadImgView stopAnimating]; //停止加载
    /*创建弹性动画
     damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
     velocity:弹性复位的速度
     */
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        _carAnnoView.imgView.frame = CGRectMake(autoScaleW(0), autoScaleW(8), autoScaleW(67), autoScaleW(67));
    } completion:nil];
}

- (void)mapRouteLarge:(NSMutableArray *)array {
    
    if (array.count>0) {
        [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:_naviRoute.routePolylines] edgePadding:UIEdgeInsetsMake(autoScaleW(80), autoScaleW(50), autoScaleH(360), autoScaleW(50)) animated:YES];
    } else {
        [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:_naviRoute.routePolylines] edgePadding:UIEdgeInsetsMake(autoScaleW(80), autoScaleW(50), autoScaleH(150), autoScaleW(50)) animated:YES];
    }
}




- (void)setDelegate {
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _locationManager.delegate = self;
}

- (void)clearDelegate {
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    _locationManager.delegate = nil;
}

- (void)annoDidClickedFromCarList:(StationCarItem *)car {

    BOOL isFind = NO;
    
    for (MAPointAnnotation *anno in _mapView.annotations) {
        if ([anno isKindOfClass:[CarPointAnnotation class]]) {
            CarPointAnnotation *carAnno = (CarPointAnnotation *)anno;
            if ([car.numberPlate isEqual:carAnno.item.numberPlate]) {
                CarAnnotationView *view = (CarAnnotationView *)[_mapView viewForAnnotation:carAnno];
                if (view) {
                    [self mapView:_mapView didSelectAnnotationView:view];
                    isFind = YES;
                }

                break;
            }
        }
    }
    
    if (!isFind) {
        if ([self.delegate respondsToSelector:@selector(deselectAnnotationView)]) {
            [self.delegate deselectAnnotationView];
        }
    }
}

@end
