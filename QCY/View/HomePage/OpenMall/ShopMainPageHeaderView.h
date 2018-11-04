//
//  ShopMainPageHeaderView.h
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface ShopMainPageHeaderView : UIView

- (void)setupUI:(NSInteger)number model:(ProductInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
