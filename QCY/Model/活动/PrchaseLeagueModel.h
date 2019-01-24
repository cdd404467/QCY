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


/*** 标记列表是否展开 ***/
@property (nonatomic, assign)BOOL isOpen;


@end

@interface MeetingShopListModel : NSObject
@property (nonatomic, copy)NSString *shopName;                  //产品名称
@property (nonatomic, copy)NSString *packing;                   //包装规格
@property (nonatomic, copy)NSString *reservationNum;            //订货量
@property (nonatomic, copy)NSString *numUnit;                   //单位
@property (nonatomic, copy)NSArray *meetingTypeList;            //标准列表
/*** cell的高度 ***/
@property (nonatomic, assign)CGFloat cellHeight;
@end

@interface MeetingTypeListModel : NSObject
@property (nonatomic, copy)NSString *referenceType;             //标准文字
@end

NS_ASSUME_NONNULL_END
