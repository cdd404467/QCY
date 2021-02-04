//
//  UserInfoModel.m
//  QCY
//
//  Created by i7colors on 2019/10/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"isCompany_User" : @"isCompany",//前边的是你想用的key，后边的是返回的key
             @"compInfoID":@"id"
             };
}
@end
