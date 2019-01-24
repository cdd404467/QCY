//
//  ManifestScetionHeader.h
//  QCY
//
//  Created by i7colors on 2019/1/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrchaseLeagueModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^RightBtnClick)(BOOL isOpen);

@interface ManifestScetionHeader : UITableViewHeaderFooterView
@property (nonatomic, strong)PrchaseLeagueModel *model;
@property (nonatomic, copy)RightBtnClick rightBtnClick;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
