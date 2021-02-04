//
//  InfomationModel.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "InfomationModel.h"

@implementation InfomationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"infoID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end
