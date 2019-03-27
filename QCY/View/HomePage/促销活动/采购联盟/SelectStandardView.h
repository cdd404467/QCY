//
//  SelectStandardView.h
//  QCY
//
//  Created by i7colors on 2019/2/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^OKBtnClickBlock)(void);
@interface SelectStandardView : UIView
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)OKBtnClickBlock okBtnClickBlock;
@property (nonatomic, copy)NSArray *standArr;
@end

NS_ASSUME_NONNULL_END
