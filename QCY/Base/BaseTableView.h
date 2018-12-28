//
//  BaseTableView.h
//  QCY
//
//  Created by i7colors on 2018/12/17.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableView : UITableView<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

NS_ASSUME_NONNULL_END
