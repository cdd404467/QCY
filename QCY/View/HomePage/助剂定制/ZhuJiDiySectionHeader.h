//
//  ZhuJiDiySectionHeader.h
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiySectionHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *titleLab;;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
