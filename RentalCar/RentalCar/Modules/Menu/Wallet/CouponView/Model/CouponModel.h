//
//  CouponModel.h
//  RentalCar
//
//  Created by Hulk on 2017/4/1.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "BaseItem.h"

@interface CouponModel : BaseItem
@property(nonatomic,copy)NSString *amount;//数量。类型为 1 时，单位是分钟；类型是 2 、 3 时，单位是元；类型是 4 时，表示打折
@property(nonatomic,copy)NSString *areaLimit;//区域限制。 1 不限， 2 分区域
@property(nonatomic,copy)NSString *areaLimitDesc;//区域限制描述 例如：仅限宁海使用
@property(nonatomic,copy)NSString *couponId;//优惠券 ID
@property(nonatomic,copy)NSString *effetiveDate;//生效日期【 yyyy-MM-dd 】
@property(nonatomic,copy)NSString *expirationDate;//作废日期【 yyyy-MM-dd 】
@property(nonatomic,copy)NSString *isExpired;//是否已过期（ 0 未过期， 1 已过期）
@property(nonatomic,copy)NSString *type;//类型  1 原代时券（可多次使用）， 2 原代金券（可多次使用）， 3 新金额优惠券（单次使用）， 4 新打折券（单次使用）
@property(nonatomic,copy)NSString *useLimit;// 产品限制。 1 不限， 2 分时， 3 长租
@property(nonatomic,copy)NSString *useLimitDesc;// 产品限制描述 例如:仅限分时用车使用
@end
