//
//  CommonMenuView.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 2016/12/1.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import "CommonMenuView.h"

#define kMenuTag 201712
#define kCoverViewTag 201722
#define kMargin 0
#define kTriangleHeight 13 // 三角形的高
#define kRadius 0 // 圆角半径
#define KDefaultMaxValue 10  // 菜单项最大值
#define kRowHeight MIN(autoScaleH(50), 50)

@interface CommonMenuView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) CommonMenuView * selfMenu;
@property (nonatomic,strong) UITableView * contentTableView;;
@property (nonatomic,strong) NSMutableArray * menuDataArray;
@end

@implementation CommonMenuView {
    UIView *_backView;
    CGFloat arrowPointX; // 箭头位置
    UIView *currentSuperView;
    NSIndexPath *lastIndexPath;

}
- (void)setMenuDataArray:(NSMutableArray *)menuDataArray{
    if (!_menuDataArray) {
        _menuDataArray = [NSMutableArray array];
    }
    [menuDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_menuDataArray addObject:obj];
    }];
}

- (void)setMaxValueForItemCount:(NSInteger)maxValueForItemCount{
    if (maxValueForItemCount <= KDefaultMaxValue) {
        _maxValueForItemCount = maxValueForItemCount;
    }else{
        _maxValueForItemCount = KDefaultMaxValue;
    }
}


- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (!_currentIndex) {
        _currentIndex = currentIndex;
    }
    lastIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
//    [self.contentTableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame WithView:(UIView *)view{
    if (self == [super initWithFrame:frame]) {
        currentSuperView = view;
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    self.backgroundColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1]; //箭头颜色
    arrowPointX = self.width * 0.5;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTriangleHeight, self.width, self.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.rowHeight = kRowHeight;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MenuTableViewCell class])];
    
    self.contentTableView = tableView;
    self.height = tableView.height + kTriangleHeight * 2 - 0.5;
    self.alpha = 0;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    backView.alpha = 0;
    backView.tag = kCoverViewTag;
    _backView = backView;

    CAShapeLayer *lay = [self getBorderLayer];
    self.layer.mask = lay;
    [self addSubview:tableView];
    if (currentSuperView==nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:backView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }else{
        [currentSuperView addSubview:backView];
        [currentSuperView addSubview:self];
    }
}
#pragma mark --- TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuTabCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuTabCell"];;
    }
    NSString *nameStr = self.menuDataArray[indexPath.row];
    cell.tintColor = kBlueColor;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = nameStr;
    cell.textLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if (lastIndexPath==indexPath) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checked"]];
    }else{
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_unchecked"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *nameStr = self.menuDataArray[indexPath.row];
    if (self.itemsClickBlock) {
        self.itemsClickBlock(nameStr,indexPath.row );
        UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:lastIndexPath];
        UITableViewCell *selectcell = [self.contentTableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [selectcell setAccessoryType:UITableViewCellAccessoryCheckmark];
        lastIndexPath = indexPath;
    }
    
    [self hiddenMenu];
}

#pragma mark --- 关于菜单展示
- (void)displayAtPoint:(CGPoint)point{
    
    point = [self.superview convertPoint:point toView:currentSuperView];
    self.layer.affineTransform = CGAffineTransformIdentity;
    [self adjustPosition:point]; // 调整展示的位置 - frame
    
    // 调整箭头位置
    if (point.x <= kMargin + kRadius + kTriangleHeight * 0.7) {
        arrowPointX = kMargin + kRadius;
    }else if (point.x >= kScreenWidth - kMargin - kRadius - kTriangleHeight * 0.7){
        arrowPointX = self.width - kMargin - kRadius;
    }else{
        arrowPointX = point.x - self.left;
    }
    
    // 调整anchorPoint
    CGPoint aPoint = CGPointMake(0.5, 0.5);
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        aPoint = CGPointMake(arrowPointX / self.width, 1);
    }else{
        aPoint = CGPointMake(arrowPointX / self.width, 0);
    }
    
    // 调整layer
    CAShapeLayer *layer = [self getBorderLayer];
    if (self.bottom> kScreenHeight) {
        layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);
        self.top = point.y - self.height;
    }
    
    // 调整frame
    CGRect rect = self.frame;
    self.layer.anchorPoint = aPoint;
    self.frame = rect;
    
    self.layer.mask = layer;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _backView.alpha = 0.3;
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)adjustPosition:(CGPoint)point{
    self.left = point.x - self.width * 0.5;
    self.top = point.y + kMargin;
    if (self.left < kMargin) {
        self.left = kMargin;
    }else if (self.left > kScreenWidth - kMargin - self.width){
        self.left = kScreenWidth - kMargin - self.width;
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)updateFrameForMenu{
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    menuView.maxValueForItemCount = menuView.menuDataArray.count;
    menuView.transform = CGAffineTransformMakeScale(1.0, 1.0);;
    menuView.contentTableView.height = kRowHeight * menuView.maxValueForItemCount;
    menuView.height = kRowHeight * menuView.maxValueForItemCount + kTriangleHeight * 2 - 0.5;
    menuView.layer.mask = [menuView getBorderLayer];
    menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
}

- (void)hiddenMenu{
    self.contentTableView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
        _backView.alpha = 0;
    }];
}

