//
//  BargainAlertView.h
//  QCY
//
//  Created by i7colors on 2019/7/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ShareBlock)(void);
@interface BargainAlertView : UIView
- (instancetype)initWithPrice:(NSString *)price unit:(NSString *)unit;
@property (nonatomic, copy) ShareBlock shareBlock;
@end

NS_ASSUME_NONNULL_END
