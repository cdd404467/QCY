//
//  NetWorkingPort.h
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#ifndef NetWorkingPort_h
#define NetWorkingPort_h


#define Page_Count 50

/******************************** get请求 ********************************/

//获取ApiToken
#define URL_API_TOKEN @"user/getRequestSign?code=%@"
//获取图形验证码
#define URL_IMG_CODE @"captcha?deviceNo=%@"
//获取首页数据
#define URL_HomePage_List @"index/getAllData?sign=QCYDSSIGNCDD&token=%@&pageNo=1&pageSize=8"
//获取首页数据&&检查更新
//#define URL_HomePage_List_CheckUpdate @"index/getAllDataNew?sign=QCYDSSIGNCDD&token=%@&pageNo=1&pageSize=8&iosVersionCode=%@"
#define URL_HomePage_List_CheckUpdate @"index/getAllDataNew2?sign=QCYDSSIGNCDD&token=%@&pageNo=1&pageSize=8&registrationId=%@&platform=app_ios&iosVersionCode=%@&deviceNo=%@"

#pragma mark - 支付模块
//微信支付
#define URLPost_Weixin_Pay @"wxpay/unifiedOrder"
//检测支付状态
#define URLPost_CheckPay_State @"wxpay/checkPayStatus"

//求购列表
#define URL_ASKTOBUY_LIST @"enquiry/getEnquiryList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//求购详情
//#define URL_ASKTOBUY_DETAIL @"enquiry/getEnquiryDetail?sign=QCYDSSIGNCDD&token=%@&enquiryId=%@"
#define URL_ASKTOBUY_DETAIL @"enquiry/getEnquiryDetailNew?sign=QCYDSSIGNCDD&token=%@&enquiryId=%@"

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
//开放商城分类
#define URL_Shop_Classify @"market/selectCompanyType?sign=QCYDSSIGNCDD"
//开放商城，获取店铺列表
#define URL_Shop_List @"market/getMarketList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&name=%@&value=%@"
//获取店铺主页产品列表
#define URL_Shop_Product_List @"marketProduct/getMarketProductByPage?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&marketId=%@"
//获取店铺主页详情
#define URL_Shop_Info @"market/getMarket?sign=QCYDSSIGNCDD&id=%@"
//产品大厅分类
#define URL_Product_Classify @"product/getShopAllPropByType?sign=QCYDSSIGNCDD&eid=%@"
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
//查看我的团购列表
#define URL_MyGroupBuying_List @"groupBuyMain/queryMyGroupBuyMainList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//
#define URL_MyBargan_List @"groupBuyMainCutPrice/queryMyGroupBuyCutPriceList?sign=QCYDSSIGNCDD&token=%@&mainId=%@&buyerId=%@&pageNo=%d&pageSize=%d"
//进入砍价页面--获取当前团购的信息
#define URL_Groupbuy_BarganInfo @"groupBuyMain/getGroupBuyCutPriceById?sign=QCYDSSIGNCDD&token=%@&mainId=%@&buyerId=%@"
//获取首页和团购banner、icon
#define URL_Get_Banner @"index/getBanner?sign=QCYDSSIGNCDD&plate_code=%@"

