//
//  JudgeTools.h
//  QCY
//
//  Created by i7colors on 2019/7/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JudgeTools : NSObject
//判断是否是模拟器
+ (BOOL)is_SimuLator;
//判断是否是debug模式
+ (BOOL)is_Debug;
//判断是否是企业用户
+ (BOOL)is_CompanyUser;
//用户类型
+ (NSInteger)getUserType;
//联系客服
+ (void)callWithPhoneNumber:(NSString *)number;
+ (void)callService;
@end

NS_ASSUME_NONNULL_END
