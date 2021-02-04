//
//  MyInfoCenterVC.h
//  QCY
//
//  Created by i7colors on 2018/11/12.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "ChangeHeaderVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyInfoCenterVC : BaseViewController

@end


typedef void(^HeaderBlock)(void);
@interface MyInfoCenterHeaderView : UIView
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UIImageView *companyType;
- (void)changeInfo;
@property (nonatomic, copy) HeaderBlock headerBlock;
@end

NS_ASSUME_NONNULL_END
