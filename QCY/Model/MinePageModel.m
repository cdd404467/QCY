//
//  MinePageModel.m
//  QCY
//
//  Created by i7colors on 2018/10/22.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MinePageModel.h"
#import <MJExtension.h>

@implementation MinePageModel

@end

@implementation EnquiryDomain
//description转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description",//前边的是你想用的key，后边的是返回的key
             @"productID" : @"id"
             };

}

@end

@implementation AskToBuyOfferModel


@end

@implementation MyAskToBuyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description",//前边的是你想用的key，后边的是返回的key
             @"buyID" : @"id"
    };
}

@end

@implementation MineNumberModel


@end
