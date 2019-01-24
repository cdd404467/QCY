//
//  PrchaseLeagueModel.m
//  QCY
//
//  Created by i7colors on 2019/1/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PrchaseLeagueModel.h"

@implementation PrchaseLeagueModel

- (BOOL)isOpen {
    if (!_isOpen) {
        _isOpen = NO;
    }
    return _isOpen;
}



@end


@implementation MeetingShopListModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 200;
    }
    return _cellHeight;
}

@end

@implementation MeetingTypeListModel


@end
