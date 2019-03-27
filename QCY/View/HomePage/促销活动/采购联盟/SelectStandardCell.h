//
//  SelectStandardCell.h
//  QCY
//
//  Created by i7colors on 2019/2/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetingTypeListModel;
NS_ASSUME_NONNULL_BEGIN
@interface SelectStandardCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)MeetingTypeListModel *model;
@property (nonatomic, assign)NSInteger index;
@end

NS_ASSUME_NONNULL_END
