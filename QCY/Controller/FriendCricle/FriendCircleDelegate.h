//
//  FriendCircleDelegate.h
//  QCY
//
//  Created by i7colors on 2019/3/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FriendCircleDelegate <NSObject>

@optional
//发布朋友圈完成后执行的代理
- (void)publishCompleted;
//滑动tableView的回调
- (void)tableViewContentOffsetY:(CGFloat)offsetY;
//左上角头像图标通知更新
- (void)leftHeaderIconChange:(NSString *)headerUrl;


@end

NS_ASSUME_NONNULL_END
