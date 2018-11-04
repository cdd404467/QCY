//
//  MineCollectionCell.h
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineCollectionCell : UICollectionViewCell
@property (nonatomic, strong)UIButton *iconBtn;
@property (nonatomic, strong)UILabel *numberLabel;
- (void)configData:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
