//
//  FriendCricleCell.h
//  QCY
//
//  Created by i7colors on 2018/11/25.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperateMenuView.h"

@class FriendCricleModel;
@class GKPhotoView;
@protocol FriendCellDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface FriendCricleCell : UITableViewCell
// 评论、点赞菜单
@property (nonatomic, strong) OperateMenuView *menuView;
//数据模型
@property (nonatomic, strong)FriendCricleModel *model;
//cell点击代理
@property (nonatomic, weak) id<FriendCellDelegate> friendDelegate;
//获取点击的是哪个cell
@property (nonatomic, strong) NSIndexPath *indexPath;
//tableView cell初始化方法
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end


/*** 代理协议，cell上各种点击事件 ***/
@protocol FriendCellDelegate <NSObject>

@optional
// 查看全文/收起
- (void)didSelectFullText:(NSIndexPath *)indexPath;
// 点赞
- (void)didZan:(NSIndexPath *)indexPath;
// 评论
- (void)didComment:(NSIndexPath *)indexPath;
//回复别人的评论
- (void)commentUserComment:(NSIndexPath *)indexPath index:(NSInteger)index;
//点击头像
- (void)didClickHeaderImage:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
