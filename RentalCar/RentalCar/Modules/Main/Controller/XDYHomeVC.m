//
//  XDYHomeVC.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/7.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "XDYHomeVC.h"
#import "XDYHomeService.h"
#import "LocationTransform.h"
#import "HomeMapView.h"
#import "LeftMenuView.h"
#import "NavBarView.h"
#import "CarShowView.h"
#import "CarPopView.h"
#import "BookingTimerView.h"
#import "ScanUnLockView.h"
#import "walletViewController.h"
#import "XDYLoginController.h"
#import "XDYScanVC.h"
#import "BaseNavController.h"
#import "AboutViewController.h"
#import "ReturnCarStationVC.h"
#import "ClusterTestVC.h"
#import "MyTravelViewController.h"
#import "CarRunningView.h"
#import "CarReturnConfirmView.h"
#import "CarFeeDetailView.h"
#import "PersonCenterViewController.h"
#import "BackProtocol.h"
#import "BaseWebController.h"
#import "NSTimer+EocBlockSupports.h"
#import "SelectCityVC.h"

#import "OnlineCarListVC.h"

typedef NS_ENUM(NSInteger,CarPopViewType){
    _Type_BookingCarView_ = 1000,
    _Type_CancelBookingView_,
    _Type_UnLockCarView_,
    _Type_CarPswView_,
};

@interface XDYHomeVC ()<ObserverServiceDelegate,HomeMapDelegate,LeftMenuDelegate, NavBarDelegate,CarShowDelegate,BookingTimerDelegate,CarReturnConfirmDelegate, ScanUnLockDelegate,CarRunningDelegate,BackProtocol>
{
    XDYHomeService *_homeService;
    LeftMenuView *_leftMenuView; //侧滑菜单
    NavBarView *_navBarView; //导航条
    HomeMapView *_homeMapView; //高德地图
    NSMutableArray *_carScanUseArr; //扫码租车中车辆
    NSMutableArray *_carBookingArr; //预约中车辆
    NSString *_carTimerFlag; //1、预约计时 2、扫码计时
    NSMutableArray *_carLeaseArr; //行程中车辆
    ScanCarInfoItem *_currentScanCarInfoItem; //当前扫码用车信息
    int authStateCount;
    
    LocationTransform *currentTransform;
    // 倒计时
    NSTimer *showTimer;
    UIBackgroundTaskIdentifier taskID;
    
    int useCarFlag; //1、预约用车 2、扫码用车
    BOOL hasCityAreaData;;//是否请求到城市区域数据
    
    NSString *rentPsw;
    
    ENUMHomeScanBtnState homeScanBtnState;
    BOOL hiddenCarRunningViewFlag;// 判断行程中页面 是显示或者隐藏
    NSString *_currentCityName; //当前定位城市名字
    BOOL allowLoadStationCar; //只有开通分时的城市才能加载网点/车辆
    
    NSString *carStatus;
    NSDictionary *carStatusInfoDic;
    
    BOOL isSearchFlag;//是否是搜索请求到的数据

    NSString *currentBookCarPlate;//当前预约中车牌号
}

//懒加载
@property (nonatomic,strong) CarShowView *carShowView; //车辆展示
@property (nonatomic,strong) BookingTimerView *bookingTimerView; //预约倒计时
@property (nonatomic,strong) ScanUnLockView *scanUnLockView; //扫码开锁用车
@property (nonatomic,strong) CarRunningView *carRunningView; //行程中
@property (nonatomic,strong) CarReturnConfirmView *carReturnConfirmView; //还车确认

@end

@implementation XDYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeService = [[XDYHomeService alloc] init];
    _homeService.serviceDelegate = self;
    
    //导航条
    _navBarView = [[NavBarView alloc] initWithFrame:CGRectZero withController:self];
    _navBarView.delegate = self;
    
    //高德地图
    _homeMapView = [[HomeMapView alloc] init];
    _homeMapView.delegate = self;
    [self.view addSubview:_homeMapView];
    
    if ([APPUtil isLoginWithJump:NO]) {
        [_homeService requestUserAuthState]; //验证会员状态
        [_homeService requestCarInBookingWithService]; //获取已预约车辆
        [_homeService requestCarInSearchInfoWithService]; //获取扫码租车车辆
        [_homeService requestCarInLeaseWithService:@{}]; //获取行程中车辆
    }
    //[_homeService requestgetServicePhoneWithService];//获取客服电话
    [_homeService requestgetAppVersionWithService];//获取版本信息
    
    _navBarView.loadingImgView.hidden = NO;
    [APPUtil runAnimationWithCount:34 name:@"motion_DataLoading00" imageView:_navBarView.loadingImgView repeatCount:0 animationDuration:0.03]; //开始加载
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucc) name:kLoginSuccNotification object:nil]; //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucc) name:kLogoutSuccNotification object:nil]; //注销成功
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kPostUserInfoNotification object:nil]; //会员成功
    
    //侧滑菜单
    _leftMenuView = [[LeftMenuView alloc] init];
    _leftMenuView.delegate = self;
    
    carStatusInfoDic = @{@"carType":@"3",@"carStatus":@"7"};
    currentBookCarPlate = @""; 
}

//登录成功
- (void)loginSucc {
    [StatisticsClass eventId:DL02];
    [_homeMapView.locationManager startUpdatingLocation]; //重新定位
    [_homeService requestCarInBookingWithService]; //获取已预约车辆
    [_homeService requestCarInSearchInfoWithService]; //获取扫码租车车辆
    [_homeService requestCarInLeaseWithService:@{}]; //获取行程中车辆
    [_homeService requestUserAuthState]; //验证会员状态
}

//注销成功
- (void)logoutSucc {
    [StatisticsClass eventId:TC01];
    _navBarView.leftBtn.image = [UIImage imageNamed:@"img_avatar_logout"];
//    [self hideTipAnimation];
    [_homeMapView.locationManager startUpdatingLocation]; //重新定位
    [self hideCarRunningAnimation]; //隐藏行程中页面
    [self hideCarTimerAnimation]; //隐藏预约计时页面
    [self hideCarAnimation];
    [self hideScanCarAnimation];
    [self hideCarTimerAnimation];
    [self hideCarReturnConfirmAnimation];
    //查看行程按钮 恢复成查看行程
    hiddenCarRunningViewFlag = NO;//变量初始化
    homeScanBtnState = ENUMHomeScanBtnStateNormal;
    [_homeMapView.scanUseCarBtn setImage:[UIImage imageNamed:@"btn_scanUseCar"] forState:UIControlStateNormal];
    
    //判断用户是会员还是运维人员
    carStatus = @"0";
    [_leftMenuView refreshLeftMenuView];//是否显示运维
    [self getData]; //重新获取车辆信息
    
}

//无网络
- (void)netWorkDisappear {
    [self showErrorNetWorkView];
}

//有网络
- (void)netWorkAppear {
    [self hideErrorNetWorkView];
}

- (void)getUserInfo{
    [_homeService requestUserAuthState];
}


#pragma mark - get data

