//
//  MsgDetaiiVC.h
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AlreadyReadBlock)(NSString *dID);
@interface MsgDetaiiVC : BaseViewControllerNav

@property (nonatomic, copy)NSString *msgID;
@property (nonatomic, copy)AlreadyReadBlock alreadyReadBlock;
@end

NS_ASSUME_NONNULL_END
