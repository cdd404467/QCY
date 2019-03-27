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

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"goodsID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end


@implementation MeetingShopListModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 200;
    }
    return _cellHeight;
}

- (BOOL)isSelect {
    if (!_isSelect) {
        _isSelect = NO;
    }
    return _isSelect;
}

- (BOOL)isCustom {
    if (!_isCustom) {
        _isCustom = NO;
    }
    return _isCustom;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"shopID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end

@implementation MeetingTypeListModel
- (BOOL)isSelectStand {
    if (!_isSelectStand) {
        _isSelectStand = NO;
    }
    return _isSelectStand;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    MeetingTypeListModel *model = [[MeetingTypeListModel allocWithZone:zone] init];
    model.referenceType = self.referenceType;
    model.isSelectStand = self.isSelectStand;
    
    return model;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    MeetingTypeListModel *model = [[MeetingTypeListModel allocWithZone:zone] init];
    model.referenceType = self.referenceType;
    model.isSelectStand = self.isSelectStand;
    
    return model;
}

@end

@implementation MeetingList


@end

@implementation OrderOrSupplyModel

- (NSString *)detailArea_data {
    if (!_detailArea_data) {
        _detailArea_data = @"";
    }
    return _detailArea_data;
}

@end
