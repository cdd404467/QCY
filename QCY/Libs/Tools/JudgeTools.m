//
//  JudgeTools.m
//  QCY
//
//  Created by i7colors on 2019/7/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "JudgeTools.h"

@implementation JudgeTools
+ (BOOL)is_SimuLator {
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        return YES;
    } else {
        //真机
        return NO;
    }
}

+ (BOOL)is_Debug {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)is_CompanyUser {
    if ([[User_Info objectForKey:@"isCompany"] boolValue] == YES) {
        return YES;
    }
    return NO;
}

+ (NSInteger)getUserType {
    NSString *usertype = [User_Info objectForKey:@"userType"];
    if ([usertype isEqualToString:@"PERSONAL_USER"]) {
        return 1;
    } else if ([usertype isEqualToString:@"NORMAL_COMPANY_USER"]) {
        return 2;
    } else if ([usertype isEqualToString:@"FEE_COMPANY_USER"]) {
        return 3;
    }
    return 0;
}

//联系客服
+ (void)callWithPhoneNumber:(NSString *)number {
    NSString *tel = [NSString stringWithFormat:@"tel://%@",number];
    //开线程，解决ios10调用慢的问题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:tel]];
        });
    });
}

+ (void)callService {
    [self callWithPhoneNumber:CompanyContact];
}
@end
