//
//  ImageCell.h
//  QCY
//
//  Created by i7colors on 2018/11/7.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)UIImageView *cellImageView;
@end

NS_ASSUME_NONNULL_END
