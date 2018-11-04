//
//  OpenMallModel.m
//  QCY
//
//  Created by i7colors on 2018/10/29.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OpenMallModel.h"

@implementation Company

@end

@implementation BusinessList


@end

@implementation PropMap

@end

@implementation OpenMallModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"storeID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}


@end

@implementation ProductInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"productID" : @"id",
             @"descriptionStr" : @"description"//前边的是你想用的key，后边的是返回的key
             };
}

@end
