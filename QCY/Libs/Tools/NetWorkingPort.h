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
//#define URL_ALL_API @"http://192.168.11.54:9919/app-web/"
//外网
//#define URL_ALL_API @"http://116.236.181.54:9919/app-web/"
//线上测试
//#define URL_ALL_API @"https://i7apptest.i7colors.com/app-web/"
//正式
#define URL_ALL_API @"https://i7app.i7colors.com/app-web/"

//#define URL_ALL_API @"https://i7appmain.i7colors.com/app-web/"

//#define URL_ALL_API @"https://i7appback.i7colors.com/app-web/"


#define Page_Count 50

/******************************** get请求 ********************************/

//获取ApiToken
#define URL_API_TOKEN @"user/getRequestSign?code=%@"
//获取图形验证码
#define URL_IMG_CODE @"captcha?deviceNo=%@"
//获取首页数据
#define URL_HomePage_List @"index/getAllData?sign=QCYDSSIGNCDD&token=%@&pageNo=1&pageSize=8"
//获取首页数据&&检查更新
#define URL_HomePage_List_CheckUpdate @"index/getAllDataNew?sign=QCYDSSIGNCDD&token=%@&pageNo=1&pageSize=8&iosVersionCode=%@"
//求购列表
#define URL_ASKTOBUY_LIST @"enquiry/getEnquiryList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
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
//求购列表
#define URL_MYASK_BUY @"enquiry/getMyEnuqiryList?sign=QCYDSSIGNCDD&token=%@&status=%@&pageNo=%d&pageSize=%d"
//求购搜索列表
#define URL_AskBuy_SearchList @"enquiry/getEnquiryListByKeyword?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&productName=%@"
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
#define URL_Shop_List @"market/getMarketList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&name=%@"
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
//首页搜索
#define URL_HomePage_search @"index/searchData?sign=QCYDSSIGNCDD&token=%@&keyWord=%@&pageNo=%d&pageSize=%d"
//获取求购消息
#define URL_AskBuy_Msg_List @"user/getMallEnquiryInformList?sign=QCYDSSIGNCDD&token=%@&type=%@&pageNo=%d&pageSize=%d"
//获取系统消息
#define URL_System_Msg_List @"user/getSystemInformList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&deviceNo=%@"
//获取求购消息详情
#define URL_AskBuy_Msg_Detail @"user/getMallEnquiryInformDetail?sign=QCYDSSIGNCDD&token=%@&id=%@"
//获取朋友圈列表
#define URL_Friend_List @"dyeCommunity/queryDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取帖子详情
#define URL_FC_Detail @"dyeCommunity/queryDyeCommunityDetail?sign=QCYDSSIGNCDD&id=%@"
//获取用户信息
#define URL_Friend_UserInfo @"user/getUserInfoDetail?sign=QCYDSSIGNCDD&token=%@&userId=%@"
//获取我的用户信息
#define URL_Friend_MyInfo @"user/getMyInfoDetail?token=%@&sign=QCYDSSIGNCDD"
//获取其他用户帖子列表
#define URL_User_Friend_InfoList @"dyeCommunity/queryDyeCommunityListByUserId?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&userId=%@"
//获取我的帖子列表
#define URL_My_Friend_InfoList @"dyeCommunity/queryMyDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取粉丝列表
#define URL_Fans_List @"dyeFollow/queryFollowListByUserId?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&userId=%@"
//获取我的粉丝列表
#define URL_My_Fans_List @"dyeFollow/queryMyFollowList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取未读消息个数
#define URL_Unread_MsgCounts @"dyeCommunity/queryMyNotReadCommentCount?sign=QCYDSSIGNCDD&token=%@"
//获取评论列表
#define URL_Comment_List @"dyeCommunity/queryDyeCommentListByDyeId?sign=QCYDSSIGNCDD&token=%@&dyeId=%@&pageNo=%d&pageSize=%d"
//获取点赞列表
#define URL_Zan_List @"dyeCommunity/queryDyeLikeListByDyeId?sign=QCYDSSIGNCDD&dyeId=%@&pageNo=%d&pageSize=%d"
//朋友圈未读消息列表
#define URL_UnRead_MsgList @"dyeCommunity/queryMyNotReadCommentList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//优惠展销
#define URL_DisCount_sales @"sales/querySalesMainList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//展销详情
#define URL_DisCount_Sales_Detail @"sales/getSalesMainById?sign=QCYDSSIGNCDD&id=%@"
//优惠展销记录
#define URL_Discount_sales_Already @"sales/querySalesOrderList?sign=QCYDSSIGNCDD&salesId=%@&pageNo=%d&pageSize=%d"
//采购联盟列表
#define URL_Purchase_League_List @"meetingName/queryMeetingNameList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//我的订/供货单列表 - 0 是订货，1是供货
#define URL_My_Ordergoods_list @"meetingShop/queryMeetingUserShopList?sign=QCYDSSIGNCDD&orderStatus=%@&phone=%@&pageNo=%d&pageSize=%d"
//获取系统采购或供货的列表
#define URL_System_Goods_List @"meetingShop/queryAddMeetingShopList?sign=QCYDSSIGNCDD&meetingId=%@&orderStatus=%@"
//投票
#define URL_Vote_NameList @"voteMain/queryVoteMainList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//活动详情
#define URL_Vote_Detail @"voteMain/getVoteMainById?sign=QCYDSSIGNCDD&id=%@"
//参赛人员列表
#define URL_Vote_Participant_List @"voteApplication/queryVoteApplicationList?sign=QCYDSSIGNCDD&token=%@&mainId=%@&name=%@&number=%@&pageNo=%d&pageSize=%d"
//参赛人员详情
#define URL_Vote_Joiner_Detail @"voteApplication/getVoteApplicationById?sign=QCYDSSIGNCDD&token=%@&mainId=%@&id=%@"