//获取站点
- (void)getStationData:(LocationTransform *)location andRadius:(NSString *)radius {
    
    if (allowLoadStationCar==NO) {
        return;
    }
    
    NSString *areaId = [AreaInfo share].areaId;
    
    if (_bookingTimerView.alpha==1) {
        return;
    }
    
    if (_homeMapView.forbidAnnoClick==YES) {
        return;
    }
    
    if (location.latitude==0) {
        return;
    }
    
    if ([APPUtil isBlankString:radius]||[radius isEqualToString:@"0"]) {
        return;
    }
    
    if ([APPUtil isBlankString:areaId]) {
        return;
    }
    
    
    
    NSString  *defaultDistance = @"50000000";
    if ([areaId isEqualToString:@"2"]) { //宁海1000，其它距离5000
        defaultDistance = @"10000000";
    }
//    radius = [];
    [APPUtil runAnimationWithCount:19 name:@"motion_refresh00" imageView:_homeMapView.refreshBtn.imageView repeatCount:1 animationDuration:0.005]; //开始加载
    //获取站点及可租车辆数量请求
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",@"paging",
                                areaId,@"areaId",
                                [NSString stringWithFormat:@"%f",location.longitude],@"gpsLng",
                                [NSString stringWithFormat:@"%f",location.latitude],@"gpsLat",
                                @"0",@"type", //0 显示全部车
                                defaultDistance,@"distance",nil];
    
    [paramDic addEntriesFromDictionary:carStatusInfoDic];
    [_homeService requestCarForLeaseWithService:paramDic];
}

- (void)getData {
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_homeMapView.userLocation.coordinate.latitude andLongitude:_homeMapView.userLocation.coordinate.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
    currentTransform = afterLocation;
    [self getStationData:afterLocation andRadius:_homeMapView.stationRadius];
}

#pragma mark - init view

- (CarShowView *)carShowView {
    if (!_carShowView) {
        _carShowView = [[CarShowView alloc] init];
        _carShowView.delegate = self;
    }
    return _carShowView;
}

- (BookingTimerView *)bookingTimerView {
    if (!_bookingTimerView) {
        _bookingTimerView = [[BookingTimerView alloc] init];
        _bookingTimerView.delegate = self;
        _bookingTimerView.alpha = 0;
    }
    return _bookingTimerView;
}

- (ScanUnLockView *)scanUnLockView {
    if (!_scanUnLockView) {
        _scanUnLockView = [[ScanUnLockView alloc] init];
        _scanUnLockView.delegate = self;
    }
    return _scanUnLockView;
}

- (CarRunningView *)carRunningView {
    if (!_carRunningView) {
        _carRunningView = [[CarRunningView alloc] init];
        _carRunningView.delegate = self;
        _carRunningView.alpha = 0;
    }
    return _carRunningView;
}

- (CarReturnConfirmView *)carReturnConfirmView {
    if (!_carReturnConfirmView) {
        _carReturnConfirmView = [[CarReturnConfirmView alloc] init];
        _carReturnConfirmView.delegate = self;
    }
    return _carReturnConfirmView;
}

#pragma mark - methods

- (void)resetAuthStateCount {
    authStateCount = 0;
}

- (BOOL)isAuthStateCountOverThree {
    if (++authStateCount<3) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - ObserverServiceDelegate 接口数据处理代理

- (void)onSuccess:(id)data withType:(ActionType)type{
    
    switch (type) {
            
#pragma mark - 获取版本信息
            
        case _REQUEST_getAppVersion_:
        {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            debugLog(@"%@",data);
            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            debugLog(@"当前应用软件版本:%@",appCurVersion);
            NSString *explainText =  [data objectForKey:@"explain"];//更新内容
            if ([explainText isEqualToString:@""]) {
                explainText =  @"发现新版本，是否马上升级？";
            }
            // [data objectForKey:@"forceUpgrade"];//强制升级
            // [data objectForKey:@"recomendUpgrade"];//非强制升级
            // [data objectForKey:@"downloadUrl"];返回的url
              NSString *versionStr = [NSString stringWithFormat:@"发现新版本 %@",[data objectForKey:@"currVersion"]];
            if ([APPUtil isBlankString:[data objectForKey:@"currVersion"]]) {
                versionStr = @"发现新版本！";
            }
            if ([[data objectForKey:@"forceUpgrade"] intValue] == 1) {
                //强制升级，要升级
                XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:explainText leftButtonTitle:@"" rightButtonTitle:@"App Store" TopButtonTitle:versionStr];
                alert.dontDissmiss = YES;
                //跳转
                alert.doneBlock = ^()
                {
                    //跳转苹果链接
                    [self pushAppStore];
                    
                };
            }else if ([[data objectForKey:@"forceUpgrade"] intValue] == 2){//非强制升级要升级
              
                XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:explainText leftButtonTitle:@"以后再说" rightButtonTitle:@"App Store" TopButtonTitle:versionStr];
                //跳转
                alert.doneBlock = ^()
                {
                    //跳转苹果链接
                    [self pushAppStore];
                };
            }else{
                //不升级
            }
        }
            
#pragma mark - 获取客服电话
            
        case _REQUEST_GeterSvicePhone_:
        {
            //            NSDictionary *resultDic = [data objectForKey:@"result"];
            //
            //            debugLog(@"%@",resultDic);
            //            if (ServicePhoneNum ==NULL) {
            //                    ServicePhoneNum = [resultDic objectForKey:@"phone"];
            //
            //            }
            //
            //            debugLog(@"%@",ServicePhoneNum);
            //暂时写死
            //            ServicePhoneNum = @"";
        }
            break;
            
#pragma mark - 根据城市(省市区)获取对应的区域
            
        case _REQUEST_CityToArea_:
        {
            hasCityAreaData = YES;
            NSDictionary *dic = (NSDictionary *)data;
            
            NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:dic[@"areaId"],@"areaId",dic[@"areaname"],@"areaName",dic[@"areaStatus"],@"areaStatus",@"0",@"deposit",@"0",@"lng",@"0",@"lat", nil];
            [[AreaInfo share] setAreaInfo:areaDic]; //用户所选区域默认是用户所在区域
            
            NSString *areaName = [AreaInfo share].areaName;
            if (![APPUtil isBlankString:areaName]) {
                [CacherUtil saveCacher:kLocationAreaName withValue:areaName];
            } else {
                [CacherUtil saveCacher:kLocationAreaName withValue:_currentCityName];
            }
            [self setAreaName:[CacherUtil getCacherWithKey:kLocationAreaName]]; //设置当前区域名称，并缓存当前区域名称
            
            _homeMapView.stationRadius = @"1000"; //设置默认显示范围1000米
            
            NSString *statusStr = [AreaInfo share].areaStatus;
            [self showAreaStatus:statusStr]; //显示区域状态红条提示
            
            [self getData];
        }
            break;
            
