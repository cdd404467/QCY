//
//  OperateMenuView.h
//  QCY
//
//  Created by i7colors on 2018/11/28.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUButton.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^LikeMoment)(void);
typedef void (^CommentMoment)(void);
@interface OperateMenuView : UIView
@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) BOOL showAnima;
@property (nonatomic, strong)UUButton *zanBtn;
@property (nonatomic, copy)NSString *zanBtnTitle;
- (void)menuClick;
// 赞
@property (nonatomic, copy)LikeMoment likeMoment;
//@property (nonatomic, copy) void (^likeMoment)(void);
// 评论
@property (nonatomic, copy)CommentMoment commentMoment;
//@property (nonatomic, copy) void (^commentMoment)(void);
@end

NS_ASSUME_NONNULL_END
