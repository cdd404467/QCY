//
//  TimeAbout.h
//  QCY
//
//  Created by i7colors on 2018/10/12.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeAbout : NSObject
//毫秒
+(NSString *)getNowTimeTimestamp_HM;
//时间戳转字符串
+ (NSString *)timestampToString:(NSInteger)time;
//今天开始往前后推时间
+ (NSDate *)getNDay:(NSInteger)nDay;
//nsdate转string
+ (NSString*)stringFromDate:(NSDate*)date;
//
+ (NSDate *)stringToDate:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
