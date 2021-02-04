//
//  NewMsgListVC.h
//  QCY
//
//  Created by i7colors on 2019/4/18.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface NewMsgListVC : BaseViewController
@end

@interface NewMsgCell : UITableViewCell
@property (nonatomic, strong)UIImageView *icomImageView;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, copy)NSString *badgeStr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
