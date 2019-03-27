//
//  PublishFriendCircleVC.h
//  QCY
//
//  Created by i7colors on 2018/12/3.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BasePresentViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PublishComoletedBlock)(void);
@interface PublishFriendCircleVC : BasePresentViewController

@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *publishBtn;
@property (nonatomic, copy)PublishComoletedBlock publishComoletedBlock;
@end

@interface PublishHeaderView : UIView

@end


NS_ASSUME_NONNULL_END
