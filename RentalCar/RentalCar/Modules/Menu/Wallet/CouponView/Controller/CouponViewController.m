//
//  CouponViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/4/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"
#import "CouponViewService.h"
#import "defaultDataView.h"

#import "defaultDataView.h"
@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate,ObserverServiceDelegate,defaultDataViewDelegate>
{

    CouponCell *cell;
    UIButton *InvalidButton;
    defaultDataView *dele;
}
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong)CouponViewService *service;
@property (nonatomic, strong) NSMutableArray *CouponListArr;
@property (nonatomic, strong) NSMutableArray *CouponisExpiredArr;
@property(nonatomic,strong)CouponModel *cellModel;
@property(nonatomic,strong)UIView *invalidHeader;
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@property(nonatomic,assign)BOOL invalidShow;


@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"优惠券";
    _service = [[CouponViewService alloc]init];
    _service.serviceDelegate = self;
    //暂时写死跳转模式
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:@(1) forKey:@"pageIndex"];
    [param setObject:@(20) forKey:@"pageSize"];
    [param setObject:@(1) forKey:@"paging"];
    
    _CouponListArr = [[NSMutableArray alloc]init];
    _CouponisExpiredArr = [[NSMutableArray alloc]init];
    [_service requesCouponListWithService:param success:^(id data) {
//        debugLog(@"%@",data);
    } fail:^(NSString * error) {
//        debugLog(@"%@",error);
    }];
}

