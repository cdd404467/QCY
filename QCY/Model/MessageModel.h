//
//  MessageModel.h
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject
@property (nonatomic, copy)NSString *productName;               //产品名字
@property (nonatomic, copy)NSString *content;                   //消息文本
@property (nonatomic, copy)NSString *isRead;                    //消息是否已读，isRead=1，已读；isRead= 0，未读
@property (nonatomic, copy)NSString *createdAt;                 //消息时间
//助剂定制相关，助剂定制名称
@property (nonatomic, copy) NSString *zhujiName;
//业务类型，enquiry表示求购相关的消息；zhujiDiy表示助剂定制相关的消息
@property (nonatomic, copy) NSString *workType;
//助剂定制的id
@property (nonatomic, copy) NSString *zhujiDiyId;
//解决方案的id
@property (nonatomic, copy) NSString *zhujiDiySolutionId;

//system msg
@property (nonatomic, copy)NSString *title;                     //标题
@property (nonatomic, copy)NSString *pic;                       //宣传图片
//消息类型,买家或者卖家
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *enquiryId;                 //跳转求购详情的ID
@property (nonatomic, copy)NSString *detailID;                  //跳转消息详情的ID
@property (nonatomic, copy)NSString *url;                       //跳转网页的url
@property (nonatomic, copy)NSString *directType;                //跳转类型
@property (nonatomic, copy)NSString *directTypeId;              //跳转ID

@property (nonatomic, assign)CGFloat cellHeight;                //cell高度
@end

NS_ASSUME_NONNULL_END
