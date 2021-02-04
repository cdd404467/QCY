//
//  ADAlertView.h
//  QCY
//
//  Created by i7colors on 2019/10/29.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertView : UIView
+ (ADAlertView *)showWithURL:(NSString *)url handler:(void (^ __nullable)(void))handler;
@end

NS_ASSUME_NONNULL_END
