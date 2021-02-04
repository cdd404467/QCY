//
//  LiveOnlineModel.h
//  QCY
//
//  Created by i7colors on 2020/3/27.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveOnlineModel : NSObject
//课程id
@property (nonatomic, copy) NSString *courseID;
//频道id
@property (nonatomic, copy) NSString *channelId;
//是否已购买该课程,0是未购买，1是已购买
@property (nonatomic, copy) NSString *loginUserIsBuy;
//是否已经预约课程,0是未预约，1是已预约
@property (nonatomic, copy) NSString *loginUserIsReserve;
//标题
@property (nonatomic, copy) NSString *title;
//简介
@property (nonatomic, copy) NSString *descriptionStr;
//讲师
@property (nonatomic, copy) NSString *teacher;
//课程价格，为0 表示免费
@property (nonatomic, copy) NSString *price;
//图片
@property (nonatomic, copy) NSString *banner;
//isEnd=1进行中，isEnd=0已结束，isEnd=2未开始
@property (nonatomic, copy) NSString *isEnd;
//直播开始时间字符串
@property (nonatomic, copy) NSString *startTime;
//开始时间戳
@property (nonatomic, assign)long long startTimeStamp;
//结束时间戳
@property (nonatomic, assign) long long endTimeStamp;


#pragma mark 回看
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *videoId;
//播放地址
@property (nonatomic, copy) NSString *videoUrl;
//视频截图，如果视频封面 没有值，则使用该值为封面
@property (nonatomic, copy) NSString *videoHdUrl;
//视频封面
@property (nonatomic, copy) NSString *videoLdUrl;

@end

NS_ASSUME_NONNULL_END
