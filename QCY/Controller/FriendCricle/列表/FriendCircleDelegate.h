//
//  FriendCircleDelegate.h
//  QCY
//
//  Created by i7colors on 2019/3/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InfomationModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FriendCircleDelegate <NSObject>

@optional
//关联咨询选择后回传数据
- (void)getZiXundata:(InfomationModel *)model;
//发布朋友圈页面，tableView的 headerView发生改变时
- (void)tableViewHeaderHasChanged:(CGFloat)height;
//消息未读变为已读代理
- (void)fcMessageAlreadyRead:(NSInteger)index;
//发布按钮是否能点击
- (void)fcPublishBtnState:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
