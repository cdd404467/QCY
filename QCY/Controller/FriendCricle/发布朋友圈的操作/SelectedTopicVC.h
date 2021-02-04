//
//  SelectedTopicVC.h
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseSystemPresentVC.h"
@class FriendTopicModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectTopicBlock)(FriendTopicModel *topicModel);
@interface SelectedTopicVC : BaseSystemPresentVC
@property (nonatomic, copy)SelectTopicBlock selectTopicBlock;
@end

NS_ASSUME_NONNULL_END
