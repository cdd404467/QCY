//
//  MessageModel.m
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (instancetype)initWith:(NSDictionary *)dict {
    MessageModel *mM = [[self alloc] init];
    [mM setValuesForKeysWithDictionary:dict];
    return mM;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"detailID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}


@end
