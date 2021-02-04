//
//  VCJump.h
//  QCY
//
//  Created by i7colors on 2019/4/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseNavigationController;
@class MessageModel;
@class BannerModel;
NS_ASSUME_NONNULL_BEGIN

@interface VCJump : NSObject
//推送通知点击跳转 - 系统消息
+ (void)jumpToWithModel_Apns:(BannerModel *)model;
//推送通知点击跳转 - 买家、卖家消息
+ (void)jumpToVCWithModel:(MessageModel *)model;
//系统消息点击跳转
+ (void)jumpToWithModel_SysMsgs:(MessageModel *)model;
//分享打开
+ (void)openShareURLWithHost:(NSString *)host query:(NSString *)query nav:(BaseNavigationController *)nav;

//广告跳转
+ (void)jumpToWithModel_Ad:(BannerModel *)model;
@end

NS_ASSUME_NONNULL_END
