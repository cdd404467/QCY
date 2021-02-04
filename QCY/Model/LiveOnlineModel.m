//
//  LiveOnlineModel.m
//  QCY
//
//  Created by i7colors on 2020/3/27.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LiveOnlineModel.h"

@implementation LiveOnlineModel
//前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description",
             @"courseID":@"id"
             };
}
@end