#pragma mark - 根据区域获取可租车辆列表
#pragma mark - 根据区域获取网点
#pragma mark - 根据区域模糊搜索车辆信息
            
        case _REQUEST_STATIONFORLEASE_:
        case _REQUEST_CARFORLEASE_:
        case _REQUEST_SearchCarInfo:
        {
            _homeMapView.isSearchFlag = isSearchFlag;
            [_homeMapView.locationBtn performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
            _homeMapView.locationBtn.image = [UIImage imageNamed:@"icon_Location"];
            [_homeMapView.refreshBtn.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
            [_homeMapView.refreshBtn setImage:[UIImage imageNamed:@"motion_refresh0000"] forState:UIControlStateNormal];
            
            _homeMapView.stationArr = [data mutableCopy];
        }
            break;
            
#pragma mark - 扫码租车中
            
        case _REQUEST_CarInSearchInfo_:
        {
            _carScanUseArr = [data mutableCopy];
            _carTimerFlag = @"2";
            if (_carScanUseArr.count>0) {
                [self showCarTimerAnimation];
                
                [_homeMapView.stationArr removeAllObjects];
                [_homeMapView removeAllAnnos];
                BookingItem *item = _carScanUseArr[0];
                StationCarItem *stationItem = [[StationCarItem alloc] init];
                stationItem.gpsLat = item.gpsLat;
                stationItem.gpsLng = item.gpsLng;
                stationItem.addr = item.addr;
                _homeMapView.stationItem = stationItem;
            }
        }
            break;
            
#pragma mark - 预约中
            
        case _REQUEST_CarInBooking_:
        {
            _carBookingArr = [data mutableCopy];
            _carTimerFlag = @"1";
            if (_carBookingArr.count>0) {
                [self showCarTimerAnimation];
                
                [_homeMapView.stationArr removeAllObjects];
                [_homeMapView removeAllAnnos];
                BookingItem *item = _carBookingArr[0];
                StationCarItem *stationItem = [[StationCarItem alloc] init];
                stationItem.gpsLat = item.gpsLat;
                stationItem.gpsLng = item.gpsLng;
                stationItem.addr = item.addr;
                stationItem.soc = item.soc;
                _homeMapView.stationItem = stationItem;
                currentBookCarPlate = item.numberPlate;//获取预约中的车牌号
            }
        }
            break;
            
#pragma mark - 行程中
            
        case _REQUEST_CarInLease_:
        {
            _carLeaseArr = [data mutableCopy];
            if (_carLeaseArr.count>0) {
                BOOL hasCarNum = NO;
                for (BookingItem *item in _carLeaseArr) {
                    NSString *carNum = item.numberPlate;
                    if ([carNum isEqualToString:currentBookCarPlate]) {
                        hasCarNum = YES;
                        break;
                    }
                }
                if (hasCarNum) {
                    [self hideCarTimerAnimation];
                    [self hideScanCarAnimation];
                    [self hideCarAnimation];
                    if (!hiddenCarRunningViewFlag) {
                        [self showCarRunningAnimation];
                    }
                    CarPopView *popView = [self.view viewWithTag:_Type_CarPswView_];
                    [popView closeAction];
                }
                
                
            } else { //车机还车
                
                if (_carRunningView.alpha==1||_carReturnConfirmView.alpha==1) {
                    [APPUtil showToast:@"还车成功"];
                    
                    [_homeMapView.mapView setZoomLevel:17];
                    [self getStationData:currentTransform andRadius:_homeMapView.stationRadius];
                    [self hideCarRunningAnimation];
                    [self hideCarReturnConfirmAnimation];
                }
                //恢复扫码按钮
                hiddenCarRunningViewFlag = NO;//初始化
                homeScanBtnState = ENUMHomeScanBtnStateNormal;
                [_homeMapView.scanUseCarBtn setImage:[UIImage imageNamed:@"btn_scanUseCar"] forState:UIControlStateNormal];
            }
        }
            break;
            
#pragma mark - 取消预约
            
        case _REQUEST_CancelBookingCar_:
        {
            [TipUtil showSuccTip:@"取消预约成功"];
            [self hideCarTimerAnimation];
            [self.bookingTimerView endTimer]; //结束定时器
            // 结束行程中定时器
            if (showTimer) {
                [showTimer invalidate];
                [self endBack];
                showTimer = nil;
            }
            [_homeMapView.mapView removeAnnotation:_homeMapView.anno];
            _homeMapView.forbidAnnoClick = NO;
            [self getStationData:currentTransform andRadius:_homeMapView.stationRadius];
        }
            break;
            
#pragma mark - 扫码租车获取车辆信息
            
        case _REQUEST_SearchCarForLease_:
        {
            _currentScanCarInfoItem = data;
            NSString *rentStatus = _currentScanCarInfoItem.rentStatus;
            if ([rentStatus isEqualToString:@"1"]) {
                [self showScanCarAnimation];
            }
            
            if ([rentStatus isEqualToString:@"2"]) {
                [self showCarTimerAnimation];
            }
            
            if ([rentStatus isEqualToString:@"3"]) {
                [self showCarRunningAnimation];
            }
            
            if ([rentStatus isEqualToString:@"4"]) {
                
                [APPUtil showToast:_currentScanCarInfoItem.nonRentReason];
            }
        }
            break;
            
#pragma mark - 获取会员状态
        case _REQUEST_AUTHSTATE_OK://获取会员信息完成
        {
            //判断用户是会员还是运维人员
            [_leftMenuView refreshLeftMenuView];//是否显示运维
            if (![APPUtil isLoginWithJump:NO]) {
                _navBarView.leftBtn.image = [UIImage imageNamed:@"img_avatar_logout"];
            } else {
                UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"headImg"];
                if (cachedImage == nil) {
                    [_navBarView.leftBtn sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].headImgUrl] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
                }else{
                    [_navBarView.leftBtn setImage:cachedImage];
                }
            }
        }
            break;
            
#pragma mark - 获取租车密码
            
        case _REQUEST_GetRentPwd_:
        {
            [self showRentPswView];
        }
            
        default:
            break;
    }
    
    
}

- (void)showRentPswView{
    //车机密码弹框
    CarPopView *carPswView = [[CarPopView alloc] initWithImageName:@"img_password" contentText:[NSString stringWithFormat:@"输入密码 %@",rentPsw] descText:@"请在车内中控屏上输入6位密码，以解锁车辆并开始计费。" range:NSMakeRange(0, 0) leftButtonTitle:@"" rightButtonTitle:@"我知道了"];
    carPswView.tag = _Type_CarPswView_;
    [self.view addSubview:carPswView];
    
    //[carPswView startTimer]; //10s倒计时
    
    __weak CarPopView *popSelf = carPswView;
    carPswView.confirmBlock = ^(){ //我知道了
        
        [popSelf closeAction];
        
        if (useCarFlag==1) { //预约用车
            if (self.bookingTimerView.flag==1) {
                [self hideCarTimerAnimation];
                [_homeService requestCarInBookingWithService]; //获取已预约车辆
            }
            useCarFlag = 0;
        }
        
        if (useCarFlag==2) { //扫码、输入车牌号用车
            [self hideScanCarAnimation];
            [_homeService requestCarInSearchInfoWithService]; //获取扫码租车车辆
            useCarFlag = 0;
        }
    };
    
}

- (void)onFailureWithType:(ActionType)type{
    
    switch (type) {
        case _REQUEST_CityToArea_:
        {
            [CacherUtil saveCacher:kLocationAreaName withValue:_currentCityName];
            [self setAreaName:_currentCityName];
        }
            break;
        case _REQUEST_STATIONFORLEASE_:
        {
            
        }
            break;
        case _REQUEST_AUTHSTATE_:
        {
            if ([self isAuthStateCountOverThree]) {
                [_homeService requestUserAuthState];
            }
        }
            break;
            
        default:
            break;
    }
    [_homeMapView.refreshBtn.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
    [_homeMapView.refreshBtn setImage:[UIImage imageNamed:@"motion_refresh0000"] forState:UIControlStateNormal];
}

#pragma mark - 每隔1分钟上传一次地理位置给后台[0、行程中正常上报；1、开门上报；2、关门上报；3、结束行程上报]
- (void)uploadLatLng:(BookingItem *)item andAction:(NSString *)action {
    
    double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kLongitude];
    double latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kLatitude];
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:latitude andLongitude:longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromGDToGPS];
    
    if (longitude>0 && latitude>0) {
        
//        NSLog(@"上传定位信息到后台");
        //上传定位信息到后台
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  action,@"action",
                                  item.rentNum,@"rentNum",
                                  [NSString stringWithFormat:@"%f",afterLocation.longitude],@"gpsLng",
                                  [NSString stringWithFormat:@"%f",afterLocation.latitude],@"gpsLat",nil];
        [_homeService requestUploadLatLngWithService:paramDic];
    }
}

