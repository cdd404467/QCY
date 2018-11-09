//
//  NetWorkingPort.h
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#ifndef NetWorkingPort_h
#define NetWorkingPort_h

//总地址
//外网
#define URL_ALL_API @"http://116.236.181.54:9919/app-web/"
//线上测试
//#define URL_ALL_API @"https://i7apptest.i7colors.com/app-web/"


#define Page_Count 50

/******************************** get请求 ********************************/

//获取ApiToken
#define URL_API_TOKEN @"user/getRequestSign?code=%@"
//获取图形验证码
#define URL_IMG_CODE @"captcha?deviceNo=%@"
//获取首页数据
#define URL_HomePage_List @"index/getAllData?sign=QCYDSSIGNCDD&token=%@&pageNo=1&pageSize=8"
//求购列表
#define URL_ASKTOBUY_LIST @"enquiry/getEnquiryList?sign=QCYDSSIGNCDD&token=%@&pageNo=%ld&pageSize=%ld"
//求购详情
#define URL_ASKTOBUY_DETAIL @"enquiry/getEnquiryDetail?sign=QCYDSSIGNCDD&token=%@&enquiryId=%@"
//已报价供应商列表
#define URL_OFFERLIST_SUPPLIER @"enquiryOffer/getEnquiryOfferList?sign=QCYDSSIGNCDD&token=%@&enquiryId=%@"
//获取供应商ID
#define URL_GET_SUPID @"enquiry/getClassification?sign=QCYDSSIGNCDD&parentId=%@"
//获取报价列表
#define URL_OFFER_LIST @"enquiryOffer/getMyEnquiryOfferList?sign=QCYDSSIGNCDD&token=%@&status=%@&pageNo=%d&pageSize=%d"
//报价详情
#define URL_PRICE_DETAIL @"enquiryOffer/getMyEnquiryOfferDetail?sign=QCYDSSIGNCDD&id=%@&token=%@"
//我的求购列表
#define URL_MYASK_BUY @"enquiry/getMyEnuqiryList?sign=QCYDSSIGNCDD&token=%@&status=%@&pageNo=%d&pageSize=%d"
//获取我的页面显示的数目
#define URL_Get_Mine_Num @"enquiry/getAllCount?sign=QCYDSSIGNCDD&token=%@"

/*** 新接口 ***/
//获取进行中的求购列表
#define URL_MyAsking_List @"enquiry/getIsEnquiryList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取待确认报价列表
#define URL_NeedAffirmList @"enquiry/getWaitSureList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取即将过期的求购列表
#define URL_WillPast_List @"enquiry/getMyExpireList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//我的被接受报价列表
#define URL_MyAccepted_List @"enquiryOffer/getMyAcceptEnquiryOfferList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"


//开放商城，获取店铺列表
#define URL_Shop_List @"market/getMarketList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//获取店铺主页产品列表
#define URL_Shop_Product_List @"marketProduct/getMarketProductByPage?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&marketId=%@"
//获取店铺主页详情
#define URL_Shop_Info @"market/getMarket?sign=QCYDSSIGNCDD&id=%@"
//获取产品列表(产品大厅)
#define URL_Product_List @"product/getProductList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&aliasName=%@"
//获取产品详情
#define URL_Product_DetailInfo @"product/getProductDetail?sign=QCYDSSIGNCDD&id=%@"
//获取资讯列表
#define URL_Infomation_List @"information/getInformationList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&newsType=%@"
//资讯详情
#define URL_Infomation_Detail @"information/getInformationDetail?sign=QCYDSSIGNCDD&id=%@"
//获取团购列表
#define URL_GroupBuying_List @"groupBuyMain/queryGroupBuyMainList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//获取首页和团购banner
#define URL_Get_Banner @"index/getBanner?sign=QCYDSSIGNCDD&plate_code=%@"
//获取团购详情
#define URL_GroupBuy_Detail @"groupBuyMain/getGroupBuyMainById?sign=QCYDSSIGNCDD&id=%@"
//获取认购列表
#define URL_GroupBuy_Already @"groupBuyMain/queryGroupBuyerList?sign=QCYDSSIGNCDD&mainId=%@&pageNo=%d&pageSize=%d"



/******************************** post请求 ********************************/
//用户登陆
#define URL_USER_LOGIN @"user/toLogin"
//参与报价
#define URL_JOIN_OFFER @"enquiryOffer/addEnquiryOffer"
//发布求购
#define URL_POST_BUYING @"enquiry/addEnquiy"
//关闭求购
#define URL_CLOSE_BUYING @"enquiry/cancelEnquiry"
//采纳报价
#define URL_Accept_Offer @"enquiryOffer/acceptEnquiryOffer"
//已读接口
#define URL_Already_Read @"enquiryOffer/readMyAcceptOffer"
//参与认购
#define URL_Join_GroupBuy @"groupBuyMain/addGroupBuyer"



#endif /* NetWorkingPort_h */
