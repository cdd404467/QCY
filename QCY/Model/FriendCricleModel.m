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

- (BOOL)isSelectFriend {
    if (!_isSelectFriend) {
        _isSelectFriend = NO;
    }
    return _isSelectFriend;
}

@end

@implementation FriendTopicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description",
             @"secondTopicID" : @"id"
             };
}

@end

@implementation ShareBeanModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"zixunID" : @"id"
             };
}
@end


@implementation ZiMuModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"special" : @"#"
             };
}

@end

@implementation FCMsgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"messageID" : @"id"
             };
}

@end

@implementation MarketModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptionStr" : @"description"
             };
}

@end

@implementation FCMapModel

- (NSString *)shopArea {
    return [NSString stringWithFormat:@"%@%@",self.province,self.city];
}

@end


@implementation FCMapNavigationModel



@end