#pragma mark - BackProtocol 扫码回调代理

- (void)backAction:(NSString *)str andFlag:(NSInteger)flag {
    
//    NSLog(@"扫码结果：%@",str);
    
    NSDictionary *paramDic;
    
    if (flag == 1) { //车架号
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"vin",nil];
    } else if (flag == 2) { //车牌号
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[APPUtil urlEncoding:str],@"numberPlate",nil];
    } else if (flag == 3) { //code码
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"code",nil];
    }
    [_homeService requestSearchCarForLeaseWithService:paramDic];
}

//选择完城市回调
- (void)selectCity:(NSDictionary *)dic {
    [_homeMapView changeCity:dic];
    
    [self setAreaName:[AreaInfo share].areaName];
    
    [self showAreaStatus:[AreaInfo share].areaStatus];
}

//显示区域状态提示
- (void)showAreaStatus:(NSString *)statusStr {
     allowLoadStationCar = YES;
    if ([statusStr isEqualToString:@"1"]) { //开通
        
        NSString *areaId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAreaID];
        if ([areaId isEqualToString:[AreaInfo share].areaId]) {
            allowLoadStationCar = YES;
            [self hideTipAnimation];
        } else { //已开通但与会员注册区域不一致
            allowLoadStationCar = YES;
            [self showTipAnimation:@"暂未提供注册地外跨区域用车服务。"];
        }
    }
    
    if ([statusStr isEqualToString:@"2"]) { //未开通
        allowLoadStationCar = NO;
        [self showTipAnimation:@"当前城市用车服务暂未开通。敬请期待！"];
    }
    
    if ([statusStr isEqualToString:@"3"]) { //已开通但与会员注册区域不一致
        allowLoadStationCar = YES;
        [self showTipAnimation:@"暂未提供注册地外跨区域用车服务。"];
    }
    
    if ([statusStr isEqualToString:@"4"]) { //宁波、长沙、青岛、天津、山东分享走中华联合保险区
        if ([[AreaInfo share].areaName isEqualToString:@"宁波"]) {
            allowLoadStationCar = YES;
        } else {
            allowLoadStationCar = NO;
        }
        [self showTipAnimation:@"本地区暂不提供时长低于一周的租赁服务。"];
    }
}

#pragma mark - LeftMenuDelegate 侧滑栏代理

//隐藏侧滑菜单
- (void)onClickWithHideLeftMenuEvent {
    
    _leftMenuView.leftViewShow = 0;
    [self prefersStatusBarHidden];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        _leftMenuView.leftView.left = -kScreenWidth;
        _leftMenuView.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _leftMenuView.leftView.hidden = YES;
        _leftMenuView.shadowView.hidden = YES;
    }];
}

//头像跳转方法
- (void)onClickWithHeaderViewEvent {
    [StatisticsClass eventId:@"CD01"];
    [self performSelector:@selector(pushVer) withObject:nil afterDelay:0.4];
}

-(void)pushVer{
    
    //    XLDVerificationCViewController *vrf = [[XLDVerificationCViewController alloc]init];
    //    [self.navigationController pushViewController:vrf animated:YES];
    
    // 验证用户是否登录
    if (![APPUtil isLoginWithJump:YES]) {
        return;
    }
    
    PersonCenterViewController *Center = [[PersonCenterViewController alloc]init];
    [self.navigationController pushViewController:Center animated:YES];
}

-(void)onDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) { //钱包
        
        // 验证用户是否登录
        if (![APPUtil isLoginWithJump:YES]) {
            return;
        }
        [StatisticsClass eventId:CD02];
        walletViewController *wallet = [[walletViewController alloc]init];
        [self.navigationController pushViewController:wallet animated:YES];
    }
    
    if (indexPath.row == 1) { //行程
        
        // 验证用户是否登录
        if (![APPUtil isLoginWithJump:YES]) {
            return;
        }
        [StatisticsClass eventId:CD04];
        MyTravelViewController *mytravelVc = [[MyTravelViewController alloc]init];
        mytravelVc.getSelectRentNum = ^(NSString *rentNum) {
            NSLog(@"%@",rentNum);
            [_homeService requestCarInLeaseWithService:@{@"rentNum":rentNum}]; //获取行程中车辆

        };
        [self.navigationController pushViewController:mytravelVc animated:YES];
    }
    
    if (indexPath.row == 2) { //网点
        
        // 验证用户是否登录
        if (![APPUtil isLoginWithJump:YES]) {
            return;
        }
        
        ReturnCarStationVC *vc = [[ReturnCarStationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 3) { //客服
        [StatisticsClass eventId:CD05];
        
        [self PalyServicePhoneNum];
    }
    
    if (indexPath.row == 4) { //关于
        [StatisticsClass eventId:CD06];
        AboutViewController *myAboutVc = [[AboutViewController alloc]init];
        myAboutVc.aboutServicePhoneNum = ServicePhone;
        [self.navigationController pushViewController:myAboutVc animated:YES];
    }
    
    [self onClickWithHideLeftMenuEvent];
}

#pragma mark - NavBarDelegate 导航条代理

//显示侧滑菜单
- (void)onClickWithShowLeftMenuEvent {
    
    [StatisticsClass eventId:SY01];
    
    _leftMenuView.leftView.right = 0;
    _leftMenuView.leftView.hidden = NO;
    _leftMenuView.shadowView.hidden = NO;
    _leftMenuView.isAnimationOn = YES;
    _leftMenuView.leftViewShow = 1;
    [self prefersStatusBarHidden];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        _leftMenuView.leftView.left = 0;
        _leftMenuView.shadowView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _leftMenuView.isAnimationOn = NO;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_leftMenuView.leftTableView reloadData];
        [_leftMenuView.headView setNeedsLayout];
    });
}

