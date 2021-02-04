//
//  NSString+Extension.m
//  QCY
//
//  Created by i7colors on 2019/7/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(NSString *)reviseString:(double)value {
    //直接传入精度丢失有问题的Double类型
    NSString *doubleString = [NSString stringWithFormat:@"%lf", value];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}


@end
