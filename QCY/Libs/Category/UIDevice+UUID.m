//
//  UIDevice+UUID.m
//  QCY
//
//  Created by i7colors on 2018/10/14.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UIDevice+UUID.h"
#import <SAMKeychain.h>

@implementation UIDevice (UUID)

+ (NSString *)getDeviceID {
    
    NSString *app = @"QCY";
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *deviceID = [SAMKeychain passwordForService:bundleID account:app];
    if (deviceID == nil || [deviceID isEqualToString:@""]) {
        NSError *error = nil;
        deviceID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = bundleID;
        query.account = app;
        query.password = deviceID;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
    }
    
    return deviceID;
    
    //可以删除
    //    BOOL isDelete = [SAMKeychain deletePasswordForService:bundleID account:app];
    //    if (isDelete) {
    //        currentID = [SAMKeychain passwordForService:bundleID account:app];
    //    }
}

@end
