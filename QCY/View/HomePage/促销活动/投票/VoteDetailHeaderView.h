//
//  VoteDetailHeaderView.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VoteModel;

NS_ASSUME_NONNULL_BEGIN

@interface VoteDetailHeaderView : UIView
@property (nonatomic, strong)UILabel *voteLab;
@property (nonatomic, strong)VoteModel *model;
@end

NS_ASSUME_NONNULL_END
