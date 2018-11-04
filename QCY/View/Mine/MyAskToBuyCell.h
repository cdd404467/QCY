//
//  MyAskToBuyCell.h
//  QCY
//
//  Created by i7colors on 2018/10/23.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAskToBuyModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClickBlock)(NSString *pID);
@interface MyAskToBuyCell : UITableViewCell


@property (nonatomic, copy)BtnClickBlock btnClickBlock;
@property (nonatomic, strong)MyAskToBuyModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
