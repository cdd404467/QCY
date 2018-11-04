//
//  AskToBuyOfferCell.h
//  QCY
//
//  Created by i7colors on 2018/10/22.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AskToBuyOfferModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^BtnClickBlock)(NSString *pID);
@interface AskToBuyOfferCell : UITableViewCell

@property (nonatomic, copy)BtnClickBlock btnClickBlock;
@property (nonatomic, strong)AskToBuyOfferModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
