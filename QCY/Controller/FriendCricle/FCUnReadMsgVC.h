//
//  FCUnReadMsgVC.h
//  QCY
//
//  Created by i7colors on 2018/12/17.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RemoveUnreadViewBlock)(void);
@interface FCUnReadMsgVC : BaseViewControllerNav

@property (nonatomic, copy)RemoveUnreadViewBlock removeUnreadViewBlock;
@end

NS_ASSUME_NONNULL_END
