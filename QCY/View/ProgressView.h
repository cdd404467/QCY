//
//  ProgressView.h
//  QCY
//
//  Created by i7colors on 2019/1/8.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UILabel *percentLabel;
- (void)removeView;
@end

NS_ASSUME_NONNULL_END
