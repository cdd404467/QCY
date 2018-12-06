//
//  BindMobileView.h
//  DSXS
//
//  Created by 李明哲 on 2018/7/14.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindMobileView : UIView

@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *bindBtn;
@property (nonatomic, copy)NSString *bToken;
- (void)removeSignView;
@end
