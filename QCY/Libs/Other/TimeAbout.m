//
//  TimeAbout.m
//  QCY
//
//  Created by i7colors on 2018/10/12.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TimeAbout.h"

@implementation TimeAbout

//获取当前时间戳  （以毫秒为单位）
+ (NSString *)getNowTimeTimestamp_HM {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] * 1000];
    
    return timeSp;
}

//获取当前时间戳有两种方法(以秒为单位)
+ (NSString *)getNowTimeTimestamp_M {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}

//时间戳转字符串,只有年月日
+ (NSString *)timestampToString:(long long)time isSecondMin:(BOOL)isSecMin {
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)time];
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (isSecMin == YES) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//时间戳转字符串,年月日，十分秒
+ (NSString *)timestampToString:(long long)time {
    return [self timestampToString:time isSecondMin:YES];
}

//今天开始往前后推时间
+ (NSDate *)getNDay:(NSInteger)nDay {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    if(nDay!= 0){
        //initWithTimeIntervalSinceNow是从现在往前后推的秒数
        NSTimeInterval oneDay = 24 * 60 * 60 * 1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay * nDay ];
    } else
        theDate = nowDate;
    
    return theDate;
}

//nsdate转string
+ (NSString*)stringFromDate:(NSDate*)date {
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

//string转nsdata
+ (NSDate *)stringToDate:(NSString *)string {
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd";
    // NSString * -> NSDate *
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [format dateFromString:string];
    
    return date;
}


//判断今天、昨天
+ (NSString *)checkTheDate:(long long)timeStamp {
    
    NSString *string = [self timestampToString:timeStamp isSecondMin:NO];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    NSString *strDiff = nil;
    
    if(isToday) {
        strDiff= [NSString stringWithFormat:@"今天"];
    } else if (isYesterday) {
        strDiff= [NSString stringWithFormat:@"昨天"];
    } else {
        strDiff = string;
    }
    
    return strDiff;
}

@end
