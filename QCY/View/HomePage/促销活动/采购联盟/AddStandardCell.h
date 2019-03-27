//
//  AddStandardCell.h
//  QCY
//
//  Created by i7colors on 2019/3/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JianBtnClick)(NSString *title);
@interface AddStandardCell : UITableViewCell
@property (nonatomic, copy)NSString *itemTitle;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)JianBtnClick jianBtnClick;
@end

NS_ASSUME_NONNULL_END
