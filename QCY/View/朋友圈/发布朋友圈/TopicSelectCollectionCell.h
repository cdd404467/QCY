//
//  TopicSelectCollectionCell.h
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendTopicModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedIndexBlock)(NSInteger index);
@interface TopicSelectCollectionCell : UICollectionViewCell

@property (nonatomic, strong)FriendTopicModel *model;
@property (nonatomic, assign)NSInteger selecteIndex;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy)SelectedIndexBlock selectedIndexBlock;
@end

NS_ASSUME_NONNULL_END
