//
//  MobilePhone.m
//  QCY
//
//  Created by i7colors on 2018/11/16.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MobilePhone.h"

@implementation MobilePhone

///检测手机号码的合法性
+ (BOOL) isValidMobile:(NSString * _Nullable)mobile {
//    /**
//     * 移动号段正则表达式
//     */
//    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//    /**
//     * 联通号段正则表达式
//     */
//    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//    /**
//     * 电信号段正则表达式
//     */
//    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    NSString *_NUM = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[8,9]))\\d{8}$";
//    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
//    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//    BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
//    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//    BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _NUM];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    
    if (isMatch && mobile.length == 11) {
        return YES;
    }else{
        return NO;
    }
}


@end
