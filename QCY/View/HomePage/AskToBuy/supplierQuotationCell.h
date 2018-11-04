//
//  supplierQuotationCell.h
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AskToBuyDetailModel;
@class supOrrerModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CbtnClickBlock)(NSString *offerID);

@interface supplierQuotationCell : UITableViewCell

@property (nonatomic, strong)UILabel *noneLabel;
@property (nonatomic, strong)AskToBuyDetailModel *model;
@property (nonatomic, strong)supOrrerModel *model_sup;
@property (nonatomic, copy)CbtnClickBlock cbtnClickBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
