//
//  MyTravelViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "MyTravelViewController.h"
#import "MyTravelCell.h"
#import "MyTravelService.h"
#import "MyTravelModel.h"
#import "defaultDataView.h"
#import "MJRefresh.h"

@interface MyTravelViewController ()<UITableViewDataSource,UITableViewDelegate,ObserverServiceDelegate,defaultDataViewDelegate>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong)MyTravelService *service;
@property (nonatomic, strong) NSMutableArray *carListArr;
@property(nonatomic,strong)MyTravelModel *cellModel;
@property(nonatomic,assign)NSInteger pageIndex;
@end

@implementation MyTravelViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex =1;
    self.title =@"行程";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FBFBFB"]];
    self.service =[[MyTravelService alloc]init];
    self.service.serviceDelegate = self;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+StatusBarHeight, kScreenWidth, kScreenHeight-(44+StatusBarHeight))];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    [self.view addSubview:self.tableview];
    
    
    //获取行程列表的数据
    _carListArr = [[NSMutableArray alloc]init];
    _pageIndex=1;
    [self loadNetData];
   
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadNetData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableview.mj_footer endRefreshing];
        });
    }];
    

}

- (void)loadNetData{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *token =[UserInfo share].token;
    [param setObject:@(_pageIndex) forKey:@"pageIndex"];
    [param setObject:@(20) forKey:@"pageSize"];
    [param setObject:@(1) forKey:@"paging"];
    [param setObject:token forKey:@"token"];
    [param setObject:@"1" forKey:@"appType"]; //车务端
    [self.service requesLeaseWithService:param success:^(id result) {
        
    } fail:^(NSString * error) {
        
    }];
}

-(void)onSuccess:(id)data withType:(ActionType)type{
    
    if (type == _REQUEST_LeaseList_) {
        NSDictionary *temp =  [data objectForKey:@"result"];
        NSArray *tempDataArr = [temp objectForKey:@"list"];
        if (_pageIndex == 1) {
            _carListArr = [NSMutableArray arrayWithArray:tempDataArr];
        }else{
            [_carListArr addObjectsFromArray:tempDataArr];
        }
        if (tempDataArr.count>0) {
            _pageIndex++;
        }
        if (_carListArr.count !=0) {
            self.tableview.hidden = NO;
            [self.tableview reloadData];
        }else{
            self.tableview.hidden = YES;
            defaultDataView *dele = [[defaultDataView alloc]initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, self.view.width, self.view.height-NVBarAndStatusBarHeight)];
            
            dele.delegate =self;
            [self.view addSubview:dele];
        }
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark tablveiw的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (_cardListArr.count == 0) {
//        _noDataView = [BaseViewController setupNoDataView];
//        [self.view addSubview:_noDataView];
//        
//        return 0;
//    } else {
//        if (_noDataView) {
//            _noDataView = nil;
//        }
//    }
//    debugLog(@"%lu",(unsigned long)_cardListArr.count);
//    return _cardListArr.count;
//    debugLog(@"%ld",_carListArr.count);
    return _carListArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"statusCell%ld", indexPath.row];
    
    MyTravelCell *cell = (MyTravelCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [MyTravelCell cellWithTableView:tableView indexPath:indexPath];
//        debugLog(@"%ld", _carListArr.count);
//        debugLog(@"%@",_carListArr[indexPath.row]);
        
        _cellModel =[MyTravelModel yy_modelWithJSON:_carListArr[indexPath.row]];
        cell.model =_cellModel;
        cell.indexpath = indexPath;

        [cell setupDetailView];
        
    }
//    debugLog(@"%ld",_carListArr.count);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 MyTravelModel * tempModel =[MyTravelModel yy_modelWithJSON:_carListArr[indexPath.row]];
     if ([tempModel.status integerValue]==0) {
         if (_getSelectRentNum) {
             _getSelectRentNum(tempModel.rentNum);
         }
         [self backMap];
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return autoScaleH(190);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)backMap{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
