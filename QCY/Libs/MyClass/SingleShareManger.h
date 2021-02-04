//
//  SingleShareManger.h
//  QCY
//
//  Created by i7colors on 2019/4/28.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface SingleShareManger : NSObject
+(instancetype) shareInstance;
@property (nonatomic, copy) NSString *updateType;
@property (nonatomic, assign) NSInteger msgIndex;
@end

NS_ASSUME_NONNULL_END
