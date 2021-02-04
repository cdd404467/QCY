//
//  BaseViewController.h
//  QCY
//
//  Created by i7colors on 2018/9/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "NavControllerSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
//有tableView的页面用到的属性
@property (nonatomic, assign)int pageNumber;
@property (nonatomic, assign)int totalNumber;
@property (nonatomic, assign)BOOL isRefreshList;
@property (nonatomic, assign)BOOL isFirstLoadData;
//nav 返回按钮的
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIColor *backBtnTintColor;
@property (nonatomic, strong)UIColor *backBtnBgColor;
- (void)jumpToLogin;
- (void)jumpToLoginWithComplete:(void (^ __nullable)(void))handler;
@end

NS_ASSUME_NONNULL_END
