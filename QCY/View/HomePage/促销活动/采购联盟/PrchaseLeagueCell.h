//
//  PrchaseLeagueCell.h
//  QCY
//
//  Created by i7colors on 2019/1/8.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrchaseLeagueModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClickBlock)(NSInteger tag, NSString *goodsID, NSString *state);
@interface PrchaseLeagueCell : UITableViewCell
@property (nonatomic, strong)PrchaseLeagueModel *model;
@property (nonatomic, copy)BtnClickBlock btnClickBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
