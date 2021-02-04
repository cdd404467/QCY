//
//  AskToBuyDetailsHeaderView.h
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AskToBuyModel;
@class YYLabel;

NS_ASSUME_NONNULL_BEGIN

@interface AskToBuyDetailsHeaderView : UIView
- (void)setupUIWithStarNumber:(NSInteger)number;
@property (nonatomic, strong)UILabel *sLabel;
@property (nonatomic, strong) YYLabel *stateLabel;
@property (nonatomic, strong)AskToBuyModel *model;
@end

NS_ASSUME_NONNULL_END
