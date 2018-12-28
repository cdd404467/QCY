//
//  FriendHeaderView.h
//  QCY
//
//  Created by i7colors on 2018/11/26.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCricleInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendHeaderView : UIView

@property (nonatomic, strong)FriendCricleInfoModel *model;
@property (nonatomic, strong)UILabel *noLoginLabel;
@end

NS_ASSUME_NONNULL_END
