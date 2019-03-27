//
//  AuctionDetailHeader.h
//  QCY
//
//  Created by i7colors on 2019/3/6.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuctionModel;

NS_ASSUME_NONNULL_BEGIN

@interface AuctionDetailHeader : UIView
@property (nonatomic, strong)AuctionModel *model;
@property (nonatomic, assign)CGFloat viewHeight;
@end

NS_ASSUME_NONNULL_END
