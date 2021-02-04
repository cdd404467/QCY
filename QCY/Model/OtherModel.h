//
//  OtherModel.h
//  QCY
//
//  Created by i7colors on 2019/8/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>


NS_ASSUME_NONNULL_BEGIN

@interface OtherModel : NSObject

@end

@interface AreaModel : NSObject
//code码
@property (nonatomic, copy) NSString *regionCode;
//地址名字
@property (nonatomic, copy) NSString *regionName;
//地址数组
@property (nonatomic, copy) NSArray<AreaModel *> *regionList;
@end


NS_ASSUME_NONNULL_END
