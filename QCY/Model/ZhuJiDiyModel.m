//
//  ZhuJiDiyModel.m
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyModel.h"

@implementation ZhuJiDiyModel
//description转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"zhujiDiyID" : @"id",//前边的是你想用的key，后边的是返回的key
             @"descriptionStr" : @"description"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation ZhuJiDiySpecialModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"specialID" : @"id",
             @"descriptionStr" : @"description"//前边的是你想用的key，后边的是返回的key
             };
}
@end

@implementation ZhuJiDiyDetailInfoModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 34;
    }
    return _cellHeight;
}


@end


@implementation ZhuJiDiySolutionModel
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 34;
    }
    return _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"solutionID" : @"id",
             @"descriptionStr" : @"description"//前边的是你想用的key，后边的是返回的key
             };
}

@end
