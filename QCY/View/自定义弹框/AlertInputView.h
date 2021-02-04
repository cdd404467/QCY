//
//  AlertInputView.h
//  QCY
//
//  Created by i7colors on 2020/4/14.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertInputView : UIView
@property (nonatomic, strong) UITextField *phoneNumberTF;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightbtn;
- (void)show;
- (void)remove;
@end

NS_ASSUME_NONNULL_END