//获取团购详情
#define URL_GroupBuy_Detail @"groupBuyMain/getGroupBuyMainByIdNew?sign=QCYDSSIGNCDD&id=%@&token=%@"
//获取认购列表
#define URL_GroupBuy_Already @"groupBuyMain/queryGroupBuyerList?sign=QCYDSSIGNCDD&mainId=%@&pageNo=%d&pageSize=%d"
//首页搜索
#define URL_HomePage_search @"index/searchData?sign=QCYDSSIGNCDD&token=%@&keyWord=%@&pageNo=%d&pageSize=%d"
//获取求购消息
//#define URL_AskBuy_Msg_List @"user/getMallEnquiryInformList?sign=QCYDSSIGNCDD&token=%@&type=%@&pageNo=%d&pageSize=%d"
//获取系统消息
#define URL_System_Msg_List @"user/getSystemInformList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d&platform=app_ios&deviceNo=%@"
//获取朋友圈列表
//#define URL_Friend_List @"dyeCommunity/queryDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取朋友圈发现页列表
#define URL_Friend_List_Find @"dyeCommunity/queryMainDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&level1TopicId=%@&level2TopicId=%@&pageNo=%d&pageSize=%d"
#define URL_Friend_List_Find1 @"dyeCommunity/queryMainDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&level2TopicId=%@&pageNo=%d&pageSize=%d"
//获取热门朋友圈列表
#define URL_Friend_List_Hot @"dyeCommunity/queryHotDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取关注朋友圈列表
#define URL_Friend_List_Focus @"dyeCommunity/queryMyFollowDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取帖子详情
#define URL_FC_Detail @"dyeCommunity/queryDyeCommunityDetail?sign=QCYDSSIGNCDD&token=%@&id=%@"
//获取我的用户信息
#define URL_Friend_MyInfo @"user/getMyInfoDetail?token=%@&sign=QCYDSSIGNCDD"
//获取用户信息
#define URL_Friend_UserInfo @"user/getUserInfoDetail?sign=QCYDSSIGNCDD&token=%@&userId=%@"
//获取其他用户帖子列表
#define URL_User_Friend_InfoList @"dyeCommunity/queryDyeCommunityListByUserId?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d&userId=%@"
//获取我的帖子列表
#define URL_My_Friend_InfoList @"dyeCommunity/queryMyDyeCommunityList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取粉丝列表
#define URL_Fans_List @"dyeFollow/queryFollowListByUserId?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d&userId=%@"
//#define URL_Fans_List @"dyeFollow/queryFollowListByUserIdNew?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d&userId=%@"

//获取我的粉丝列表
//#define URL_My_Fans_List @"dyeFollow/queryMyFollowList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
#define URL_My_Fans_List @"dyeFollow/queryMyFollowListNew?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"

//获取好友列表
#define URL_My_Friends_List @"dyeFollow/queryMyFriendList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取未读消息个数
#define URL_Unread_MsgCounts @"dyeCommunity/queryMyNotReadCommentCount?sign=QCYDSSIGNCDD&token=%@"
//获取评论列表
#define URL_Comment_List @"dyeCommunity/queryDyeCommentListByDyeId?sign=QCYDSSIGNCDD&token=%@&dyeId=%@&pageNo=%d&pageSize=%d"
//获取点赞列表
#define URL_Zan_List @"dyeCommunity/queryDyeLikeListByDyeId?sign=QCYDSSIGNCDD&dyeId=%@&pageNo=%d&pageSize=%d"
//获取一级话题
#define URL_Get_Topic_List @"dyeCommunity/queryDyeCommunityTopicList?sign=QCYDSSIGNCDD"
//好友通讯录
#define URL_FriendsBook_List @"dyeFollow/queryMyFriendListSort?sign=QCYDSSIGNCDD&token=%@"
//获取各个新消息的数目
#define URL_All_Msg_Count @"dyeCommunityMessage/getNoReadCount?sign=QCYDSSIGNCDD&token=%@"
//获取消息列表
#define URL_FC_UnreadComments_List @"dyeCommunityMessage/queryMyNotReadCommentMessageList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取点赞列表
#define URL_FC_DianZan_List @"dyeCommunityMessage/queryMyNotReadLikeMessageList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取@我的列表
#define URL_FC_AtMe_List @"dyeCommunityMessage/queryMyNotReadNoticeMessageList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取粉丝列表
#define URL_FC_FriendsFans_List @"dyeCommunityMessage/queryMyNotReadFollowMessageList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//印染地图获取推荐商家
#define URL_FCMap_Stores @"dyeMap/queryDyeMapList?sign=QCYDSSIGNCDD&companyName=%@&province=%@&city=%@&area=%@&customerClass=%@&pageNo=%d&pageSize=%d"


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
//获取默认地址
#define URL_Default_Address @"defaultAddress/queryDefaultAddress?sign=QCYDSSIGNCDD&token=%@"


