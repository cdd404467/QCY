//
//  FCMapVC.h
//  QCY
//
//  Created by i7colors on 2019/4/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class FriendCricleModel;
NS_ASSUME_NONNULL_BEGIN

@interface FCMapVC : BaseViewController
@property (nonatomic, strong)FriendCricleModel *model;
@end


@interface MapTBHeader : UIView
@property (nonatomic, copy) NSArray *countArr;
@end

NS_ASSUME_NONNULL_END
