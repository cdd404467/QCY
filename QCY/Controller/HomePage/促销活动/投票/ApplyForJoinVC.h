//
//  ApplyForJoinVC.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class ApplyJoinModel;

typedef void(^AddImageBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ApplyForJoinVC : BaseViewController
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *voteID;
@property (nonatomic, copy)NSString *endCode;
@end



@interface ApplyForJoinCell : UITableViewCell
@property (nonatomic, strong)ApplyJoinModel *model;
@property (nonatomic, copy)AddImageBlock addImageBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
