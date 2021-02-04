//
//  ProxySaleModel.h
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProxySaleModel : NSObject
@property (nonatomic, copy)NSString *productPic;                //产品图片
@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, copy)NSString *remainNum;                 //库存
@property (nonatomic, copy)NSString *numUnit;                   //单位
@property (nonatomic, copy)NSString *price;                     //价格
@property (nonatomic, copy)NSString *priceUnit;                 //价格单位
@property (nonatomic, copy)NSString *subscribedNum;             //已售量
@property (nonatomic, copy)NSString *proxyID;                   //代销id
@property (nonatomic, copy)NSString *proxyMarketUpdateId;       //批次id
@property (nonatomic, copy)NSString *pack;                      //包装
@property (nonatomic, copy)NSArray *dictMap;                    //基本参数数组
@property (nonatomic, copy) NSArray *noteList;                  //代销须知
@property (nonatomic, copy)NSArray *rulesList;                  //
@end

@interface DictMapModel : NSObject
@property (nonatomic, copy)NSString *shuXing;                   //属性
@property (nonatomic, copy)NSString *zhi;                       //值
@end

@interface RuleModel : NSObject
@property (nonatomic, copy)NSString *relatedInstructions;       //文本
//cell高度
@property (nonatomic, assign)CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
