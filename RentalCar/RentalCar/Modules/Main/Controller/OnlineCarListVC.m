//
//  OnlineCarListVC.m
//  RentalCar
//
//  Created by MEyo on 2018/5/30.
//  Copyright © 2018年 xyx. All rights reserved.
//

#import "OnlineCarListVC.h"
#import "CarListCell.h"
#import "CommonRequest.h"
#import "UrlConfig.h"
#import "MJRefresh.h"

@interface OnlineCarListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *carArr;

@property (nonatomic, strong) NSArray *currentBackCarArr;

@property (nonatomic, strong) LocationTransform *location;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation OnlineCarListVC

- (instancetype)initWithLocation:(LocationTransform *)location{
    
    self = [super init];
    if (self) {
        self.location = location;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"车辆列表";

    [self.view addSubview:self.tableView];
    
    int navHeight = 44 + StatusBarHeight;

    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(navHeight);
    }];
    
    self.pageIndex = 1;
    
    [self getStationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server Method

//获取站点
- (void)getStationData {
    
    NSString *areaId = [AreaInfo share].areaId;
    
    NSString  *defaultDistance = @"50000000";
    if ([areaId isEqualToString:@"2"]) { //宁海1000，其它距离5000
        defaultDistance = @"10000000";
    }

    //获取站点及可租车辆数量请求
    NSDictionary *paramDic = @{@"paging": @"1",
                               @"areaId": areaId,
                               @"gpsLng": [NSString stringWithFormat:@"%f",self.location.longitude],
                               @"gpsLat": [NSString stringWithFormat:@"%f",self.location.latitude],
                                @"type" : @"0",
                             @"distance": defaultDistance,
                              @"carType": @"3",
                            @"carStatus": @"7",
                            @"pageIndex": [NSString stringWithFormat:@"%ld", self.pageIndex],
                             @"pageSize": @"20",
                                      };
    
    [[CommonRequest shareRequest] requestWithPost:getCarForLeaseUrl() isCovered:NO parameters:paramDic success:^(id data) {
        
        NSDictionary *result = data;
        NSArray *stationCarArr = [NSArray yy_modelArrayWithClass:[StationCarItem class] json:result[@"result"][@"list"]];
        
        self.currentBackCarArr = [[NSArray alloc] initWithArray:stationCarArr];
        
        if (!self.carArr) {
            self.carArr = [[NSMutableArray alloc] initWithArray:stationCarArr];
        } else {
            
            if (self.pageIndex == 1) {
                [self.carArr removeAllObjects];
            }
            
            [self.carArr addObjectsFromArray:stationCarArr];
        }
        
        [self.tableView reloadData];
    } failure:^(NSString *code) {
        
    }];}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.carArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.model = self.carArr[indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    StationCarItem *carItem = self.carArr[indexPath.section];
    self.carBlock(carItem);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 100;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [_tableView.mj_footer resetNoMoreData];
            
            self.pageIndex = 1;
            
            [self getStationData];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView.mj_header endRefreshing];
            });
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageIndex = self.pageIndex + 1;
            
            [self getStationData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.currentBackCarArr.count < 20) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_tableView.mj_footer endRefreshing];
                }
            });
        }];
    }
    
    return _tableView;
}

@end
