//
//  SelectCityVC.m
//  RentalCar
//
//  Created by Jason on 2018/1/4.
//  Copyright © 2018年 xyx. All rights reserved.
//

#import "SelectCityVC.h"
#import "XDYHomeService.h"
#import "AreaInfo.h"

@interface SelectCityVC ()<ObserverServiceDelegate,UITableViewDelegate,UITableViewDataSource>
{
    XDYHomeService *_homeService;
    NSMutableArray *_cityArr;
    UITableView *_cityTableView;
}
@end

@implementation SelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    _cityArr = [NSMutableArray array];
    
    //初始化城市列表
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, kScreenWidth, kScreenHeight-NVBarAndStatusBarHeight) style:UITableViewStyleGrouped];
    _cityTableView.delegate = self;
    _cityTableView.dataSource = self;
    [self.view addSubview:_cityTableView];
    
    _homeService = [[XDYHomeService alloc] init];
    _homeService.serviceDelegate = self;
    [_homeService requestGetAreaListWithService];
}

#pragma mark - ObserverServiceDelegate 接口数据处理代理

- (void)onSuccess:(id)data withType:(ActionType)type{
    
    switch (type) {
            
        case _REQUEST_GetAreaList: //获取区域列表
        {
            _cityArr = [data mutableCopy];
            
            NSMutableArray *array = [NSMutableArray array];
            
            NSString *userAreaId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAreaID];
            for (int i = 0; i<_cityArr.count; i++) {
                AreaInfo *info = _cityArr[i];
                if ([info.areaId isEqualToString:userAreaId]) {
                    [array addObject:info];
                }
            }
            
            [_cityArr removeAllObjects];
            [_cityArr addObjectsFromArray:array];
            [_cityTableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate协议
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AreaInfo *info = _cityArr[indexPath.row];
    if ([info.lat isEqualToString:@"0"] || [info.lng isEqualToString:@"0"]) {
        [APPUtil showToast:@"您选择的区域无效！"];
        return;
    }
    NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:info.areaId,@"areaId",info.areaName,@"areaName",info.deposit,@"deposit",info.lng,@"lng",info.lat,@"lat",info.areaStatus,@"areaStatus", nil];
    [self.backDelegate selectCity:areaDic];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableViewDataSource协议
//显示多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//显示一组里面多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityArr.count;
}

//显示组头名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *areaName = [CacherUtil getCacherWithKey:kLocationAreaName];
    if ([APPUtil isBlankString:areaName]) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"当前定位城市：%@",areaName];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

//组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

//每行视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AreaInfo *info = _cityArr[indexPath.row];
    cell.textLabel.text = info.areaName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
