//
//  AddCustomGoodsVC.h
//  QCY
//
//  Created by i7colors on 2019/2/20.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@class MeetingShopListModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^AddCustomGoodsBlock)(MeetingShopListModel *model);
@interface AddCustomGoodsVC : BaseViewController
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)AddCustomGoodsBlock addCustomGoodsBlock;
@end

NS_ASSUME_NONNULL_END