- (void)tap:(UITapGestureRecognizer *)sender{
    if (self.backViewTapBlock) {
        self.backViewTapBlock();
    }
    [self hiddenMenu];
    
}
- (CAShapeLayer *)getBorderLayer{
    // 上下左右的圆角中心点
    CGPoint upperLeftCornerCenter = CGPointMake(kRadius, kTriangleHeight + kRadius);
    CGPoint upperRightCornerCenter = CGPointMake(self.width - kRadius, kTriangleHeight + kRadius);
    CGPoint bottomLeftCornerCenter = CGPointMake(kRadius, self.height - kTriangleHeight - kRadius);
    CGPoint bottomRightCornerCenter = CGPointMake(self.width - kRadius, self.height - kTriangleHeight - kRadius);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath addArcWithCenter:upperLeftCornerCenter radius:kRadius startAngle:M_PI endAngle:M_PI * 3 * 0.5 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(arrowPointX - kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(arrowPointX, 0)];
    [bezierPath addLineToPoint:CGPointMake(arrowPointX + kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(self.width - kRadius, kTriangleHeight)];
    [bezierPath addArcWithCenter:upperRightCornerCenter radius:kRadius startAngle:M_PI * 3 * 0.5 endAngle:0 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(self.width, self.height - kTriangleHeight - kRadius)];
    [bezierPath addArcWithCenter:bottomRightCornerCenter radius:kRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(kRadius, self.height - kTriangleHeight)];
    [bezierPath addArcWithCenter:bottomLeftCornerCenter radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath closePath];
    borderLayer.path = bezierPath.CGPath;
    return borderLayer;
}

#pragma mark --- 类方法封装
+ (CommonMenuView *)createMenuWithFrame:(CGRect)frame target:(UIView *)currentView dataArray:(NSArray *)dataArray itemsClickBlock:(void(^)(NSString *str, NSInteger tag))itemsClickBlock backViewTap:(void(^)())backViewTapBlock{
    
//    CGFloat menuWidth = frame.size.width ? frame.size.width : 120;
    CGFloat menuWidth = kScreenWidth;
    
    CommonMenuView *menuView = [[CommonMenuView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, kRowHeight * dataArray.count) WithView:currentView];
    menuView.selfMenu = menuView;
    menuView.itemsClickBlock = itemsClickBlock;
    menuView.backViewTapBlock = backViewTapBlock;
    menuView.menuDataArray = [NSMutableArray arrayWithArray:dataArray];
    menuView.maxValueForItemCount = 10;
    menuView.tag = kMenuTag;
    return menuView;
}

+ (void)showMenuAtPoint:(CGPoint)point{
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    [menuView displayAtPoint:point];
}

+ (void)hidden{
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    [menuView hiddenMenu];
}

+ (void)clearMenu{
    [CommonMenuView hidden];
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    UIView *coverView = [[UIApplication sharedApplication].keyWindow viewWithTag:kCoverViewTag];
    [menuView removeFromSuperview];
    [coverView removeFromSuperview];
}

+ (void)appendMenuItemsWith:(NSArray *)appendItemsArray{
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    NSMutableArray *tempMutableArr = [NSMutableArray arrayWithArray:menuView.menuDataArray];
    [tempMutableArr addObjectsFromArray:appendItemsArray];
    menuView.menuDataArray = tempMutableArr;
    [menuView.contentTableView reloadData];
    [menuView updateFrameForMenu];
}

+ (void)updateMenuItemsWith:(NSArray *)newItemsArray WithIndex:(NSInteger)index{
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    [menuView.menuDataArray removeAllObjects];
    menuView.menuDataArray = [NSMutableArray arrayWithArray:newItemsArray];
    menuView.currentIndex = index;
    [menuView.contentTableView reloadData];
    [menuView updateFrameForMenu];
}


@end
