//
//  HomePageModel.m
//  QCY
//
//  Created by i7colors on 2018/10/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageModel.h"


@implementation HomePageModel

@end

@implementation AskToBuyModel

//求购id转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"buyID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation CompanyDomain


@end

@implementation AskToBuyDetailModel
//description转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation supOrrerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"offerID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation PostBuyingModel

//description转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"classID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end
