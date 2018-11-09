//
//  HomePageModel.h
//  QCY
//
//  Created by i7colors on 2018/10/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class OpenMallModel;

NS_ASSUME_NONNULL_BEGIN


/**
 求购大厅列表的数据模型
 */
@interface AskToBuyModel : NSObject

@property (nonatomic, copy)NSString *buyID;                     //求购id，获取详情时需要(服务端返回id，要转换)
@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, copy)NSString *num;                       //求购数量
@property (nonatomic, copy)NSString *locationProvince;          //省
@property (nonatomic, copy)NSString *locationCity;              //市区
@property (nonatomic, copy)NSString *offerNum;                  //已有报价数量
@property (nonatomic, copy)NSString *publishType;               //发布类型(判断是企业还是个人)
@property (nonatomic, copy)NSString *surplusDay;                //剩余天数
@property (nonatomic, copy)NSString *surplusHour;               //剩余小时
@property (nonatomic, copy)NSString *surplusMin;                //剩余分钟
@property (nonatomic, copy)NSString *surplusSec;                //剩余秒
@property (nonatomic, copy)NSString *numUnit;                   //数量单位
@property (nonatomic, copy)NSString *status;                    //询盘状态,status= 1，求购中；status=2，已关闭；status=3已接受报价
@property (nonatomic, copy)NSString *isCharger;                 //是否个人发布,1 - 个人
@end


@interface CompanyDomain : NSObject
@property (nonatomic, copy)NSString *provinceName;              //地区名字
@property (nonatomic, copy)NSString *companyName;               //企业的名字
@end

@interface AskToBuyDetailModel : NSObject
@property (nonatomic, copy)NSString *productName;               //产品名称
@property (nonatomic, copy)NSString *publishType;               //发布类型(判断是企业还是个人)
@property (nonatomic, copy)NSString *surplusDay;                //剩余天数
@property (nonatomic, copy)NSString *surplusHour;               //剩余小时
@property (nonatomic, copy)NSString *surplusMin;                //剩余分钟
@property (nonatomic, copy)NSString *surplusSec;                //剩余秒
@property (nonatomic, copy)NSString *enquiryTimes;              //历史求购次数
@property (nonatomic, copy)NSString *isCharger;                 //是否是自己查看 1 - 是
@property (nonatomic, copy)NSString *creditLevel;               //信用等级
@property (nonatomic, copy)NSString *companyName2;              //个人
@property (nonatomic, copy)NSString *descriptionStr;            //采购说明
@property (nonatomic, copy)NSString *status;                    //询盘状态:status= 1，求购中；status=2，已关闭；status=3,已接受报价
@property (nonatomic, strong)CompanyDomain *companyDomain;      //嵌套CompanyDomain模型
@end

/*** 报价供应商列表 ***/
@interface supOrrerModel : NSObject
@property (nonatomic, copy)NSString *publishType;               //发布类型(判断是企业还是个人)
@property (nonatomic, copy)NSString *price;                     //报价价格（null为m保密）
@property (nonatomic, copy)NSString *phone;                     //手机号
@property (nonatomic, copy)NSString *createdAtString;           //报价时间
@property (nonatomic, copy)NSString *offerID;                   //报价id
@property (nonatomic, strong)CompanyDomain *companyDomain;      //嵌套CompanyDomain模型
@property (nonatomic, copy)NSString *status;                    //询盘状态:status= 0，求购中；status=1，已关闭；status=2,已接受报价
@property (nonatomic, copy)NSString *companyName2;              //个人
@end


/*** 发布求购 ***/
@interface PostBuyingModel : NSObject
@property (nonatomic, copy)NSString *name;                      //一级分类名称
@property (nonatomic, copy)NSString *classID;                    //一级分类ID
@end

/*** 首页数据 ***/
@interface HomePageModel : NSObject
@property (nonatomic, copy)NSArray *enquiryList;
@property (nonatomic, copy)NSArray *marketList;
@end

@interface BannerModel : NSObject

@property (nonatomic, copy)NSString *ad_image;                  //轮播图
@end

NS_ASSUME_NONNULL_END
