//
//  ProxySaleModel.m
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProxySaleModel.h"

@implementation ProxySaleModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"proxyID" : @"id"
             };
}
@end


@implementation DictMapModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"shuXing" : @"key",
             @"zhi" : @"value"
             };
}
@end

@implementation RuleModel


@end