//选择城市
- (void)onClickWithSelectCityEvent {
    
    [StatisticsClass eventId:SY02];
    if (!_navBarView.cityBtn.hidden) {
        // 验证用户是否登录
        if (![APPUtil isLoginWithJump:YES]) {
            return;
        }
        SelectCityVC *vc = [[SelectCityVC alloc] init];
        vc.backDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onClickWithSearchCarInfo:(NSString *)carNum {
    isSearchFlag = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (carNum.length>10) {
        [dic setObject:carNum forKey:@"vin"];
    }else{
        if(carNum.length<4){
            [APPUtil showToast:@"车牌号位数不能小于4位"];
            return;
        }
        [dic setObject:carNum forKey:@"plate"];
    }
    
    [dic setObject:@"2" forKey:@"paging"];
    [dic setObject:[AreaInfo share].areaId forKey:@"areaId"];
    [_homeService requestSearchCarInfoWithService:dic];
    [APPUtil runAnimationWithCount:19 name:@"motion_refresh00" imageView:_homeMapView.refreshBtn.imageView repeatCount:0 animationDuration:0.03]; //开始加载
}


#pragma mark - HomeMapDelegate 高德地图代理

//定位成功回调
- (void)locationSuccess:(LocationTransform *)afterLocation withRadius:(NSString *)radius {
    isSearchFlag = NO;
    currentTransform = afterLocation;
    [self getStationData:afterLocation andRadius:radius];
    if (self.carShowView.alpha==1) {
        //隐藏选择车辆
        [self hideCarAnimation];
    }
}

- (void)onclickWithRefresh{
    isSearchFlag = NO;
    [APPUtil runAnimationWithCount:19 name:@"motion_refresh00" imageView:_homeMapView.refreshBtn.imageView repeatCount:0 animationDuration:0.03]; //开始加载
    [self getData];
}

//定位反地理编码城市结果回调
- (void)returnReGeocodeCityResult:(NSMutableDictionary *)dic {
    
    [_navBarView.loadingImgView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
    _navBarView.loadingImgView.hidden = YES;
    
    //定位的当前城市
    _currentCityName = dic[@"district"];

    //根据城市获取区域ID
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"province"],@"province",
                                  dic[@"city"],@"city",
                                  dic[@"district"],@"county",
                                  nil];
    [_homeService requestCityToAreaWithService:paramDic];
}

#pragma mark - 设置区域名称
- (void)setAreaName:(NSString *)areaName {
    if (![APPUtil isBlankString:areaName]) {
        _navBarView.cityBtn.hidden = NO;
        if (areaName.length>5) {
            NSString *firstStr = [areaName substringWithRange:NSMakeRange(0, 2)];
            NSString *lastStr = [areaName substringWithRange:NSMakeRange(areaName.length-2, 2)];
            areaName = [NSString stringWithFormat:@"%@...%@",firstStr,lastStr];
        }
        [_navBarView.cityBtn setTitle:areaName forState:UIControlStateNormal];
        CGFloat cityWidth = [APPUtil getTextWidth:areaName font:[UIFont systemFontOfSize:12] forHeight:15];
        [_navBarView.cityBtn setImageEdgeInsets:UIEdgeInsetsMake(-2.0, cityWidth+12, 0.0, 0)];
    } else {
        _navBarView.cityBtn.hidden = YES;
    }
}

//显示还车点
- (void)onClickWithExchangeCarPileEvent {
    
    ReturnCarStationVC *vc = [[ReturnCarStationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//查看车辆列表
- (void)onClickWithShowCarListEvent {
    
    if (currentTransform.latitude==0) {
        return;
    }
    
    if ([APPUtil isBlankString:_homeMapView.stationRadius]||[_homeMapView.stationRadius isEqualToString:@"0"]) {
        return;
    }
    
    OnlineCarListVC *vc = [[OnlineCarListVC alloc] initWithLocation:currentTransform];
    vc.carBlock = ^(StationCarItem *carItem) {
        [_homeMapView annoDidClickedFromCarList:carItem];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

//扫码用车
- (void)onClickWithScanUseCarEvent {
    
    [StatisticsClass eventId:SY03];
    
    switch (homeScanBtnState) {
        case ENUMHomeScanBtnStateNormal: //进入扫描页面
        {
            // 验证用户是否登录
            if (![APPUtil isLoginWithJump:YES]) {
                return;
            }
            
            // 验证会员账号状态
            if (![APPUtil isAccountStatePass:self]) { //没开通
                return;
            }
            
            if ([APPUtil isCameraPermissionOn]) {
                // 扫描页
                XDYScanVC *scanVC = [[XDYScanVC alloc] init];
                scanVC.backDelegate = self;
                BaseNavController *nc = [[BaseNavController alloc] initWithRootViewController:scanVC];
                scanVC.modalTransitionStyle = 0;
                [self presentViewController:nc animated:YES completion:nil];
            }
        }
            break;
            case ENUMHomeScanBtnShowLease://查看行程
        {
            hiddenCarRunningViewFlag = NO;
            [self showCarRunningAnimation];//显示行程中
        }
            break;
        default:
            break;
    }
}

//单击地图
- (void)singleTappedMapView {
    
    [self.view endEditing:YES];
    
    if (self.carShowView.alpha==1) {
        //隐藏选择车辆
        [self hideCarAnimation];
    }
}

//用户移动地图结束
- (void)userMoveMapViewEnd:(LocationTransform *)afterLocation withRadius:(NSString *)radius {
    
    if (self.carShowView.alpha==1 || self.bookingTimerView.alpha==1 || self.scanUnLockView.alpha==1 || self.carRunningView.alpha==1 || self.carReturnConfirmView.alpha ==1) {
        
    } else {
        currentTransform = afterLocation;
//        [self getStationData:afterLocation andRadius:radius];
    }
}

//选中标注
- (void)selectAnnotationView:(StationCarItem *)stationItem andCarArr:(NSMutableArray *)carArr {
    
    [StatisticsClass eventId:SY04];
    
    //选择车辆
    [self.view addSubview:self.carShowView];
    self.carShowView.stationItem = stationItem;
    self.carShowView.carItems = [carArr mutableCopy];
    self.carShowView.userLoc = _homeMapView.userLocation.coordinate;
}

//不选中标注
- (void)deselectAnnotationView {
    
    if (self.carShowView.alpha==1) {
        //隐藏选择车辆
        [self hideCarAnimation];
    }
    
    //预约中、行程中不清除路线
    if ((self.carRunningView && self.carRunningView.alpha==1) || (self.bookingTimerView && self.bookingTimerView.alpha==1)) {
        
    } else {
        /* 清空地图上已有的路线. */
        [_homeMapView.naviRoute removeFromMapView];
        [_homeMapView removeSelectAnno];
    }
}

//路线规划失败
- (void)routeSearchFail {
    
    [self showCarAnimation]; //选择车动画
}

//路线规划成功
- (void)routeSearchSuccess {
    
    if (self.bookingTimerView.alpha==1) {
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"1", nil];
        /* 缩放地图使其适应polylines的展示. */
        [_homeMapView mapRouteLarge:array];
    } else {
        /* 缩放地图使其适应polylines的展示. */
        if ([APPUtil isCurrentCityName]) {
            [_homeMapView mapRouteLarge:self.carShowView.carItems];
        }
        [self showCarAnimation]; //选择车动画
    }
}

- (void)getCarStatusWithDic:(NSDictionary *)infoDic{
    carStatusInfoDic = [NSDictionary dictionaryWithDictionary:infoDic];
    [self getData];
}

#pragma mark - GetCarDelegate 预约用车代理

//计费规则
- (void)onClickWithCarPriceRuleEvent:(StationCarItem *)item {
    [BaseWebController showWithContro:self withUrlStr:item.priceDtlUrl withTitle:@"计费规则" isPresent:NO];
}

- (void)onClickWithUseCarEvent:(StationCarItem *)item {
    NSLog(@"预约用车 车牌号：%@  %@",item.numberPlate,item.vin);
    
    if (![APPUtil isBlankString:item.operationRentNum]) {
        currentBookCarPlate = item.numberPlate;
        [_homeService requestCarInLeaseWithService:@{@"rentNum":item.operationRentNum}]; //自己运维的车辆 可以查看运维行程
        return;
    }
    // 验证用户是否登录
    if (![APPUtil isLoginWithJump:YES]) {
        return;
    }
    
    // 验证会员账号状态
    if (![APPUtil isAccountStatePass:self]) { //没开通
        return;
    }
    
    //预约车弹框
    NSString *time = [APPUtil isBlankString:item.bookTotalTime]?@"20":item.bookTotalTime;
    NSString *content = [NSString stringWithFormat:@"成功预约后车辆会为您免费保留%@分钟，超时未用车订单将自动取消。",time];
    CarPopView *bookingCarView = [[CarPopView alloc] initWithImageName:@"img_book" contentText:@"预约用车" descText:content range:NSMakeRange(10, 6+time.length) leftButtonTitle:@"取消" rightButtonTitle:@"立即预约"];
    bookingCarView.tag = _Type_BookingCarView_;
    [self.view addSubview:bookingCarView];
    
    bookingCarView.carItem = item;
    
    __weak CarPopView *weakPopView = bookingCarView;
    
    bookingCarView.cancelBlock = ^(){ //取消预约
        [weakPopView closeAction];
    };
    bookingCarView.bookingFailBlock = ^(){ //预约失败
        [self getStationData:currentTransform andRadius:_homeMapView.stationRadius];
    };
    [bookingCarView setBookingSuccBlock:^(BookingItem *item){ //预约成功
        
        _homeMapView.stationArr = [NSMutableArray array];
        
        //隐藏预约车弹框、显示预约计时弹框
        [self hideCarAnimation];
        
        [_homeService requestCarInBookingWithService]; //获取已预约车辆
    }];
}

#pragma mark - BookingTimerDelegate 预约计时代理

//取消预约
- (void)onClickWithCancelBookingCarEvent:(BookingItem *)item {
    
    //开锁弹框
    if ([item.lockStatus isEqualToString:@"1"]) {//取消预约
        CarPopView *cancelBookingView = [[CarPopView alloc] initWithImageName:@"img_worning" contentText:@"取消预约" descText:@"车辆将不再为您保留，当日取消3次将无法用车。" range:NSMakeRange(0, 0) leftButtonTitle:@"确认取消" rightButtonTitle:@"我再想想"];
        cancelBookingView.tag = _Type_CancelBookingView_;
        [self.view addSubview:cancelBookingView];
        
        cancelBookingView.bookingItem = item;
        
        __weak CarPopView *weakPopView = cancelBookingView;
        
        cancelBookingView.cancelBlock = ^(){ //确认取消
            
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:item.ID,@"bookingId",nil];
            [_homeService requestCancelBookingCarWithService:paramDic];
            
            [weakPopView closeAction];
        };
        cancelBookingView.confirmBlock = ^(){ //我再想想
            [weakPopView closeAction];
        };
    }else{//开车门
//        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:item.rentNum,@"rentNum",
//                                  @"1",@"action",nil];
//        [_homeService requestOpenOrCloseLeaseCarWithService:paramDic];
        
        NSDictionary * paramDic = [NSDictionary dictionaryWithObjectsAndKeys: item.ID,@"bookingId",@"1",@"isReopen",nil];
        [_homeService requestBookTimeOpenCarWithService:paramDic];
    }
    
}

//开锁用车
- (void)onClickWithUnLockCarEvent:(BookingItem *)item {
    
    useCarFlag = 1;
    [self getRentPsw:item];
}

//查看租车密码
- (void)onClickWithShowCarPswEvent:(BookingItem *)item {
    [self getPswRentData];
}

- (void)getPswRentData{
    //获取车机密码
    rentPsw = [[NSUserDefaults standardUserDefaults]objectForKey:kRentPswKey];;
    if ([APPUtil isBlankString:rentPsw]) {
        rentPsw = @"";
        //获取租车密码
        [_homeService requestGetRentPwdService];
    }else{
        [self showRentPswView];
    }
}

//倒计时结束、预约取消
- (void)onClickWithTimerOverEvent:(BookingItem *)item {
    
    if (self.bookingTimerView.alpha==1) {
        XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:@"超时未用车，预约订单已被取消。" leftButtonTitle:@"取消" rightButtonTitle:@"我知道了" TopButtonTitle:@"提示"];
        alert.doneBlock = ^()
        {
            
        };
        
        //隐藏车辆计时弹框
        [self hideCarTimerAnimation];
        // 结束行程中定时器
        if (showTimer) {
            [showTimer invalidate];
            [self endBack];
            showTimer = nil;
        }
        [self getStationData:currentTransform andRadius:_homeMapView.stationRadius];
    }
}

//获取租车密码
- (void)getRentPsw:(BookingItem *)item {
    //开锁弹框
    CarPopView *unLockCarView = [[CarPopView alloc] initWithImageName:@"img_open" contentText:@"开锁用车" descText:@"即将打开车门，请在开锁前核对车辆牌号。" range:NSMakeRange(0, 0) leftButtonTitle:@"取消" rightButtonTitle:@"确认开锁"];
    unLockCarView.tag = _Type_UnLockCarView_;
    [self.view addSubview:unLockCarView];
    
    unLockCarView.bookingItem = item;
    unLockCarView.fromFlag = useCarFlag;
    
    __weak CarPopView *weakPopView = unLockCarView;
    
    unLockCarView.cancelBlock = ^(){ //取消
        [weakPopView closeAction];
    };
    unLockCarView.confirmBlock = ^(){ //开锁成功
        
        [self startMinuteTimer:5 andType:_REQUEST_CarInLease_]; //每隔5秒刷新一次行程中接口
        
        //获取租车密码
//        [_homeService requestGetRentPwdService];
         [self getPswRentData];
    };
}

#pragma mark - ScanUnLockDelegate 扫码开门代理

//计费规则
- (void)onClickWithPriceRuleEvent:(ScanCarInfoItem *)item {
    [BaseWebController showWithContro:self withUrlStr:item.priceDtlUrl withTitle:@"计费规则" isPresent:NO];
}

//取消开锁
- (void)onClickWithCancelUnLockCarEvent:(ScanCarInfoItem *)item {
    [self hideScanCarAnimation];
}

//扫码开锁
- (void)onClickWithScanUnLockCarEvent:(ScanCarInfoItem *)item {
    
    NSLog(@"%@",item.orderNo);
    
    BookingItem *bookingItem = [[BookingItem alloc] init];
    bookingItem.ID = item.orderNo;
    bookingItem.vin = item.vin;
    
    useCarFlag = 2;
    [self getRentPsw:bookingItem];
}

#pragma mark - CarRunningDelegate 行程中代理

//查看还车点
- (void)onClickWithReturnCarEvent {
    ReturnCarStationVC *returnCarStationVC = [[ReturnCarStationVC alloc] init];
    [self.navigationController pushViewController:returnCarStationVC animated:YES];
}

//行程中开车门
- (void)onClickWithOpenCarDoorEvent:(BookingItem *)item {
    
    if([_homeMapView checkLocationOn]) { //检测定位是否开启
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:item.rentNum,@"rentNum",
                                  @"2",@"action",nil];
        [_homeService requestOpenOrCloseLeaseCarWithService:paramDic];
        
        //上传经纬度到后台
        [self uploadLatLng:item andAction:@"1"];
    }
}

//行程中关车门
- (void)onClickWithCloseCarDoorEvent:(BookingItem *)item {
    
    if([_homeMapView checkLocationOn]) { //检测定位是否开启
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:item.rentNum,@"rentNum",
                                  @"1",@"action",nil];
        [_homeService requestOpenOrCloseLeaseCarWithService:paramDic];
        
        //上传经纬度到后台
        [self uploadLatLng:item andAction:@"2"];
    }
}

//结束行程
- (void)onClickWithFinishRunningEvent:(BookingItem *)item {
    
    [_homeMapView checkLocationOn]; //检测定位是否开启
    if ([item.forbidReturnCar integerValue]==1) {
       XDYAlertView *alert = [[XDYAlertView alloc] initWithContentText:[NSString stringWithFormat:@"请到当地门店进行还车处理，客服热线%@",ServicePhone] leftButtonTitle:@"" rightButtonTitle:@"确定" TopButtonTitle:@"提示"];
        alert.doneBlock = ^{
        };
        return;
    }
    [self hideCarRunningAnimation];
    [self showCarReturnConfirmAnimation];
    
    //关闭定时器
    if (showTimer) {
        [showTimer invalidate];
        [self endBack];
        showTimer = nil;
    }
    
    hiddenCarRunningViewFlag = NO;//变量初始化
    [_homeMapView.scanUseCarBtn setImage:[UIImage imageNamed:@"btn_scanUseCar"] forState:UIControlStateNormal];
    homeScanBtnState = ENUMHomeScanBtnStateNormal;

}


//关闭行程中页面
- (void)onClickWithCloseViewEvent:(BookingItem *)item {
    
    [_homeMapView checkLocationOn]; //检测定位是否开启
    
    [self hideCarRunningAnimation];
    //关闭定时器
    if (showTimer) {
        [showTimer invalidate];
        [self endBack];
        showTimer = nil;
    }
    
    hiddenCarRunningViewFlag = NO;//变量初始化
    [_homeMapView.scanUseCarBtn setImage:[UIImage imageNamed:@"btn_scanUseCar"] forState:UIControlStateNormal];
    homeScanBtnState = ENUMHomeScanBtnStateNormal;
    
    _homeMapView.forbidAnnoClick = YES;
    [self onclickWithRefresh];//关闭页面刷新下数据
}


#pragma mark - CarReturnConfirmDelegate 确认还车代理

//取消还车
- (void)onClickWithCancelReturnCarEvent:(BookingItem *)item {
    [self hideCarReturnConfirmAnimation];
    [self showCarRunningAnimation];
    
}

//确认还车
- (void)onClickWithConfirmReturnCarEvent:(BookingItem *)item {
    
    //上传经纬度到后台
    [self uploadLatLng:item andAction:@"3"];
}

//还车成功回调
- (void)returnCarSuccEvent:(NSDictionary *)dic {
    [self hideCarReturnConfirmAnimation];
    [self hideCarTimerAnimation];
    [self hideScanCarAnimation];
    
    [_homeMapView.mapView setZoomLevel:17];
    [self getStationData:currentTransform andRadius:_homeMapView.stationRadius];
    
//    CarFeeDetailView *carFeeDetailView = [[CarFeeDetailView alloc] init];
//    carFeeDetailView.resultDic = resultDic;
//    [self.view addSubview:carFeeDetailView];
//    
//    carFeeDetailView.doneBlock = ^(){
    
    [self hideCarRunningAnimation];
//    };
}

#pragma mark - 定时器 NSTimer

//每隔多长时间请求一次行程中接口
- (void)startMinuteTimer:(int)second andType:(ActionType)type{
    
    __weak XDYHomeVC *weakSelf = self;
    
    // 倒计时
    taskID=  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf endBack];
    }];
    
    // 计时器重启
    if (showTimer) {
        [showTimer invalidate];
        [self endBack];
        showTimer = nil;
    }
    
    showTimer = [NSTimer eocScheduledTimerWithTimeInterval:second block:^{
        if (type==_REQUEST_CarInBooking_) {
            [weakSelf getCarInBooking];
        }
        
        if (type==_REQUEST_CarInLease_) {
            [weakSelf getCarInLease];
        }
    } repeats:YES];
}

