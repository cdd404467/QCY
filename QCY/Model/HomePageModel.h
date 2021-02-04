//
//  HomePageModel.h
//  QCY
//
//  Created by i7colors on 2018/10/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension.h>
#import "BannerModel.h"


@class OpenMallModel;

NS_ASSUME_NONNULL_BEGIN


/**
 求购大厅列表的数据模型
 */
@interface AskToBuyModel : NSObject
//求购id，获取详情时需要(服务端返回id，要转换)
@property (nonatomic, copy) NSString *buyID;
//产品名称
@property (nonatomic, copy) NSString *productName;
//求购数量
@property (nonatomic, copy) NSString *num;
//省
@property (nonatomic, copy) NSString *locationProvince;
//市区
@property (nonatomic, copy) NSString *locationCity;
//已有报价数量
@property (nonatomic, copy) NSString *offerNum;
//发布类型(判断是企业还是个人)
@property (nonatomic, copy) NSString *publishType;
//求购直通车,1 是 0 不是
@property (nonatomic, copy) NSString *showInfo;
//剩余天数
@property (nonatomic, copy) NSString *surplusDay;
//剩余小时
@property (nonatomic, copy) NSString *surplusHour;
//剩余分钟
@property (nonatomic, copy) NSString *surplusMin;
//剩余秒
@property (nonatomic, copy) NSString *surplusSec;
//数量单位
@property (nonatomic, copy) NSString *numUnit;
//询盘状态,status= 1，求购中；status=2，已关闭；status=3已接受报价
@property (nonatomic, copy) NSString *status;
//是否个人发布,1 - 个人
@property (nonatomic, copy) NSString *isCharger;

/**** 详情 ***/
//历史求购次数
@property (nonatomic, copy) NSString *enquiryTimes;
//信用等级
@property (nonatomic, copy) NSString *creditLevel;
//
@property (nonatomic, copy) NSString *companyName2;
//企业名字
@property (nonatomic, copy) NSString *companyName;
//求购描述说明
@property (nonatomic, copy) NSString *descriptionStr;
//是否查看过 1是 0不是
@property (nonatomic, copy) NSString *loginUserIsShowInfo;
//当前登陆者 剩余报价次数
@property (nonatomic, copy) NSString *loginUserRemainOfferCount;
//当前登陆者 剩余查看直通车信息次数
@property (nonatomic, copy) NSString *loginUserRemainShowInfoCount;
////cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface CompanyDomain : NSObject
@property (nonatomic, copy)NSString *provinceName;              //地区名字
@property (nonatomic, copy)NSString *companyName;               //企业的名字
@end

@interface AskDetailInfoModel : NSObject
@property (nonatomic, copy)NSString *leftText;                 //左边描述文本
@property (nonatomic, copy)NSString *rightText;                //右边信息文本
@property (nonatomic, assign)CGFloat cellHeight;
@end

/**
 报价供应商列表
 */
@interface supOrrerModel : NSObject
//发布类型(判断是企业还是个人)
@property (nonatomic, copy)NSString *publishType;
//报价价格（null为m保密）
@property (nonatomic, copy)NSString *price;
//手机号
@property (nonatomic, copy)NSString *phone;
//报价时间
@property (nonatomic, copy)NSString *createdAtString;
//报价id
@property (nonatomic, copy)NSString *offerID;
//嵌套CompanyDomain模型
@property (nonatomic, strong)CompanyDomain *companyDomain;
//询盘状态:status= 0，求购中；status=1，已关闭；status=2,已接受报价
@property (nonatomic, copy)NSString *status;
//个人
@property (nonatomic, copy)NSString *companyName2;
//是否包含运费 1 - 是
@property (nonatomic, copy)NSString *isIncludeTrans;
//报价描述说明
@property (nonatomic, copy)NSString *descriptionStr;
////cell高度
@property (nonatomic, assign)CGFloat cellHeight;
@end


/**
 发布求购
 */
@interface PostBuyingModel : NSObject
//一级分类名称
@property (nonatomic, copy)NSString *name;
//一级分类ID
@property (nonatomic, copy)NSString *classID;
@end


/**
 首页数据
 */
@interface HomePageModel : NSObject
//是否是企业用户
@property (nonatomic, copy) NSString *isCompany_User;
//企业用户名字
@property (nonatomic, copy) NSString *companyName;

//求购大厅数组
@property (nonatomic, copy) NSArray<AskToBuyModel *> *enquiryList;
//开放商城数组
@property (nonatomic, copy) NSArray<OpenMallModel *> *marketList;
//产品数组
@property (nonatomic, copy) NSArray *productList;
//NO_LOGIN,用户登录信息失效；NO_TOKRN，没有token信息（之前没有登录过），LOGIN_SUCCESS,已是登录状态
@property (nonatomic, copy) NSString *login_status;
@end


NS_ASSUME_NONNULL_END
