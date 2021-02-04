//
//  BargainHeaderView.h
//  QCY
//
//  Created by i7colors on 2019/7/24.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupBuyingModel;

NS_ASSUME_NONNULL_BEGIN

@interface BargainHeaderView : UIView
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) GroupBuyingModel *model;
@end

NS_ASSUME_NONNULL_END
