//
//  HomePageModel.m
//  QCY
//
//  Created by i7colors on 2018/10/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageModel.h"


@implementation HomePageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"isCompany_User" : @"isCompany",//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation AskToBuyModel

//求购id转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"buyID" : @"id",//前边的是你想用的key，后边的是返回的key
             @"descriptionStr" : @"description"
             };
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 80;
    }
    return _cellHeight;
}
@end

@implementation CompanyDomain


@end

@implementation AskDetailInfoModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 34;
    }
    return _cellHeight;
}

@end

@implementation supOrrerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"offerID" : @"id",//前边的是你想用的key，后边的是返回的key
             @"descriptionStr" : @"description"//前边的是你想用的key，后边的是返回的key
             };
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 200;
    }
    
    return _cellHeight;
}
 @end

@implementation PostBuyingModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"classID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end

