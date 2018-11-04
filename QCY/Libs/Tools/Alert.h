//
//  Alert.h
//  QCY
//
//  Created by i7colors on 2018/10/24.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Alert : NSObject
+ (void)alertOne:(NSString *)title okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK;
+ (void)alertTwo:(NSString *)title cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK;
@end

NS_ASSUME_NONNULL_END
