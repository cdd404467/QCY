//
//  FCDetailCommentVC.h
//  QCY
//
//  Created by i7colors on 2018/12/11.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickCellPLBlock)(NSString *commentID, NSString *isSelf, NSString *user);
@interface FCDetailCommentVC : BaseViewController
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *tieziID;
@property (nonatomic, copy)ClickCellPLBlock clickCellPLBlock;
@end

NS_ASSUME_NONNULL_END
