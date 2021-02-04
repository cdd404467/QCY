//
//  FCZiXunView.h
//  QCY
//
//  Created by i7colors on 2019/4/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareBeanModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickZiXunViewBlock)(void);
@interface FCZiXunView : UIView
@property (nonatomic, strong)ShareBeanModel *model;
@property (nonatomic, copy)ClickZiXunViewBlock clickZiXunViewBlock;
@end

NS_ASSUME_NONNULL_END
