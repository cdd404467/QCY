//
//  MsgDetaiiVC.h
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class MessageModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^AlreadyReadBlock)(NSString *dID);
@interface MsgDetaiiVC : BaseViewController
@property (nonatomic, strong) MessageModel *model;
@property (nonatomic, copy) AlreadyReadBlock alreadyReadBlock;
////消息类型
//@property (nonatomic, copy) NSString *msgType;
////买家还是卖家消息
//@property (nonatomic, copy) NSString *userType;
//@property (nonatomic, copy) NSString *msgID;
@end

NS_ASSUME_NONNULL_END
