//
//  GroupBuyDetailHeaderView.h
//  QCY
//
//  Created by i7colors on 2018/11/2.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupBuyingModel;
@class CountDown;

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyDetailHeaderView : UIView

@property (nonatomic, strong)CountDown *countDownTimer;
@property (nonatomic, strong)GroupBuyingModel *dataSource;
- (instancetype)initWithDataSource:(GroupBuyingModel *)dataSource;
@end

NS_ASSUME_NONNULL_END
