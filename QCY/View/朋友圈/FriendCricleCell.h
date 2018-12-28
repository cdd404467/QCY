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
//- (void)didSelectFullText:(NSIndexPath *)indexPath;
// 查看全文/收起
- (void)didSelectFullText:(NSString *)tieziID;
// 点赞
- (void)didZan:(NSString *)tieziID;
// 评论
- (void)didComment:(NSString *)tieziID;
//回复别人的评论
- (void)commentUserComment:(NSString *)tieziID index:(NSInteger)index;
//点击头像
- (void)didClickHeaderImage:(NSString *)userID;
//点击名字跳转到个人信息
- (void)didClickUserName:(NSString *)userID;
//点击头像跳转到个人信息
- (void)didClickZanUserHeader:(NSString *)userID;
//关注或取消关注
- (void)focusOrCancel:(NSString *)tieziID;
//查看详情
- (void)didLookDetail:(NSString *)tieziID;
// 删除动态
- (void)didDeleteDynamic:(NSString *)tieziID;

@end

@interface HeaderTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END


