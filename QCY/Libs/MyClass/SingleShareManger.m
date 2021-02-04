//
//  SingleShareManger.m
//  QCY
//
//  Created by i7colors on 2019/4/28.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SingleShareManger.h"

@implementation SingleShareManger

static SingleShareManger* _instance = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.updateType = @"type_1";
        self.msgIndex = 0;
    }
    return self;
}

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    }) ;
    return _instance ;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [SingleShareManger shareInstance] ;
}

- (id) copyWithZone:(struct _NSZone *)zone
{
    return [SingleShareManger shareInstance] ;
}



@end
