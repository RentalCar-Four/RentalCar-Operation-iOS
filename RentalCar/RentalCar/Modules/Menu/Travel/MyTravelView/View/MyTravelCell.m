//
//  MyTravelCell.m
//  RentalCar
//
//  Created by Hulk on 2017/3/17.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "MyTravelCell.h"
#import "LBorderView.h"

@interface MyTravelCell ()
@property(nonatomic,strong)UIView *cellcontentView;

@end

@implementation MyTravelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tablView indexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"statusCell%ld", indexPath.row];
    //    ELHomeTableViewCell *cell = [tablView dequeueReusableCellWithIdentifier:ID];
    MyTravelCell *cell = [tablView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyTravelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加Feed具体内容
        _cellcontentView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 0)];
        _cellcontentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        //cell设置
        self.opaque = YES;
        
        _cellcontentView.layer.cornerRadius = autoScaleW(5);
        _cellcontentView.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
        _cellcontentView.layer.shadowOpacity = 0.2; //透明度
        _cellcontentView.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
        _cellcontentView.layer.shadowRadius = autoScaleW(2); //模糊度
        
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"#FBFBFB"]];
        [self.contentView addSubview:self.cellcontentView];
    }
    
    return self;
}

- (void)setupDetailView{
    CGRect contentRect = _cellcontentView.frame;
    
    contentRect.size.height = autoScaleH(190)-10;
    _cellcontentView.frame = contentRect;
    
    //添加工具条
    
    [self BuildUI];
}
//@property(nonatomic,copy)NSString * rentNum; //租赁单号
//@property(nonatomic,copy)NSString * numberPlate;//车牌号
//@property(nonatomic,copy)NSString * startTime;//租赁开始 时间
//@property(nonatomic,copy)NSString * endTime;//租赁结束 时间
//@property(nonatomic,copy)NSString * startLocation;//租赁时的地址
//@property(nonatomic,copy)NSString * endLocation;//还车时的地址
//@property(nonatomic,copy)NSString * totalFee;//租赁总费用（元）
//@property(nonatomic,copy)NSString * leaseMinutes;//租赁时长（分钟）
//@property(nonatomic,copy)NSString * leaseMileage;//行驶里程（公里）
-(void)BuildUI{
    CGFloat mg = 10;
    UIImageView *timeIcon = [[UIImageView alloc]init];
//    [timeIcon setBackgroundColor:[UIColor redColor]];
    [timeIcon setImage:[UIImage imageNamed:@"icon_ListTime"]];
    [timeIcon setContentMode:UIViewContentModeScaleAspectFit];
    [timeIcon setFrame:CGRectMake(autoScaleW(22), autoScaleH(21), autoScaleW(10), autoScaleH(10))];
    CGFloat timeLabelX = CGRectGetMaxX(timeIcon.frame);
    UILabel *timeLabel = [[UILabel alloc]init];
//    [timeLabel setBackgroundColor:[UIColor blackColor]];
    [timeLabel setText:[NSString stringWithFormat:@"01月23日 22:30"]];
    [timeLabel setText:[NSString stringWithFormat:@"%@", self.model.startTime]];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setFrame:CGRectMake(timeLabelX+mg, autoScaleH(19), kScreenWidth-autoScaleW(5*16)-timeLabelX+mg-autoScaleW(57), autoScaleH(12))];
    [timeLabel setTextColor:[UIColor colorWithHexString:@"#909090"]];
    [_cellcontentView addSubview:timeIcon];
    [_cellcontentView addSubview:timeLabel];
    
    
    UILabel *carNumLB = [[UILabel alloc]init];
    //    [timeLabel setBackgroundColor:[UIColor blackColor]];
    [carNumLB setText:[NSString stringWithFormat:@"%@", self.model.numberPlate]];
    [carNumLB setFont:[UIFont systemFontOfSize:12]];
    [carNumLB setFrame:CGRectMake(timeLabel.right+2, autoScaleH(7), autoScaleW(5*16), autoScaleH(17))];
    [carNumLB setTextColor:[UIColor colorWithHexString:@"#909090"]];
    carNumLB.font = kAvantiBoldSize(0);
    [_cellcontentView addSubview:carNumLB];
    carNumLB.centerY = timeLabel.centerY;
    
    
    
    
    
    UIImageView *startPointIcon= [[UIImageView alloc]init];
//    [startPointIcon setBackgroundColor:[UIColor redColor]];
    [startPointIcon setImage:[UIImage imageNamed:@"icon_ListStart"]];
    [startPointIcon setContentMode:UIViewContentModeScaleAspectFit];
    [startPointIcon setFrame:CGRectMake(autoScaleW(22), autoScaleH(53), autoScaleW(10), autoScaleH(10))];
    CGFloat startPointIconX = CGRectGetMaxX(timeIcon.frame);
    UILabel *startPointLabel =[[UILabel alloc]init];
    [startPointLabel setFont:[UIFont systemFontOfSize:12]];
//    [startPointLabel setBackgroundColor:[UIColor blackColor]];
    [startPointLabel setText:[NSString stringWithFormat:@"五道口优盛大厦地面停车场啥看的辅导教师可能发李斯丹妮菲利克斯东方老师的能否开始的路费"]];
    startPointLabel.numberOfLines = 0;
     [startPointLabel setText:[NSString stringWithFormat:@"%@", self.model.startLocation]];
    [startPointLabel setFrame:CGRectMake(startPointIconX+mg, autoScaleH(40), kScreenWidth-(startPointIconX+mg)-20, autoScaleH(36))];
    [startPointLabel setTextColor:[UIColor colorWithHexString:@"#909090"]];
    
    [_cellcontentView addSubview:startPointIcon];
    [_cellcontentView addSubview:startPointLabel];
    
    UIImageView *endPointIcon= [[UIImageView alloc]init];
