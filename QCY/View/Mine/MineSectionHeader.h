//
//  MineSectionHeader.h
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UIButton *rightBtn;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
