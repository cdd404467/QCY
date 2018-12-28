//
//  FriendCricleModel.m
//  QCY
//
//  Created by i7colors on 2018/11/25.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCricleModel.h"

@implementation FriendCricleModel
//帖子id转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"tieziID" : @"id",//前边的是你想用的key，后边的是返回的key
             @"isCompanyType" : @"isCompany"
             };
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 200;
    }
    return _cellHeight;
}


@end

@implementation LikeListModel

@end

@implementation CommentListModel
//帖子id转换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"commentID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end

@implementation FriendCricleInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"isCompanyType" : @"isCompany"
             };
}
@end