/******************************** post请求 ********************************/
//参与报价
//#define URL_JOIN_OFFER @"enquiryOffer/addEnquiryOffer"
#define URL_JOIN_OFFER @"enquiryOffer/addEnquiryOfferNew"
//发布求购
#define URL_POST_BUYING @"enquiry/addEnquiy"
//关闭求购
#define URL_CLOSE_BUYING @"enquiry/cancelEnquiry"
//采纳报价
#define URL_Accept_Offer @"enquiryOffer/acceptEnquiryOffer"
//已读接口
#define URL_Already_Read @"enquiryOffer/readMyAcceptOffer"
//参与团购
#define URL_Join_GroupBuy @"groupBuyMain/addGroupBuyerNew2"
//帮好友砍价
#define URL_Help_Bargain @"groupBuyMainCutPrice/groupBuyCutPrice"
//上传/修改头像
#define URL_Upload_Header @"user/updateUserHeadPhoto"
//注册短信验证码
#define URL_Msg_Code_Register @"user/send_sms_code_register"
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
//#define URL_Publish_Comments @"dyeCommunity/addDyeComment"
#define URL_Publish_Comments @"dyeCommunity/addDyeCommentNew"
//发朋友圈
//#define URL_Publish_FriendCircle @"dyeCommunity/addDyeCommunity"
#define URL_Publish_FriendCircle @"dyeCommunity/addDyeCommunityNew"
//添加关注
//#define URL_Add_Focus @"dyeFollow/addDyeFollowByUserId"
#define URL_Add_Focus @"dyeFollow/addDyeFollowByUserIdNew"
//取消关注
#define URL_Cancel_Focus @"dyeFollow/cancelDyeFollowByUserId"
//删除帖子
#define URL_Delete_FriendCricle @"dyeCommunity/cancelDyeCommunity"
//删除自己的评论
#define URL_Delete_MyComment @"dyeCommunity/cancelDyeComment"
//点赞
#define URL_Click_Zan @"dyeCommunity/addDyeLikeNew"
//大V认证
#define URL_BigV_Cert @"user/CertV"
//修改朋友圈信息
#define URL_Change_FCInfo @"user/updateMyDyeInfo"
//消息全部标记已读
#define URL_FCMSG_AlreadyRead @"dyeCommunityMessage/batchReadMessage"
//删除评论消息
#define URL_DeleteMSG_Comments @"dyeCommunityMessage/delCommentMessageById"
//删除点赞消息
#define URL_DeleteMSG_Dianzan @"dyeCommunityMessage/delLikeMessageById"
//删除@我的消息
#define URL_DeleteMSG_AtMe @"dyeCommunityMessage/delNoticeMessageById"
//删除@我的消息
#define URL_DeleteMSG_FriendsFans @"dyeCommunityMessage/delFollowMessageById"
//参与认购
#define URL_Join_Discount_Buy @"sales/addSalesOrderNew"
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
#define URL_Join_Auction @"auction/addAuctionBuyerNew"
//开放商城查询店铺营业执照的图形验证码校验
#define URL_Check_ImageCode @"user/checkCaptcha"
//微信支付
#define URL_WXPay_Auction @"wxpay/getPrepayid"




/***********  此处开始按模块分接口  ***********/
#pragma mark - 助剂定制
//助剂定制专场
#define URL_Get_ZhuJiDiySpecialList @"zhujiDiy/queryZhujiDiySpecialList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"
//获取列表
//#define URLGet_ZhuJiDiy_List @"zhujiDiy/queryZhujiDiyList?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d"

#define URLGet_ZhuJiDiy_List @"zhujiDiy/queryZhujiDiyListNew?sign=QCYDSSIGNCDD&token=%@&pageNo=%d&pageSize=%d&specialId=%@"
//获取助剂定制详情
#define URLGet_ZhuJiDiy_Detail @"zhujiDiy/queryZhujiDiyDetail?sign=QCYDSSIGNCDD&token=%@&id=%@"
//提交我的助剂定制解决方案
#define URLPost_ZhuJiDiy_SubmitPlan @"zhujiDiy/addZhujiDiySolution"
//发布助剂定制
#define URLPost_ZhuJiDiy_Post @"zhujiDiy/addZhujiDiyNew"
//获取助剂定制分类
#define URLGet_ZhuJiDiy_Classify @"zhujiDiy/getZhujiDiyClassList?sign=QCYDSSIGNCDD"
//获取材质分类
#define URLGet_ZhuJiDiy_Material @"zhujiDiy/getZhujiDiyMaterialList?sign=QCYDSSIGNCDD"

