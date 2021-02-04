//
//  FCMapLeftNavView.h
//  QCY
//
//  Created by i7colors on 2019/7/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCricleModel;
NS_ASSUME_NONNULL_BEGIN

@interface FCMapLeftNavView : UIView
//是否在左边
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, strong)UIButton *touchBtn;
@property (nonatomic, strong)UIButton *navBtn;
@property (nonatomic, strong)FriendCricleModel *model;
@end

NS_ASSUME_NONNULL_END
