//
//  FCRecordCell.h
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCricleModel;

NS_ASSUME_NONNULL_BEGIN
@interface FCRecordCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableVie;
@property (nonatomic, strong)FriendCricleModel *model;
@end

NS_ASSUME_NONNULL_END
