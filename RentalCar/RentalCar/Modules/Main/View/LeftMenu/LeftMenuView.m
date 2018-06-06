//
//  LeftMenuView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/14.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "LeftMenuView.h"
#import "LeftMenuCell.h"

@interface LeftMenuView ()<UITableViewDelegate,UITableViewDataSource>
{
     //个人信息视图
    UIButton *_hideMenuBtn; //隐藏侧滑按钮
    LeftMenuCell *cell;
}
@end

@implementation LeftMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    
    return  self;
}

- (void)setUp {
    
    _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _shadowView.alpha = 0.0;
    [MainWindow addSubview:_shadowView];
    
    _leftView = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenu" owner:nil options:nil] firstObject];
    _leftView.width = kScreenWidth;
    _leftView.height = kScreenHeight;
    
    _leftView.left = -0;
    [MainWindow addSubview:_leftView];
    
    //点击隐藏左侧菜单
    _hideMenuBtn = [_leftView viewWithTag:1];
    [_hideMenuBtn addTarget:self action:@selector(hideLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    _leftView.hidden = YES;
    _shadowView.hidden = YES;
    //左滑隐藏左侧菜单
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideLeftMenu)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_hideMenuBtn addGestureRecognizer:leftSwipe];
    
    _leftTableView = [_leftView viewWithTag:2];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.separatorStyle = NO;
    _leftTableView.tableFooterView = [[UIView alloc] init];
    
    _headView = [[HeaderView alloc] initWithFrame:CGRectZero];
    
    
    [ _headView.cirHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)]];
}

#pragma mark - methods

//隐藏侧滑菜单
- (void)hideLeftMenu {
    if ([self.delegate respondsToSelector:@selector(onClickWithHideLeftMenuEvent)]) {
        [self.delegate onClickWithHideLeftMenuEvent];
    }
}

//点击头像
-(void)avatarClick:(UIButton *)button{
//    debugLog(@"点击头像");
    [self hideLeftMenu];
    [StatisticsClass eventId:CD01];
    if ([self.delegate respondsToSelector:@selector(onClickWithHeaderViewEvent)]) {
        [self.delegate onClickWithHeaderViewEvent];
    }
}

#pragma mark - tableView 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UserInfo share].userStatus integerValue]==0) {
        if (indexPath.row == 2) {
            return 0;
        }
    }
    return autoScaleH(52);
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return autoScaleH(180);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"LeftMenuCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xFAFAFA); //cell选中背景颜色
        cell.clipsToBounds = YES;
        
    }
    cell.titleLab.text = [titleArr objectAtIndex:indexPath.row+indexPath.section];
    //    if (indexPath.row!=2) {
    [cell.imgView setImage:iconNormalImage[indexPath.row+indexPath.section] forState:UIControlStateNormal];
    [cell.imgView setImage:iconSelectedImage[indexPath.row+indexPath.section] forState:UIControlStateSelected];
    [cell.imgView setImage:iconHighlightedImage[indexPath.row+indexPath.section] forState:UIControlStateHighlighted];
    //    }
    
    if (_isAnimationOn) {
        cell.contentView.right = kScreenWidth/3;
        [UIView animateWithDuration:0.6 delay:0.05*indexPath.row usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            cell.contentView.left = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    debugLog(@"%ld and %ld",(long)indexPath.row,indexPath.section);
    
    [self hideLeftMenu]; //隐藏侧滑栏
    
    if ([self.delegate respondsToSelector:@selector(onDidSelectRowAtIndexPath:)]) {
        [self.delegate onDidSelectRowAtIndexPath:indexPath];
    }
    
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imgView.highlighted =YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    debugLog(@"1");
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)refreshLeftMenuView{
    [self.leftTableView reloadData];
}

@end
