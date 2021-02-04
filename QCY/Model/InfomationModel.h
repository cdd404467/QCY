//
//  InfomationModel.h
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfomationModel : NSObject
@property (nonatomic, copy)NSString *infoID;                    //资讯ID,跳转详情
@property (nonatomic, copy)NSString *title;                     //资讯标题
@property (nonatomic, copy)NSString *content;                   //html正文标签
@property (nonatomic, copy)NSString *content_summary;           //资讯概要
@property (nonatomic, copy)NSString *img_url;                   //资讯图片
@property (nonatomic, copy)NSString *news_date;                 //资讯日期

@property (nonatomic, strong)InfomationModel *infoDetail;       //webView信息,一个字典
@property (nonatomic, strong)InfomationModel *prev;             //上一条信息
@property (nonatomic, strong)InfomationModel *next;             //下一条信息
@end

NS_ASSUME_NONNULL_END
