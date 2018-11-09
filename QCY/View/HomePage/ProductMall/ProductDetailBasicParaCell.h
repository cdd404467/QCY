//
//  ProductDetailBasicParaCell.h
//  QCY
//
//  Created by i7colors on 2018/10/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PropMap;

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailBasicParaCell : UITableViewCell

@property (nonatomic, strong)UIView *vLine;
@property (nonatomic, strong)UILabel *noneLabel;
@property (nonatomic, strong)PropMap *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
