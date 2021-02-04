//
//  ProxySaleDetailHV.h
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProxySaleModel;
NS_ASSUME_NONNULL_BEGIN

@interface ProxySaleDetailHV : UIView
@property (nonatomic, strong) ProxySaleModel *dataSource;
@property (nonatomic, assign) CGFloat viewHeight;
@end

NS_ASSUME_NONNULL_END
