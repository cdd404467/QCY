//
//  CustomNavigationBar.h
//  QCY
//
//  Created by i7colors on 2019/3/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomNavigationBar : UIImageView
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy)NSString *navTitle;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIColor *leftBtnTintColor;
@property (nonatomic, strong)UIColor *leftBtnTextColor;
@property (nonatomic, strong)UIColor *rightBtnTextColor;
@property (nonatomic, strong)UIFont *leftBtnFont;
@property (nonatomic, strong)UIFont *rightBtnFont;

@property (nonatomic, assign)CGFloat leftGap;
@property (nonatomic, assign)CGFloat rightGap;
@property (nonatomic, assign)CGFloat leftWidth;
@property (nonatomic, assign)CGFloat rightWidth;
@property (nonatomic, assign)CGFloat leftHeight;
@property (nonatomic, assign)CGFloat rightHeight;
@property (nonatomic, assign)CGFloat leftTopGap;
@property (nonatomic, assign)CGFloat rightTopGap;


@end

NS_ASSUME_NONNULL_END