- (void)getCarInLease {
    if ([APPUtil isLoginWithJump:NO]) {
        [_homeService requestCarInLeaseWithService:@{}]; //获取行程中车辆
    }
}

- (void)getCarInBooking {
    [_homeService requestCarInBookingWithService]; //获取预约中车辆
    [_homeService requestCarInSearchInfoWithService]; //获取扫码租车车辆
}

-(void)endBack
{
    [[UIApplication sharedApplication] endBackgroundTask:taskID];
    taskID = UIBackgroundTaskInvalid;
}

#pragma mark - Animation 动画

//提示视图显示
- (void)showTipAnimation:(NSString *)contentStr {
//    CGFloat topHeight = 0;
//    if (_homeMapView.tipView1.alpha==0) {
//        topHeight = IS_IPhoneX?24:0;
//    }else{
//        topHeight =_homeMapView.tipView1.bottom+1;
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        _homeMapView.tipView.top = topHeight;
//        _homeMapView.tipView.alpha = 1;
//        _homeMapView.exchangeCarPileBtn.top = MAX(0, _homeMapView.tipView.bottom)+autoScaleW(10);
//        _homeMapView.tipTitleLab.text = contentStr;
//    }];
}

//提示视图隐藏
- (void)hideTipAnimation {
//    [UIView animateWithDuration:0.3 animations:^{
//        _homeMapView.tipView.top = -64;
//        _homeMapView.tipView.alpha = 0;
//        _homeMapView.exchangeCarPileBtn.top = autoScaleW(10);
//    }];
}

