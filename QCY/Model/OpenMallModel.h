//
//  OpenMallModel.h
//  QCY
//
//  Created by i7colors on 2018/10/29.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

/*** company类 ***/
@interface Company : NSObject

@property (nonatomic, copy)NSString *companyName;               //公司名字
@property (nonatomic, copy)NSString *tel;                       //公司联系方式
@property (nonatomic, copy)NSString *provinceName;              //所在省
@property (nonatomic, copy)NSString *cityName;                  //所在市
@end

/*** 标签类 ***/
@interface BusinessList : NSObject
@property (nonatomic, copy)NSString *value;                     //标签名字
@end

@interface OpenMallModel : NSObject

@property (nonatomic, copy)NSString *logo;                      //公司logo
@property (nonatomic, strong)Company *company;                  //company类
@property (nonatomic, strong)NSMutableArray *businessList;      //主营标签数组
@property (nonatomic, copy)NSString *storeID;                   //店铺id，获取店铺详情时需要
@end

/*** 基本参数的键值对 ***/
@interface PropMap : NSObject
@property (nonatomic, copy)NSString *key;                       //key
@property (nonatomic, copy)NSString *value;                     //value

@end

@interface ProductInfoModel : NSObject

@property (nonatomic, copy)NSString *pic;                       //产品图片
@property (nonatomic, copy)NSString *productName;               //产品名字
@property (nonatomic, copy)NSString *pack;                      //产品规格
@property (nonatomic, copy)NSString *price;                     //产品价格
@property (nonatomic, copy)NSString *unit;                      //产品单位
@property (nonatomic, copy)NSString *banner1;                   //轮播图1
@property (nonatomic, copy)NSString *banner2;                   //轮播图2
@property (nonatomic, copy)NSString *banner3;                   //轮播图3
@property (nonatomic, copy)NSString *banner4;                   //轮播图4
@property (nonatomic, copy)NSString *banner5;                   //轮播图5
@property (nonatomic, copy)NSString *logo;                      //公司logo
@property (nonatomic, assign)NSInteger creditLevel;             //星级评价
@property (nonatomic, copy)NSString *companyName;               //公司名字
@property (nonatomic, copy)NSString *descriptionStr;            //公司简介
@property (nonatomic, copy)NSString *shopId;                    //跳转到店铺主页的ID
@property (nonatomic, copy)NSString *supplierShotName;          //供应商名字
@property (nonatomic, copy)NSArray *tagList;                    //标签
@property (nonatomic, copy)NSString *productID;                 //产品大厅的产品ID，获取产品详情
@property (nonatomic, copy)NSString *phone;                     //客服手机号，没有就填我们公司的电话

//基本参数的key和value
@property (nonatomic, copy)NSArray *propMap;                    //基本参数数组
@end




NS_ASSUME_NONNULL_END
