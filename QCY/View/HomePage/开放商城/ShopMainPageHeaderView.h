//
//  ShopMainPageHeaderView.h
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OpenMallModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^JumpToCheckBlock)(void);
@interface ShopMainPageHeaderView : UIView

@property (nonatomic, copy)JumpToCheckBlock jumpToCheckBlock;
- (void)setupUI:(NSInteger)number model:(OpenMallModel *)model;
@end

NS_ASSUME_NONNULL_END