//提示视图显示
- (void)showErrorNetWorkView {
//    CGFloat topHeight = 0;
//    if (_homeMapView.tipView.alpha==0) {
//        topHeight = IS_IPhoneX?24:0;
//    }else{
//        topHeight =_homeMapView.tipView.bottom+1;
//    }
//
//    [UIView animateWithDuration:0.3 animations:^{
//        _homeMapView.tipView1.top = topHeight;
//        _homeMapView.tipView1.alpha = 1;
//        _homeMapView.exchangeCarPileBtn.top = MAX(0, _homeMapView.tipView1.bottom)+autoScaleW(10);
//    }];
}

//提示视图隐藏
- (void)hideErrorNetWorkView {
    
//    [UIView animateWithDuration:0.3 animations:^{
//        _homeMapView.tipView1.top = -64;
//        _homeMapView.tipView1.alpha = 0;
////        [self chanageFrameExchangeCarPileBtn];
//        _homeMapView.exchangeCarPileBtn.top = MAX(0, _homeMapView.tipView.bottom)+autoScaleW(10);
//    }];
//
//    if (!hasCityAreaData) {//没有请求到城市区域数据
//
//    }
}

- (void)chanageFrameExchangeCarPileBtn{
    if (_homeMapView.tipView.alpha==0) {
        
    }
}



//查看网点车辆信息动画【预约用车】
- (void)showCarAnimation {
    
    UIImageView *imageView = [self.carShowView viewWithTag:10000];
    UIView *carView = [self.carShowView viewWithTag:100000];
    
    //大弹框动画
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self clearScanBtnFrame];
        
        self.carShowView.alpha = 1;
        if (self.carShowView.carItems.count>0) {
            self.carShowView.top = autoScaleH(347);
//            _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(380);
        } else {
            self.carShowView.top = autoScaleH(540);
//            _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(180);
        }
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
    } completion:^(BOOL finished) {
        
    }];
    
    //车动画
    [UIView animateKeyframesWithDuration:0.3 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveEaseIn animations:^{
        
        imageView.top = 0;
        imageView.alpha = 1;
    } completion:nil];
    
    //字体动画
    [UIView animateKeyframesWithDuration:0.3 delay:0.15 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveEaseIn animations:^{
        
        carView.top = imageView.bottom;
        carView.alpha = 1;
    } completion:nil];
}

- (void)hideCarAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        
        [self resetScanBtnFrame];
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(75);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        self.carShowView.alpha = 0;
        self.carShowView.top = autoScaleH(667);
    } completion:^(BOOL finished) {
        
    }];
}