//我发布的助剂定制列表
#define URLGet_MyZhuJiDiy_List @"zhujiDiy/getMyZhujiDiyList?sign=QCYDSSIGNCDD&token=%@&status=%@&pageNo=%d&pageSize=%d"
//我发布的助剂定制解决方案列表
#define URLGet_MyZhuJiDiy_SolutionList @"zhujiDiy/getMyZhujiDiySolutionList?sign=QCYDSSIGNCDD&token=%@&status=%@&pageNo=%d&pageSize=%d"
//我发布的助剂定制详情（包含解决方案列表--我的）
#define URLGet_MyZhuJiDiy_DiyDetail @"zhujiDiy/getMyZhujiDiyDetail?sign=QCYDSSIGNCDD&token=%@&id=%@"
//我发布的解决方案
#define URLGet_MyZhuJiDiy_SolutionDetail @"zhujiDiy/getMyZhujiDiySolutionDetail?sign=QCYDSSIGNCDD&token=%@&id=%@"
//关闭助剂定制
#define URLPost_Close_MyZhuJiDiy @"zhujiDiy/updateZhujiDiyStatus"
//采纳解决方案
#define URLPost_Accept_ZhuJiDiy @"zhujiDiy/acceptZhujiDiySolution"


#pragma mark - 用户登录、注册、找回密码、修改密码
//用户登录
#define URLPost_User_Login @"user/toLogin"
//用户注册
#define URLPost_User_Register @"user/registerNew"
//注册后的完善信息
#define URLPost_User_PerfectInfo @"user/updateUserInfo"

#pragma mark 个人/账号中心
//企业认证
#define URLPost_Company_Cert @"user/registerCompany"
//重新提交审核
#define URLPost_Compan_ResetCert @"user/resetCompany"
//获取帐号审核状态
#define URLGet_CompanyCert_Status @"user/getCompanyInfoStatus?sign=QCYDSSIGNCDD&token=%@"
//获取企业认证详细信息
#define URLGet_CompanyCert_Detail @"user/getCompanyInfoDetail?sign=QCYDSSIGNCDD&token=%@"


#pragma mark - app消息中心
#define URLGet_Buyer_Message @"vMallInform/getVMallInformList?sign=QCYDSSIGNCDD&token=%@&type=%@&pageNo=%d&pageSize=%d"
//消息详情
#define URLGet_AskBuy_Msg_Detail @"vMallInform/getVMallInformDetail?sign=QCYDSSIGNCDD&token=%@&workType=%@&id=%@"


#pragma mark - 求购
//查看直通车信息
#define URLGet_AskZTC_Info @"enquiry/queryEnquiryInformation?sign=QCYDSSIGNCDD&token=%@&enquiryId=%@"
//点击付费按钮的统计
#define URLPost_Click_UpgradeVIP @"enquiry/toFeeAdRecord"


#pragma mark - 代销市场
//代销市场列表
#define URLGet_ProxtSale_List @"proxyMarket/queryProxyMarketList?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//代销详情
#define URLGet_ProxtSale_Detail @"proxyMarket/getProxyMarketById?sign=QCYDSSIGNCDD&id=%@"
//认购或者索样
#define URLPost_Proxy_Buy_Demo @"proxyMarket/addProxyMarketBuy"


#pragma mark - 职业培训
//课程列表
#define URLGet_Course_List @"schoolLiveClass/querySchoolLiveClassListForApp?sign=QCYDSSIGNCDD&pageNo=%d&pageSize=%d"
//课程详情
#define URLGet_Course_Detail @"schoolLiveClass/querySchoolLiveClassDetailForApp?sign=QCYDSSIGNCDD&token=%@&id=%@"
//预约课程
#define URLPost_Order_Remind @"schoolLiveClass/createSchoolLiveClassReserveForApp"
//预约课程
#define URLPost_Remind_Cancel @"schoolLiveClass/updateSchoolLiveClassReserveForApp"
#endif /* NetWorkingPort_h */

