//
//  LeftMenuCell.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/7.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIButton alloc] initWithFrame:CGRectMake(30,autoScaleH( (self.height-24)/2+autoScaleH(3)) , 24, 24)];
        self.imgView.clipsToBounds = YES;
        [self.imgView setUserInteractionEnabled:NO];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(self.imgView.right+10,autoScaleH(self.height/2 -autoScaleH(15)-autoScaleH(2)), self.width-self.imgView.right-10,autoScaleH(40))];
        _titleLab.textColor = [UIColor darkGrayColor];
        _titleLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLab];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    debugLog(@"%d",selected);
    if (self.isSelected == YES) {
        self.imgView.selected =YES;
        
    }else{
        self.imgView.selected =NO;
    }
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setSelected:highlighted animated:animated];
    
    if (self.isHighlighted == YES) {
        self.imgView.highlighted =YES;
        
    }else{
        self.imgView.highlighted =NO;
    }
}




@end