//预约计时动画【开锁用车】
- (void)showCarTimerAnimation {
    
    if (self.bookingTimerView.alpha==0) {
        [self.view addSubview:self.bookingTimerView];
    }
    
    BookingItem *item;
    if ([_carTimerFlag isEqualToString:@"1"]) {
        item = _carBookingArr[0];
    } else {
        item = _carScanUseArr[0];
    }
    
    self.bookingTimerView.bookingItem = item;
    
    self.bookingTimerView.userLoc = _homeMapView.userLocation.coordinate;
    
    [_homeMapView showCarRoute:item];
    
    //大弹框动画
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self clearScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 0;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height;
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(380);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.bookingTimerView.alpha = 1;
        self.bookingTimerView.top = autoScaleH(347);
        
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = YES;
    }];
    
    if ([item.lockStatus isEqualToString:@"1"]) {
        [self startMinuteTimer:10 andType:_REQUEST_CarInBooking_]; //每隔10秒刷新一次预约中接口
    } else {
        
        [self startMinuteTimer:5 andType:_REQUEST_CarInLease_]; //每隔5秒刷新一次行程中接口
    }
}

- (void)hideCarTimerAnimation {
    
    /* 清空地图上已有的路线. */
    [_homeMapView.naviRoute removeFromMapView];
    [_homeMapView removeSelectAnno];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self resetScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 1;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-autoScaleW(64);
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(64);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.bookingTimerView.alpha = 0;
        self.bookingTimerView.top = autoScaleH(667);
    } completion:^(BOOL finished) {
        _homeMapView.forbidAnnoClick = NO;
    }];
}

//扫码开锁动画【扫码用车】
- (void)showScanCarAnimation {
    [self.view addSubview:self.scanUnLockView];
    
    self.scanUnLockView.item = _currentScanCarInfoItem;
    
    //大弹框动画
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self clearScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 0;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height;
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(380);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.scanUnLockView.alpha = 1;
        self.scanUnLockView.top = autoScaleH(347);
        
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = YES;
    }];
    
    //车动画
    [UIView animateKeyframesWithDuration:0.3 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.scanUnLockView.imgView.top = 0;
        self.scanUnLockView.imgView.alpha = 1;
    } completion:nil];
    
    //字体动画
    [UIView animateKeyframesWithDuration:0.3 delay:0.15 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.scanUnLockView.carInfoView.top = self.scanUnLockView.imgView.bottom;
        self.scanUnLockView.carInfoView.alpha = 1;
    } completion:nil];
}

- (void)hideScanCarAnimation {
    [UIView animateWithDuration:0.3 animations:^{
//        _homeMapView.scanUseCarBtn.alpha = 1;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-autoScaleW(64);
        [self resetScanBtnFrame];
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(64);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.scanUnLockView.alpha = 0;
        self.scanUnLockView.top = autoScaleH(667);
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = NO;
    }];
}

//行程中动画
- (void)showCarRunningAnimation {
    
    if (self.carRunningView.alpha==0) {
        [self.bookingTimerView endTimer]; //结束定时器
        [self.view addSubview:self.carRunningView];
    }
     NSString *rentPswStr = [[NSUserDefaults standardUserDefaults]objectForKey:kRentPswKey];;
    if ([APPUtil isBlankString:rentPswStr]) {
        rentPsw = @"";
        //获取租车密码
        [_homeService requestGetRentPwdService];
    }
    self.carRunningView.item = _carLeaseArr[0];
    
    //上传经纬度到后台
    [self uploadLatLng:self.carRunningView.item andAction:@"0"];
    
    //大弹框动画
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self clearScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 0;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height;
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(535);
//        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.carRunningView.alpha = 1;
        self.carRunningView.top = autoScaleH(187);
        
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = YES;
    }];
    
    [self startMinuteTimer:20 andType:_REQUEST_CarInLease_]; //每隔20秒刷新一次行程中接口
}

- (void)hideCarRunningAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        [self resetScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 1;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-autoScaleW(64);
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(64);
//        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.carRunningView.alpha = 0;
        self.carRunningView.top = autoScaleH(667);
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = NO;
    }];
}

//还车确认动画【检查】
- (void)showCarReturnConfirmAnimation {
    [self.view addSubview:self.carReturnConfirmView];
    
    //单例视图恢复数据
    [self.carReturnConfirmView recoverView];
    
    NSLog(@"行程中数据源：%@",_carLeaseArr[0]);
    //传数据
    self.carReturnConfirmView.bookingItem = _carLeaseArr[0];
    
    //大弹框动画
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self clearScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 0;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height;
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(380);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.carReturnConfirmView.alpha = 1;
        self.carReturnConfirmView.top = autoScaleH(347);
        
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = YES;
    }];
}

- (void)hideCarReturnConfirmAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        [self resetScanBtnFrame];
//        _homeMapView.scanUseCarBtn.alpha = 1;
//        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-autoScaleW(64);
//        _homeMapView.locationBtn.top = _homeMapView.mapView.height-autoScaleH(64);
        _homeMapView.clickLocateBtn.top = _homeMapView.locationBtn.top;
        
        self.carReturnConfirmView.alpha = 0;
        self.carReturnConfirmView.top = autoScaleH(667);
    } completion:^(BOOL finished) {
        
        _homeMapView.forbidAnnoClick = NO;
    }];
}

#pragma mark - 状态栏动画

- (BOOL)prefersStatusBarHidden {
    
    if (_leftMenuView.leftViewShow ==1) {
        return YES;
    }else{
        return NO;
    }
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    
    return UIStatusBarAnimationSlide;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_homeMapView setDelegate];
    
    [self resetAuthStateCount];
    
    [super viewWillAppear:animated];
    
//    //设置地图中心点
//    [_homeMapView.mapView setCenterCoordinate:_homeMapView.userLocation.coordinate animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_homeMapView.mapView setZoomLevel:17 animated:YES];
//    });
//    [self getStationData:currentTransform andRadius:_homeMapView.stationRadius];
    
    [_leftMenuView.headView setNeedsLayout];
    
    if (![APPUtil isLoginWithJump:NO]) {
        _navBarView.leftBtn.image = [UIImage imageNamed:@"img_avatar_logout"];
    } else {
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"headImg"];
        if (cachedImage == nil) {
            [_navBarView.leftBtn sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].headImgUrl] placeholderImage:[UIImage imageNamed:@"img_avatar"]];
        }else{
            [_navBarView.leftBtn setImage:cachedImage];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self resetAuthStateCount];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    
    [_homeMapView clearDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PalyServicePhoneNum{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",ServicePhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    });
}

- (void)resetScanBtnFrame{
    _homeMapView.scanUseCarBtn.alpha = 1;
    _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-_homeMapView.scanUseCarBtn.height;
    if (IS_IPhoneX) {
        //            _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-autoScaleW(76);
        _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height-_homeMapView.scanUseCarBtn.height-autoScaleH(2);
    }
}


- (void)clearScanBtnFrame{
    _homeMapView.scanUseCarBtn.alpha = 0;
    _homeMapView.scanUseCarBtn.top = _homeMapView.mapView.height;
}


-(void)pushAppStore{
    if (IS_IOS_10) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/xiao-ling-gou/id1129173295?mt=8"] options:@{} completionHandler:^(BOOL success) {
//            debugLog(@"跳转成功");
        }];
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/xiao-ling-gou/id1129173295?mt=8"]];
    }
}
@end
