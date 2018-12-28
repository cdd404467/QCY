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
/*** 时间戳转字符串,年月日 ***/
+ (NSString *)timestampToString:(long long)time;
/*** 时间戳转字符串,年月日，时分秒 ***/
+ (NSString *)timestampToString:(long long)time isSecondMin:(BOOL)isSecMin;
//今天开始往前后推时间
+ (NSDate *)getNDay:(NSInteger)nDay;
//nsdate转string
+ (NSString*)stringFromDate:(NSDate*)date;
//
+ (NSDate *)stringToDate:(NSString *)string;


//今天、昨天
+ (NSString *)checkTheDate:(long long)string;
@end


NS_ASSUME_NONNULL_END