//    [endPointIcon setBackgroundColor:[UIColor redColor]];
    [endPointIcon setImage:[UIImage imageNamed:@"icon_ListOver"]];
    [endPointIcon setContentMode:UIViewContentModeScaleAspectFit];
    [endPointIcon setFrame:CGRectMake(autoScaleW(22), autoScaleH(93), autoScaleW(10), autoScaleH(10))];
    CGFloat endPointIconX = CGRectGetMaxX(timeIcon.frame);
    UILabel *endPointLabel =[[UILabel alloc]init];
    [endPointLabel setFont:[UIFont systemFontOfSize:12]];
//    [endPointLabel setBackgroundColor:[UIColor blackColor]];
    [endPointLabel setText:[NSString stringWithFormat:@"回龙观华联商场地下停车场是对方还是靠辅导教师看大家分好少点击付款红色经典客户反馈是对方还是空的"]];
    endPointLabel.numberOfLines = 0;
    [endPointLabel setText:[NSString stringWithFormat:@"%@", self.model.endLocation]];
    [endPointLabel setFrame:CGRectMake(endPointIconX+mg, autoScaleH(80), kScreenWidth-(endPointIconX+mg)-20, autoScaleH(35))];
    [endPointLabel setTextColor:[UIColor colorWithHexString:@"#909090"]];
    
    [_cellcontentView addSubview:endPointIcon];
    [_cellcontentView addSubview:endPointLabel];
    
    
    
    CGFloat  viewLineY = CGRectGetMaxY(endPointLabel.frame);
    LBorderView *viewLine = [[LBorderView alloc]init];
    
    [viewLine setFrame:CGRectMake(autoScaleW(0), viewLineY+16, _cellcontentView.width,0 )];
    
    [viewLine setBorderColor:[UIColor colorWithHexString:@"#EEF2F5"]];
    viewLine.borderType = BorderTypeDashed;
    viewLine.dashPattern = 6;
    viewLine.spacePattern = 5;
    viewLine.borderWidth = 1;
    viewLine.cornerRadius = 0;
    
    [_cellcontentView addSubview:viewLine];
    
    CGFloat bottomLabelY =autoScaleH(136);
    
    UILabel *distanceLabel = [[UILabel alloc]init];
    [distanceLabel setText:[NSString stringWithFormat:@"共计118分钟"]];
    
    [distanceLabel setTextColor:[UIColor colorWithHexString:@"#949494"]];
    [distanceLabel setFont:[UIFont systemFontOfSize:12]];
    [distanceLabel setFrame:CGRectMake(startPointIconX+mg, bottomLabelY, _cellcontentView.width/4, 20)];
//    [distanceLabel setBackgroundColor:[UIColor blackColor]];
    
    NSString *distanceLabelstr =[NSString stringWithFormat:@"共计%@分钟",self.model.leaseMinutes];
    CGSize distanceLabeltextSize = [distanceLabelstr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGRect distanceLabelFrame =(CGRect){{startPointIconX+mg, bottomLabelY+7} , {distanceLabeltextSize.width,20} };
    
    distanceLabel.frame =distanceLabelFrame;
    [distanceLabel setText:distanceLabelstr];
    
    UILabel *distanceTime = [[UILabel alloc]init];
    [distanceTime setFrame:CGRectMake(distanceLabel.width+distanceLabel.origin.x+5, bottomLabelY+7, _cellcontentView.width/4, 20)];
    [distanceTime setText:[NSString stringWithFormat:@"(多少公里)"]];
    
    [distanceTime setText:[NSString stringWithFormat:@"(%@公里)",self.model.leaseMileage]];
   
    [distanceTime setTextColor:[UIColor colorWithHexString:@"#C7C7C7"]];
    [distanceTime setFont:[UIFont systemFontOfSize:12]];

    [_cellcontentView addSubview:distanceLabel];
//    [_cellcontentView addSubview:distanceTime];

    
    UIButton *orderRentStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cellcontentView.width-70, bottomLabelY+5, 55, 24)];
    orderRentStatusBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_cellcontentView addSubview:orderRentStatusBtn];
    orderRentStatusBtn.enabled = NO;
    orderRentStatusBtn.cornerRadius = 5;
    if ([self.model.status integerValue]==0) {
        [orderRentStatusBtn setTitle:@"运维中" forState:UIControlStateNormal];
        [[APPUtil share] setButtonClickStyle:orderRentStatusBtn Shadow:YES normalBorderColor:0 selectedBorderColor:0 BorderWidth:0 normalColor:kBlueColor selectedColor:UIColorFromRGB(0x09C58A) cornerRadius:autoScaleW(5)];
            [orderRentStatusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [orderRentStatusBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [orderRentStatusBtn setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
    }
    
//    NSString *money = [APPUtil multiplyingBy:self.model.totalFee and:@"1"];
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共消费 %@ 元",money]];
//    [attributedStr addAttribute:NSFontAttributeName value:kAvantiBoldSize(5) range:NSMakeRange(4, money.length)];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x5A5A5A) range:NSMakeRange(4, money.length)];
//    priceLab.attributedText = attributedStr;
}

@end
