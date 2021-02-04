//
//  AuctionModel.h
//  QCY
//
//  Created by i7colors on 2019/3/4.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionsModel.h"
#import <UIKit/UIKit.h>
#import <MJExtension.h>


NS_ASSUME_NONNULL_BEGIN

@interface AuctionModel : NSObject
@property (nonatomic, copy)NSString *shopName;                  //商品名称
@property (nonatomic, copy)NSString *productPic;                //商品图片
@property (nonatomic, copy)NSString *address;                   //货源地
@property (nonatomic, copy)NSString *maxPrice;                  //当前价格
@property (nonatomic, copy)NSString *priceUnit;                 //价格单位
@property (nonatomic, copy)NSString *price;                     //起拍价
@property (nonatomic, copy)NSString *isType;                    //1未开始，2进行中，3成交，0已流拍
@property (nonatomic, copy)NSString *startTime;                 //开始时间
@property (nonatomic, copy)NSString *endTime;                   //结束时间
@property (nonatomic, copy)NSString *jpID;                      //竞拍ID
//总量
@property (nonatomic, copy)NSString *num;
//单位
@property (nonatomic, copy)NSString *numUnit;
//公司名字
@property (nonatomic, copy)NSString *companyName;
//货源地 - an
@property (nonatomic, copy)NSString *sourceOfSupply;
//来自PC还是系统发起-(system表示管理系统添加，pc表示用户自己发起的抢购)
@property (nonatomic, copy)NSString *from;
//cell的高
@property (nonatomic, assign)CGFloat cellHeight;
//电话
@property (nonatomic, copy)NSString *phone;
//是否包含运费
@property (nonatomic, copy)NSString *isFreight;
//抢购须知-第一条备注
@property (nonatomic, copy)NSString *remark;


//竞拍详情
@property (nonatomic, copy)NSString *count;                     //出价次数
@property (nonatomic, assign)long long overTime;                //结束时间戳
@property (nonatomic, copy)NSString *addPrice;                  //加价幅度
@property (nonatomic, copy)NSString *freight;                   //运费
@property (nonatomic, copy)NSString *manufacturer;              //生产产家
@property (nonatomic, copy)NSString *dateOfProduction;          //生产时间
@property (nonatomic, copy)NSString *auctionDetails;            //自定义属性名（可能为空，空不显示
@property (nonatomic, copy)NSString *detailsValue;              //自定义属性值
@property (nonatomic, copy)NSString *auctionDetails1;           //自定义1属性名
@property (nonatomic, copy)NSString *detailsValue1;             //自定义1属性值
@property (nonatomic, copy)NSArray *attributeList;              //拍品描述数组
@property (nonatomic, copy)NSArray *instructionsList;           //竞拍须知数组
@property (nonatomic, copy)NSArray *detailList;                 //介绍图片地址
@property (nonatomic, copy)NSArray *videoList;                  //视频链接
@end


@interface AuctionRecordModel : NSObject
@property (nonatomic, copy)NSString *phone;                     //联系方式
@property (nonatomic, copy)NSString *city;                      //市
@property (nonatomic, copy)NSString *price;                     //价格
@property (nonatomic, copy)NSString *createdAt;                 //出价时间

@end


@interface AttributeListModel : NSObject
@property (nonatomic, copy)NSString *shuXing;                   //属性名
@property (nonatomic, copy)NSString *zhi;                       //属性值
//cell高度
@property (nonatomic, assign)CGFloat cellHeight;
@end



@interface InstructionsListModel : NSObject
@property (nonatomic, copy)NSString *relatedInstructions;       //文本
//cell高度
@property (nonatomic, assign)CGFloat cellHeight;
@end

@interface DetailPcPicModel : NSObject
@property (nonatomic, copy)NSString *detailPcPic;               //介绍图片地址
@end

@interface VideoListModel : NSObject
@property (nonatomic, copy)NSString *videoName;                 //视频名称
@property (nonatomic, copy)NSString *videoUrl;                  //视频链接

@end



NS_ASSUME_NONNULL_END