-(void)onSuccess:(id)data withType:(ActionType)type{
    
    if (type == _REQUEST_CouponList_) {
        NSDictionary *temp =  [data objectForKey:@"result"];
        _CouponListArr = [temp objectForKey:@"list"];
        //进行过期与未过期的分类
        
        if (_CouponListArr.count !=0) {
            for (int i = 0; i<_CouponListArr.count; i++) {
                _cellModel =[CouponModel yy_modelWithJSON:_CouponListArr[i]];
//                debugLog(@"%d",[_cellModel.isExpired intValue]);
                if ([_cellModel.isExpired intValue] ==1) {
                    [_CouponisExpiredArr addObject:_CouponListArr[i]];
                    [_CouponListArr removeObjectAtIndex:i];
                    i-=1;
                }
    
            }
            
  
            
            [self.view setBackgroundColor:[UIColor greenColor]];
            
            self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, kScreenWidth, kScreenHeight-NVBarAndStatusBarHeight)];
            
            self.tableview.delegate = self;
            self.tableview.dataSource = self;
            self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableview.showsVerticalScrollIndicator = NO;
            self.tableview.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
            
            [self.view addSubview:self.tableview];
            
            if (_CouponListArr.count==0) {
                
               dele = [[defaultDataView alloc]initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, self.view.width, self.view.height-NVBarAndStatusBarHeight)];
                dele.delegate =self;
                dele.PushType = 2;
                [self.view addSubview:dele];
            }
        }else{
            dele = [[defaultDataView alloc]initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, self.view.width, self.view.height-NVBarAndStatusBarHeight)];
            dele.PushType = 1;
            
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
    
    return 2;
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
    if (section == 0) {
   
        return _CouponListArr.count;
    }else if (section == 1 && _invalidShow == YES){

        return _CouponisExpiredArr.count;
    }
    else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"CouponCell%ld", (long)indexPath.row];
    
    cell = (CouponCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
       
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
//    if (_selIndex == indexPath) {
//        [cell OnSelected:YES animated:NO];
//    }else {
//        [cell OnSelected:NO animated:NO];
//    }
    
//    debugLog(@"%@",_CouponListArr);
//    debugLog(@"%@",_CouponisExpiredArr);
    if (indexPath.section == 0) {
    _cellModel =[CouponModel yy_modelWithJSON:_CouponListArr[indexPath.row]];
    }
    
    if (indexPath.section == 1 && _invalidShow == YES){
     _cellModel =[CouponModel yy_modelWithJSON:_CouponisExpiredArr[indexPath.row]];
    }
    
   
    cell.model =_cellModel;
    cell.indexpath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellOnPush = _OnPush;
    
    cell.cellType = [_cellModel.type intValue];
    
    [cell setupDetailView];
    if (indexPath ==_selIndex) {
    [cell OnSelected:YES animated:NO];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //暂时屏蔽点击方法
    
    if (self.OnPush == 1) {
        cell = [tableView cellForRowAtIndexPath:_selIndex];
        //记录当前选中的位置索引
        [cell OnSelected:NO animated:NO];
        _selIndex = indexPath;
        //当前选择的打勾
        cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell OnSelected:YES animated:NO];
        if (self.CouponInfoBlock) {
            self.CouponInfoBlock(cell.model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    return autoScaleH(120);
    }
    else if (indexPath.section == 1 &&_invalidShow == YES){
       return autoScaleH(120);
    }else{
        return autoScaleH(0);
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return autoScaleH(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && _OnPush == 2) {
        return 0;
    }if (_CouponListArr.count == 0) {
        return autoScaleH(90);
    }
    else{
        return autoScaleH(54);
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _invalidHeader = [[UIView alloc]initWithFrame:tableView.tableHeaderView.frame];
//    debugLog(@"%ld",(long)section);
    
    if (_CouponisExpiredArr.count ==0) {
        [_invalidHeader setHidden:YES];
    }
    
    if (section == 1 && _OnPush == 2) {
      
        if (InvalidButton == nil) {
            InvalidButton = [[UIButton alloc]init];
//            debugLog(@"%f",_invalidHeader.width);
            [InvalidButton setFrame:CGRectMake(kScreenWidth/2 - autoScaleW(176)/2, autoScaleH(54)/2-autoScaleH(40)/2, autoScaleW(176), autoScaleH(40))];
           
        }
        if (_invalidShow ==NO) {
            [InvalidButton setTitle:@"查看已失效优惠券" forState:UIControlStateNormal];
            [InvalidButton setTitleColor:[UIColor colorWithHexString:@"#9F9F9F"] forState:UIControlStateNormal];
            [InvalidButton.titleLabel setFont:[UIFont systemFontOfSize:autoScaleH(12)]];
            [InvalidButton addTarget:self action:@selector(InvalidClick:) forControlEvents:UIControlEventTouchUpInside];
            [[APPUtil share] setButtonClickStyle:InvalidButton Shadow:NO normalBorderColor:[UIColor colorWithHexString:@"#E7EDEA"] selectedBorderColor:[UIColor colorWithHexString:@"EEEEEE"] BorderWidth:1 normalColor:[UIColor colorWithHexString:@"#FCFCFC"] selectedColor:[UIColor colorWithHexString:@"F5F5F5"] cornerRadius:autoScaleH(5)];

            [_invalidHeader addSubview:InvalidButton];
        }else{
            
            [InvalidButton setTitle:@"----   已失效优惠券   ----" forState:UIControlStateNormal];
            
            [InvalidButton setBackgroundImage:[UIColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [InvalidButton.layer setBorderWidth:0];
            [InvalidButton.layer setCornerRadius:0];
            [InvalidButton setBackgroundColor:[UIColor clearColor]];
            [_invalidHeader addSubview:InvalidButton];
            
            if (_CouponListArr.count ==0) {
                UILabel *InvalidLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - autoScaleW(176)/2, autoScaleH(20), autoScaleW(176), autoScaleH(20))];
                    [InvalidLabel setText:@"暂无可用优惠券"];
                    [InvalidLabel setTextAlignment:NSTextAlignmentCenter];
                    [InvalidLabel setTextColor:[UIColor colorWithHexString:@"#B2B2B2"]];
        
                    [_invalidHeader addSubview:InvalidLabel];
                
                    [InvalidButton setFrame:CGRectMake(InvalidLabel.origin.x, InvalidLabel.bottom+autoScaleH(20), autoScaleW(176), autoScaleH(20))];
            }
        }
        
    
        return _invalidHeader;
    }else{
        [_invalidHeader setBackgroundColor:[UIColor blueColor]];
        InvalidButton = [[UIButton alloc]init];
//        debugLog(@"%f",_invalidHeader.width);
        [InvalidButton setFrame:CGRectMake(kScreenWidth/2 - autoScaleW(176)/2, autoScaleH(54)/2-autoScaleH(40)/2, autoScaleW(176), autoScaleH(40))];
        
        [InvalidButton setBackgroundColor:[UIColor whiteColor]];
        [_invalidHeader addSubview:InvalidButton];
        
        return _invalidHeader;
    }
    
    return _invalidHeader;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:tableView.tableHeaderView.frame];
    [backView setBackgroundColor:[UIColor colorWithHexString:@"#FBFBFB"]];
    return backView;
}


-(void)InvalidClick:(UIButton *)button{
    _invalidShow =YES;
    [self.tableview reloadData];
}

//禁止头部浮动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
    CGFloat sectionHeaderHeight = 90;
    
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)openInvalid:(UIButton *)buton{
    [dele setHidden:YES];
    [self InvalidClick:buton];
    
}

@end
