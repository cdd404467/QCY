//
//  OperateMenuView.h
//  QCY
//
//  Created by i7colors on 2018/11/28.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LikeMoment)(void);
typedef void (^CommentMoment)(void);
@interface OperateMenuView : UIView
@property (nonatomic, assign) BOOL show;

// 赞
@property (nonatomic, copy)LikeMoment likeMoment;
//@property (nonatomic, copy) void (^likeMoment)(void);
// 评论
@property (nonatomic, copy)CommentMoment commentMoment;
//@property (nonatomic, copy) void (^commentMoment)(void);
@end

NS_ASSUME_NONNULL_END
