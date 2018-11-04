//
//  CommonNav.h
//  QCY
//
//  Created by i7colors on 2018/10/9.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonNav : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, copy)NSString *navTitle;
@end

NS_ASSUME_NONNULL_END
