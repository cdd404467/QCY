//
//  AutoImageCell.h
//  QCY
//
//  Created by i7colors on 2019/3/27.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoImageCell : UITableViewCell
@property (nonatomic, strong)UIImageView *cellImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
