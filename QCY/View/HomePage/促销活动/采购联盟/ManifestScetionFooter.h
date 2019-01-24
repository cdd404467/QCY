//
//  ManifestScetionFooter.h
//  QCY
//
//  Created by i7colors on 2019/1/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrchaseLeagueModel;

NS_ASSUME_NONNULL_BEGIN

@interface ManifestScetionFooter : UITableViewHeaderFooterView

@property (nonatomic, strong)PrchaseLeagueModel *model;
+ (instancetype)footerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
