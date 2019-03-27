//
//  VoteModel.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "VoteModel.h"

@implementation VoteModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"detailID" : @"id"
             };
}


@end

@implementation RuleListModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 50;
    }
    return _cellHeight;
}

@end

@implementation VoteUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description",//前边的是你想用的key，后边的是返回的key
             @"voteUserID" : @"id"
             };
}

@end

@implementation ApplyJoinModel

- (UIImage *)headerImage {
    if (!_headerImage) {
        _headerImage = [UIImage imageNamed:@"addImage_icon"];
    }
    
    return _headerImage;
}

@end
