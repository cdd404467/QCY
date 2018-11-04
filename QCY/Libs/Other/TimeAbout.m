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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

//获取当前时间戳有两种方法(以秒为单位)

+ (NSString *)getNowTimeTimestamp_M {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}

//时间戳转字符串
+ (NSString *)timestampToString:(NSInteger)time {
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)time];
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
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

//- (NSDate *)getInternetDate{
//    NSString *urlString = @"http://m.baidu.com";
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    // 实例化NSMutableURLRequest，并进行参数配置
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString: urlString]];
//    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    [request setTimeoutInterval: 2];
//    [request setHTTPShouldHandleCookies:FALSE];
//    [request setHTTPMethod:@"GET"];
//    NSError *error = nil;
//    NSHTTPURLResponse *response;
//    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    // 处理返回的数据
//    if (error) {
//        return [NSDate date];
//    }
//    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
//    date = [date substringFromIndex:5];//index到这个字符串的结尾
//    date = [date substringToIndex:[date length]-4];//从索引0到给定的索引index
//    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
//    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
//    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];//时间差8小时
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: netDate];
//    netDate = [netDate  dateByAddingTimeInterval: interval];
//
//    return netDate;
//}

@end
