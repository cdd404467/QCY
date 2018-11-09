//
//  GroupBuyingModel.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingModel.h"


@implementation GroupBuyingModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"priceNew" : @"newPrice",
             @"groupID" : @"id"
             };
}
@end

@implementation GroupBuyFinishModel


@end
