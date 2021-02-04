//
//  ZhuJiDiyReceiveSolutionCell.h
//  QCY
//
//  Created by i7colors on 2019/8/9.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuJiDiySolutionModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^AcceptBtnBlock)(NSString *solutionID);

@interface ZhuJiDiyReceiveSolutionCell : UITableViewCell
@property (nonatomic, strong) ZhuJiDiySolutionModel *model;
@property (nonatomic, copy) AcceptBtnBlock acceptBtnBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView type:(NSString *)jumpFrom;
@end

NS_ASSUME_NONNULL_END