//获取竞拍列表
#define URL_Auction_List @"auction/queryAuctionList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//竞拍详情
#define URL_Auction_Detail @"auction/getAuctionById?sign=QCYDSSIGNCDD&id=%@"
//竞拍出价记录
#define URL_Auction_PriceRecord @"auction/queryAuctionBuyerList?sign=QCYDSSIGNCDD&auctionId=%@&pageNo=%d&pageSize=%d"

/******************************** post请求 ********************************/
//用户登录
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
//上传/修改头像
#define URL_Upload_Header @"user/updateUserHeadPhoto"
//注册短信验证码
#define URL_Msg_Code_Register @"user/send_sms_code_register"
//用户注册
#define URL_User_Register @"user/register"
//找回密码-短信验证码
#define URL_Msg_Code_Findpass @"user/send_sms_code_password"
//找回密码-校验短信验证码
#define URL_Msg_Code_Check @"user/checkSmsCode"
//重设密码
#define URL_Reset_PassWord @"user/updatePassword"
//修改密码
#define URL_Change_PassWord @"user/updateUserPassword"
//微信登录
#define URL_WeiChat_Login @"wx/onWxLogin"
//绑定手机号发送验证码
#define URL_Msg_Code_BindPhone @"wx/send_sms_code_password"
//绑定手机号
#define URL_Bind_PhoneNum @"wx/bindPhone"
//发表评论
#define URL_Publish_Comments @"dyeCommunity/addDyeComment"
//发朋友圈
#define URL_Publish_FriendCircle @"dyeCommunity/addDyeCommunity"
//添加关注
#define URL_Add_Focus @"dyeFollow/addDyeFollowByUserId"
//取消关注
#define URL_Cancel_Focus @"dyeFollow/cancelDyeFollowByUserId"
//删除帖子
#define URL_Delete_FriendCricle @"dyeCommunity/cancelDyeCommunity"
//删除自己的评论
#define URL_Delete_MyComment @"dyeCommunity/cancelDyeComment"
//点赞
#define URL_Click_Zan @"dyeCommunity/addDyeLike"
//大V认证
#define URL_BigV_Cert @"user/CertV"
//修改朋友圈信息
#define URL_Change_FCInfo @"user/updateMyDyeInfo"
//参与认购
#define URL_Join_Discount_Buy @"sales/addSalesOrder"
//订货
#define URL_Order_Goods @"meetingShop/addMeetingShop"
//发起投票
#define URL_Vote_Start @"voteJoin/addVoteJoin"
//申请参与投票
#define URL_Apply_JoinVote @"voteApplication/addVoteApplication"
//查看我的货单时获取短信验证码
#define URL_Cglm_Get_SMS @"meetingShop/registerCode"
//采购联盟验证短信
#define URL_Cglm_Check_SMS @"meetingShop/verifycode"
//参与竞拍
#define URL_Join_Auction @"auction/addAuctionBuyer"


#endif /* NetWorkingPort_h */
