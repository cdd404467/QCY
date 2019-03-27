//
//  JoinAuctionVC.h
//  QCY
//
//  Created by i7colors on 2019/3/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JoinAuctionVC : BaseViewController
@property (nonatomic, copy)NSString *jpID;
@property (nonatomic, copy)NSString *numUnit;
@property (nonatomic, assign)NSInteger jpCount;
@property (nonatomic, copy)NSString *startPrice;
@property (nonatomic, copy)NSString *nowPrice;
@property (nonatomic, copy)NSString *addPrice;
@end

NS_ASSUME_NONNULL_END
