//
//  Utility.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "Utility.h"
#import "TimeAbout.h"

@implementation Utility

#pragma mark - 时间戳转换
+ (NSString *)getDateFormatByTimestamp:(long long)timestamp
{
    //13位时间戳转10位
    if ([NSString stringWithFormat:@"%lld",timestamp].length == 13) {
        timestamp = timestamp / 1000;
    }
    
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTimestamp = [dat timeIntervalSince1970] ;
    long long int timeDifference = nowTimestamp - timestamp;
    long long int secondTime = timeDifference;
    long long int minuteTime = secondTime/60;
    long long int hoursTime = minuteTime/60;
    long long int dayTime = hoursTime/24;

//    long long int monthTime = dayTime/30;
//    long long int yearTime = monthTime/12;
    
//    if (1 <= yearTime) {
//        return [NSString stringWithFormat:@"%lld年前",yearTime];
//    }
//    else if(1 <= monthTime) {
//        return [NSString stringWithFormat:@"%lld月前",monthTime];
//    }
//    else
    
    NSString *string = [TimeAbout timestampToString:timestamp * 1000 isSecondMin:NO];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    
    if(isToday) {
        if(1 <= hoursTime) {
            return [NSString stringWithFormat:@"%lld小时前",hoursTime];
        }  else if(1 <= minuteTime) {
            return [NSString stringWithFormat:@"%lld分钟前",minuteTime];
        } else if (1 <= secondTime) {
            return @"刚刚";
        } else {
            return nil;
        }
    //        else if(1 <= dayTime) {
    //            return [NSString stringWithFormat:@"%lld天前",dayTime];
    //        }
    //        else {
    //            return @"刚刚";
    //        }
    } else if (isYesterday) {
        return [NSString stringWithFormat:@"昨天"];
    } else {
        return [NSString stringWithFormat:@"%lld天前",dayTime];
    }

//    //今天
//    if (isToday) {
//        if (1 <= secondTime) {
//            return @"刚刚";
//        }
//        else if(1 <= minuteTime) {
//            return [NSString stringWithFormat:@"%lld分钟前",minuteTime];
//        }
//        else if(1 <= hoursTime) {
//            return [NSString stringWithFormat:@"%lld小时前",hoursTime];
//        } else {
//            return nil;
//        }
////        else if(1 <= dayTime) {
////            return [NSString stringWithFormat:@"%lld天前",dayTime];
////        }
////        else {
////            return @"刚刚";
////        }
//    }
//    //昨天
//    else if (isYesterday) {
//        return @"昨天";
//    } else{
//        return [NSString stringWithFormat:@"%lld天前",dayTime];
//    }
    
}




#pragma mark - 获取单张图片的实际size
+ (CGSize)getSingleSize:(CGSize)singleSize
{
    CGFloat max_width = [UIScreen mainScreen].bounds.size.width - 150;
    CGFloat max_height = [UIScreen mainScreen].bounds.size.width - 180;
    
    CGFloat image_width = singleSize.width;
    CGFloat image_height = singleSize.height;
    
    CGFloat result_width = 0;
    CGFloat result_height = 0;
    if (image_height/image_width > 3.0) {
        result_height = max_height;
        result_width = result_height/2;
    }  else  {
        result_width = max_width;
        result_height = max_width*image_height/image_width;
        if (result_height > max_height) {
            result_height = max_height;
            result_width = max_height*image_width/image_height;
        }
    }
    
    if (result_width < 0) result_width = 0;
    if (result_height < 0) result_height = 0;
    
    return CGSizeMake(result_width, result_height);
//    return CGSizeMake(300, 200);
}


@end
