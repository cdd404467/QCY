//
//  DiscountSalesModel.h
//  QCY
//
//  Created by i7colors on 2019/1/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionsModel.h"
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscountSalesModel : NSObject
/***  优惠展销的列表 ***/
@property (nonatomic, copy)NSString *productPic;                //产品图片
@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, copy)NSString *subscribedNum;             //已出售的数量
@property (nonatomic, copy)NSString *oldPrice;                  //原价
@property (nonatomic, copy)NSString *priceNew;                  //现价，可能是个范围
@property (nonatomic, copy)NSString *priceUnit;                 //价格单位
@property (nonatomic, copy)NSString *productID;                 //获取详情的产品ID


/*** 优惠展销详情额外用到的 ***/
@property (nonatomic, copy)NSString *detailMobilePic;           //基本参数图片
@property (nonatomic, copy)NSString *numUnit;                   //数量单位
@property (nonatomic, copy)NSString *totalNum;                  //总量
@property (nonatomic, copy)NSArray *listPrice;                  //优惠价数组
@end


@interface ListPrice : NSObject

@property (nonatomic, copy)NSString *salesNum;                  //数量
@property (nonatomic, copy)NSString *salesPrice;                //价格
@end

NS_ASSUME_NONNULL_END
