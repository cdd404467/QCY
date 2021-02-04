//
//  AuctionModel.m
//  QCY
//
//  Created by i7colors on 2019/3/4.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionModel.h"

@implementation AuctionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"jpID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 210.f;
    }
    
    return _cellHeight;
}

@end

@implementation AuctionRecordModel

@end

@implementation AttributeListModel
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 40;
    }
    return _cellHeight;
}
@end

@implementation InstructionsListModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 50;
    }
    return _cellHeight;
}

@end

@implementation DetailPcPicModel


@end

@implementation VideoListModel


@end
