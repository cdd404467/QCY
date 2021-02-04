//
//  PullDownTopicView.h
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedIndexBlock)(NSInteger index);
typedef void(^CloseBlock)(void);
@interface PullDownTopicView : UIView
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, copy)SelectedIndexBlock selectedIndexBlock;
@property (nonatomic, copy)CloseBlock closeBlock;
- (void)pullAction;
- (void)pullClose;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
