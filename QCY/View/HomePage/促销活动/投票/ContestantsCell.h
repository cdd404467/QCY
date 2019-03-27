//
//  ContestantsCell.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoteUserModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^VoteClickBlock)(NSString *voteUserID);
@interface ContestantsCell : UITableViewCell

@property (nonatomic, copy)VoteClickBlock voteClickBlock;
@property (nonatomic, strong)VoteUserModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
