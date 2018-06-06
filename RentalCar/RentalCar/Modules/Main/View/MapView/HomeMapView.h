//
//  HomeMapView.h
//  RentalCar
//
//  Created by zhanbing han on 17/3/26.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseView.h"
#import "StationCarItem.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import "MANaviRoute.h"
#import "CarAnnotationView.h"
#import "LocationTransform.h"
#import "BookingItem.h"
#import "CarPointAnnotation.h"
#import "CommonMenuView.h"

#define LeftMenuNameArr @[@"全部类型",@"长租",@"分时"]
#define RightMenuNameArr @[@"全部状态",@"正常车",@"异常车",@"空闲",@"预约",@"租赁",@"运维",@"亏电",@"故障",@"离线"]
#define CarStatusKeyValue @{@"全部类型":@"3",@"长租":@"2",@"分时":@"1",@"全部状态":@"7",@"正常车":@"8",@"异常车":@"9",@"空闲":@"0",@"预约":@"2",@"租赁":@"1",@"运维":@"5",@"亏电":@"4",@"故障":@"3",@"离线":@"6"}

@protocol HomeMapDelegate <NSObject>

@optional
- (void)onClickWithExchangeCarPileEvent; //切换车辆/车桩
- (void)onClickWithShowCarListEvent; //切换车辆/车桩
- (void)onClickWithScanUseCarEvent; //扫码用车
- (void)returnReGeocodeCityResult:(NSMutableDictionary *)dic; //反地理编码定位城市
- (void)singleTappedMapView; //单击地图
- (void)userMoveMapViewEnd:(LocationTransform *)afterLocation withRadius:(NSString *)radius; //用户移动地图结束

- (void)selectAnnotationView:(StationCarItem *)stationItem andCarArr:(NSMutableArray *)carArr;
- (void)deselectAnnotationView; //不选中标注
- (void)routeSearchFail; //路线规划失败
- (void)routeSearchSuccess; //路线规划成功
- (void)locationSuccess:(LocationTransform *)afterLocation withRadius:(NSString *)radius; //定位成功
- (void)onclickWithRefresh; //定位成功
- (void)menuClickIndex:(NSInteger)index; //定位成功
- (void)getCarStatusWithDic:(NSDictionary *)infoDic; //定位成功
@end

@interface HomeMapView : BaseView

@property (nonatomic,weak) id<HomeMapDelegate> delegate;

@property (nonatomic,retain) UIView *tipView; //提示视图
@property (nonatomic,retain) UILabel *tipTitleLab; //提示内容

@property (nonatomic,retain) UIView *tipView1; //提示视图
@property (nonatomic,retain) UILabel *tipTitleLab1; //提示内容

@property (nonatomic,retain) UIButton *exchangeCarPileBtn; //显示车辆列表
@property (nonatomic,retain) UIButton *showCarListBtn; //显示车辆列表

@property (nonatomic,retain) UIImageView *locationBtn; //定位
@property (nonatomic,retain) UIButton *refreshBtn; //定位
@property (nonatomic,retain) UIButton *clickLocateBtn;
//@property (nonatomic,retain) UIButton *clickLocateBtn;
@property (nonatomic,retain) UIButton *scanUseCarBtn; //扫码用车

@property (nonatomic,retain) MAMapView *mapView; //高德地图
@property (nonatomic,retain) AMapLocationManager *locationManager; //定位管理者
@property (nonatomic,retain) CLLocation *userLocation; //用户当前的位置
@property (nonatomic,retain) MANaviRoute *naviRoute; //路线规划路线
@property (nonatomic,retain) CarAnnotationView *carAnnoView; //当前选中的标注
@property (nonatomic,retain) CarPointAnnotation *anno;
@property (nonatomic,retain) NSMutableArray *stationArr; //站点标注
@property (nonatomic,retain) StationCarItem *stationItem; //当前选中的站点
@property (nonatomic,assign) BOOL forbidAnnoClick; //标注是否可以点击
@property (nonatomic,retain) NSString *stationRadius;
@property (nonatomic,retain) NSString *carStatus;  //新增 0：可租，1：离线，2：亏电，3：运维 【字段不传为可租】
@property (nonatomic,assign) BOOL isSearchFlag;//是否是搜索请求到的数据

- (void)setDelegate;
- (void)clearDelegate;

- (void)mapRouteLarge:(NSMutableArray *)array; //路线规划缩放

- (void)showCarRoute:(BookingItem *)item; //显示车的路线规划

- (void)removeSelectAnno; //移除选中标注

- (void)removeAllAnnos; //移除所有标注

- (void)uploadLoction; //上传经纬度到后台

- (BOOL)checkLocationOn; //检查定位是否开启

- (void)changeCity:(NSDictionary *)areaDic; //切换城市处理

- (void)annoDidClickedFromCarList:(StationCarItem *)car;

@end
