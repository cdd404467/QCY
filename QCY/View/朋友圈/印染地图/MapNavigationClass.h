//
//  MapNavigationClass.h
//  QCY
//
//  Created by i7colors on 2019/7/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FCMapNavigationModel;

NS_ASSUME_NONNULL_BEGIN

@interface MapNavigationClass : NSObject
+ (void)showMapNavigationWithModel:(FCMapNavigationModel *)model;
@end

NS_ASSUME_NONNULL_END
