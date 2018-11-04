//
//  MineHeaderView.h
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYLabel;
@class PaddingLabel;

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView : UIView
@property (nonatomic, strong) UIImageView *userHeader;
@property (nonatomic, strong) YYLabel *userName;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *idBtn;
@property (nonatomic, strong)PaddingLabel *historyLabel;
- (void)configData:(NSString *)historyAsk offer:(NSString *)hisOffer;
@end

NS_ASSUME_NONNULL_END
