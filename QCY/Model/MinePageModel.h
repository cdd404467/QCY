//
//  MinePageModel.h
//  QCY
//
//  Created by i7colors on 2018/10/22.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinePageModel : NSObject

@end

//报价
@interface EnquiryDomain : NSObject
@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, copy)NSString *locationProvince;          //省
@property (nonatomic, copy)NSString *locationCity;              //市
@property (nonatomic, copy)NSString *num;                       //数量
@property (nonatomic, copy)NSString *pack;                      //包装
@property (nonatomic, copy)NSString *descriptionStr;            //备注
@property (nonatomic, copy)NSString *surplusDay;                //剩余天数
@property (nonatomic, copy)NSString *surplusHour;               //剩余小时
@property (nonatomic, copy)NSString *surplusMin;                //剩余分钟
@property (nonatomic, copy)NSString *surplusSec;                //剩余秒
@property (nonatomic, copy)NSString *status;                    //状态
@property (nonatomic, copy)NSString *offerNum;                  //已经报价数量
@property (nonatomic, copy)NSString *publishType;               //发布类型(判断是企业还是个人)
@end

/*** 我的报价 ***/
@interface AskToBuyOfferModel : NSObject

@property (nonatomic, strong)EnquiryDomain *enquiryDomain;      //报价里面的类
@property (nonatomic, assign)long long offerTime;               //报价时间
@property (nonatomic, copy)NSString *price;                     //价格
@property (nonatomic, copy)NSString *isIncludeTrans;            //是否包含运费,1包含，0不包含
@property (nonatomic, copy)NSString *status;                    //状态
@property (nonatomic, copy)NSString *enquiryId;                 //报价ID,获取报价详情
@end

/*** 我的求购 ***/
@interface MyAskToBuyModel : NSObject

@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, assign)long long createdAt;               //报价时间
@property (nonatomic, copy)NSString *locationProvince;          //省
@property (nonatomic, copy)NSString *locationCity;              //市
@property (nonatomic, copy)NSString *pack;                      //包装
@property (nonatomic, copy)NSString *num;                       //数量
@property (nonatomic, copy)NSString *descriptionStr;            //备注
@property (nonatomic, copy)NSString *surplusDay;                //剩余天数
@property (nonatomic, copy)NSString *surplusHour;               //剩余小时
@property (nonatomic, copy)NSString *surplusMin;                //剩余分钟
@property (nonatomic, copy)NSString *surplusSec;                //剩余秒
@property (nonatomic, copy)NSString *status;                    //状态
@property (nonatomic, copy)NSString *offerNum;                  //已经报价数量
@property (nonatomic, copy)NSString *buyID;                     //求购id，获取详情时需要(服务端返回id，要转换)
@end

@interface MineNumberModel : NSObject

@property (nonatomic, copy)NSString *enquiryTimes;              //历史求购数目
@property (nonatomic, copy)NSString *offerTimes;                //历史报价数目
@property (nonatomic, copy)NSString *isEnquiryCount;            //正在求购中的个数
@property (nonatomic, copy)NSString *waitSureCount;             //待确认报价的个数
@property (nonatomic, copy)NSString *myExpireCount;             //即将过期的个数
//卖家中心
@property (nonatomic, copy)NSString *myAcceptOfferCount;        //即将过期的个数

@end

NS_ASSUME_NONNULL_END
