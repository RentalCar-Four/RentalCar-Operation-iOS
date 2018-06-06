//
//  ReturnCarAnnotationView.m
//  RentalCar
//
//  Created by zhanbing han on 17/3/21.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "ReturnCarAnnotationView.h"

@interface ReturnCarAnnotationView ()

@end

@implementation ReturnCarAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, autoScaleW(67), autoScaleW(75));
//        self.backgroundColor = [UIColor redColor];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, autoScaleW(8), autoScaleW(67), autoScaleW(67))];
        [self addSubview:_imgView];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(42), 0, autoScaleW(20), autoScaleW(20))];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:autoScaleW(12)];
        _countLabel.layer.cornerRadius = _countLabel.width/2;
        [_countLabel.layer setMasksToBounds:YES];
        _countLabel.backgroundColor = kBlueColor;
        [self addSubview:_countLabel];
    }
    
    return self;
}

- (void)setItem:(StationCarItem *)item {
    NSString *entityPileCount = item.entityPileCount;
    if ([entityPileCount integerValue]>0) {
        _imgView.image = [UIImage imageNamed:@"entity_pile"];
        _countLabel.hidden = NO;
        _countLabel.text = item.entityPileCount;
    } else {
        _imgView.image = [UIImage imageNamed:@"virtual_pile"];
        _countLabel.hidden = YES;
    }
}

@end
