//
//  PublishFriendCircleVC.h
//  QCY
//
//  Created by i7colors on 2018/12/3.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BasePresentViewController.h"
#import "FriendCircleDelegate.h"

@class InfomationModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^PublishComoletedBlock)(void);
typedef void(^DeleteZXViewBlock)(void);
@interface PublishFriendCircleVC : BasePresentViewController
@property (nonatomic, copy)PublishComoletedBlock publishComoletedBlock;
@property (nonatomic,weak) id <FriendCircleDelegate> delegate;
@property (nonatomic, strong)InfomationModel *shareZinXunModel;

@end


@interface PublishHeaderView : UIView <FriendCircleDelegate>
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic,weak) id <FriendCircleDelegate> headerChangeDelegate;
@property (nonatomic, strong)DeleteZXViewBlock deleteZXViewBlock;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *videoArray;
@end



@interface ZiXunView : UIView
@property (nonatomic, strong)DeleteZXViewBlock deleteZXViewBlock;
@property (nonatomic, strong)InfomationModel *model;
@end
NS_ASSUME_NONNULL_END
