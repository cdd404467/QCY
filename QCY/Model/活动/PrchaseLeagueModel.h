//
//  PrchaseLeagueModel.h
//  QCY
//
//  Created by i7colors on 2019/1/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrchaseLeagueModel : NSObject

@property (nonatomic, copy)NSString *meetingName;               //名称
@property (nonatomic, copy)NSString *allNum;                    //订货量
@property (nonatomic, copy)NSString *allOutputNum;              //供货总量
@property (nonatomic, copy)NSString *placeCount;                //订货商个数
@property (nonatomic, copy)NSString *supplyCount;               //供货商个数
@property (nonatomic, copy)NSString *isType;                    //0，已结束，1未开始，2进行中
@property (nonatomic, copy)NSString *startTime;                 //开始时间
@property (nonatomic, copy)NSString *endTime;                   //结束时间
@property (nonatomic, copy)NSArray *meetingShopList;            //产品信息数组
@property (nonatomic, copy)NSString *goodsID;                   //采购联盟商品ID
/*** 标记列表是否展开 ***/
@property (nonatomic, assign)BOOL isOpen;
@end


@interface MeetingShopListModel : NSObject
@property (nonatomic, copy)NSString *shopName;                  //产品名称
@property (nonatomic, copy)NSString *packing;                   //包装规格
@property (nonatomic, copy)NSString *reservationNum;            //订货量
@property (nonatomic, copy)NSString *numUnit;                   //单位
@property (nonatomic, copy)NSArray *meetingTypeList;            //标准列表

/** 供货 **/
@property (nonatomic, copy)NSString *outputNum;                 //供货量
@property (nonatomic, copy)NSString *effectiveTime;             //报价有效期
@property (nonatomic, copy)NSString *price;                     //价格
@property (nonatomic, copy)NSString *priceUnit;                 //单位
@property (nonatomic, copy)NSString *shopID;                    //id
//cell的高度
@property (nonatomic, assign)CGFloat cellHeight;
//是否选中
@property (nonatomic, assign)BOOL isSelect;
//是否是自定义
@property (nonatomic, assign)BOOL isCustom;

@end




@interface MeetingTypeListModel : NSObject<NSCopying, NSMutableCopying>
@property (nonatomic, copy)NSString *referenceType;             //标准文字
//是否选中
@property (nonatomic, assign)BOOL isSelectStand;
@end


//没有作用的一层数据
@interface MeetingList : NSObject
@property (nonatomic, strong)NSMutableArray *data;                       //
@end



//我要订货或者供货
@interface OrderOrSupplyModel : NSObject
@property (nonatomic, copy)NSArray<NSString *> *accountPeriod;          //订货时的可选账期
@property (nonatomic, copy)NSArray<NSString *> *accountPeriodOut;       //供货时的可选账期
@property (nonatomic, copy)NSString *picIn;                             //订货时的说明图片
@property (nonatomic, copy)NSString *picOut;                            //供货时的说明图片
@property (nonatomic, strong)MeetingList *meetingList;                  //无用的一层数据过度

/***记录联系人信息是否已经全部填写***/
//记录公司名称
@property (nonatomic, copy)NSString *companyTF_data;
//联系人
@property (nonatomic, copy)NSString *contactTF_data;
//职务
@property (nonatomic, copy)NSString *workTF_data;
//联系电话
@property (nonatomic, copy)NSString *phoneTF_data;
//支付方式
@property (nonatomic, copy)NSString *paySelect_data;
//账期
@property (nonatomic, copy)NSString *dateSelect_data;
//区域
@property (nonatomic, copy)NSString *areaSelect_data;
//详细地址，可选
@property (nonatomic, copy)NSString *detailArea_data;
@end



NS_ASSUME_NONNULL_END
