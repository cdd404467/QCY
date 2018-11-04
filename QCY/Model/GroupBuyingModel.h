//
//  GroupBuyingModel.h
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyingModel : NSObject

@property (nonatomic, copy)NSString *productPic;                //产品图片
@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, copy)NSString *totalNum;                  //总量
@property (nonatomic, copy)NSString *remainNum;                 //剩余数量
@property (nonatomic, copy)NSString *numUnit;                   //数量单位
@property (nonatomic, copy)NSString *minNum;                    //最小认购量
@property (nonatomic, copy)NSString *maxNum;                    //最大认购量
@property (nonatomic, copy)NSString *startTime;                 //开始时间
@property (nonatomic, copy)NSString *endTime;                   //结束时间
@property (nonatomic, copy)NSString *oldPrice;                  //原价
@property (nonatomic, copy)NSString *priceNew;                  //团购价
@property (nonatomic, copy)NSString *priceUnit;                 //价格单位
@property (nonatomic, copy)NSString *subscribedNum;             //已认购数量
@property (nonatomic, copy)NSString *numPercent;                //认购百分比
@property (nonatomic, copy)NSString *groupID;                   //团购ID

@property (nonatomic, copy)NSString *endCode;                   //团购状态码： 00：未开始；10：已开始未领完；11：已开始已领完；20：已结束未领完；21：已结束已领完

@property (nonatomic, copy)NSString *ad_image;                  //轮播图

@end

NS_ASSUME_NONNULL_END
