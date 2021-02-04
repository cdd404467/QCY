//
//  ZhuJiDiyDetailHeaderView.h
//  QCY
//
//  Created by i7colors on 2019/8/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZhuJiDiyModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiyDetailHeaderView : UIView
@property (nonatomic, strong) ZhuJiDiyModel *model;
@property (nonatomic, copy) NSString *jumpFrom;
@end

NS_ASSUME_NONNULL_END
