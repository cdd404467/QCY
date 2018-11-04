//
//  AES128.h
//  QCY
//
//  Created by i7colors on 2018/10/12.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES128 : NSObject

+ (NSString *)AES128Encrypt;
+ (NSString *)AES128Encrypt:(NSString *)plainText;
+ (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key isUrl:(BOOL)isUrl;

@end

NS_ASSUME_NONNULL_END
