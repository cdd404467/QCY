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
//地址
@property (nonatomic, copy)NSString *address;

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
@property (nonatomic, copy)NSString *phone;                     //店铺主页电话
@property (nonatomic, copy)NSString *banner1;                   //轮播图1
@property (nonatomic, copy)NSString *banner2;                   //轮播图2
@property (nonatomic, copy)NSString *banner3;                   //轮播图3
@property (nonatomic, copy)NSString *banner4;                   //轮播图4
@property (nonatomic, copy)NSString *banner5;                   //轮播图5
@property (nonatomic, copy)NSString *companyName;               //公司名字
@property (nonatomic, assign)NSInteger creditLevel;             //星级评价
@property (nonatomic, copy)NSString *descriptionStr;            //公司简介
@property (nonatomic, copy)NSString *busInformation;            //公司信息
//联系人
@property (nonatomic, copy)NSString *contact;

//cell高度
@property (nonatomic, assign)CGFloat cellHeight_0;
@property (nonatomic, assign)CGFloat cellHeight_1;
@property (nonatomic, assign)CGFloat cellHeight_2;
@end

/*** 基本参数的键值对 ***/
@interface PropMap : NSObject
@property (nonatomic, copy)NSString *key;                       //key
@property (nonatomic, copy)NSString *value;                     //value

@end


/**
 产品分类
 */
@interface ProductClassifyModel : NSObject
//一级和二级分类ID
@property (nonatomic, copy) NSString *classifyID;
//一级分类名称
@property (nonatomic, copy) NSString *typeText;
//二级分类名称
@property (nonatomic, copy) NSString *value;
//二级分类数组
@property (nonatomic, copy) NSArray *propList;
@end

/**
 店铺分类
 */
@interface OpenMallClassifyModel : NSObject
//名称
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSString *topId;
@end



/**
 产品列表数据
 */
@interface ProductInfoModel : NSObject
//产品图片
@property (nonatomic, copy) NSString *pic;
//产品名字
@property (nonatomic, copy) NSString *productName;
//产品规格
@property (nonatomic, copy) NSString *pack;
//产品单位
@property (nonatomic, copy) NSString *unit;
//公司名字
@property (nonatomic, copy) NSString *companyName;
//跳转到店铺主页的ID
@property (nonatomic, copy) NSString *shopId;
//供应商名字
@property (nonatomic, copy) NSString *supplierShotName;
//标签
@property (nonatomic, copy) NSArray *tagList;
//产品大厅的产品ID，获取产品详情
@property (nonatomic, copy) NSString *productID;
//客服手机号，没有就填我们公司的电话
@property (nonatomic, copy) NSString *phone;
//是否显示价格 1 - 是，0 议价
@property (nonatomic, copy) NSString *displayPrice;
//详情图片数组
@property (nonatomic, copy) NSArray *detailPicList;
////基本参数数组,key和value
@property (nonatomic, copy) NSArray<PropMap *> *propMap;

/***染料、助剂、其他***/
//产品价格
@property (nonatomic, assign) double price;
//价格单位
@property (nonatomic, copy) NSString *priceUnit;
//包装规格
@property (nonatomic, copy) NSString *supplierName;
//包装形式
@property (nonatomic, copy) NSString *packLabel;
//起订数量
@property (nonatomic, copy) NSString *minNum;

/***化学品***/
//起订量单位
@property (nonatomic, copy) NSString *numUnit;
//纯度
@property (nonatomic, copy) NSString *fineness;

/***设备仪器***/
//品牌
@property (nonatomic, copy) NSString *brand;
//型号
@property (nonatomic, copy) NSString *modelNumber;
//产地
@property (nonatomic, copy) NSString *origin;
//生产日期
@property (nonatomic, copy) NSString *dateInProduced;
//外形尺寸
@property (nonatomic, copy) NSString *overallDimensions;

/***纺织品***/
//数量
@property (nonatomic, copy) NSString *num;
//颜色
@property (nonatomic, copy) NSString *colors;
//成分含量
@property (nonatomic, copy) NSString *componentContent;
//纱支
@property (nonatomic, copy) NSString *yarnCount;
//密度
@property (nonatomic, copy) NSString *densityOf;
//克重
@property (nonatomic, copy) NSString *gramWeight;
//幅宽
@property (nonatomic, copy) NSString *breadth;
//织物组织
@property (nonatomic, copy) NSString *fabric;
//具体用途
@property (nonatomic, copy) NSString *specificPurpose;
@end




NS_ASSUME_NONNULL_END
