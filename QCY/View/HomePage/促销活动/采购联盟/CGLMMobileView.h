//
//  CGLMMobileView.h
//  QCY
//
//  Created by i7colors on 2019/3/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGLMMobileView : UIView
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *bindBtn;
- (void)removeSignView;
@end

NS_ASSUME_NONNULL_END
