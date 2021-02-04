//
//  POIAnnotationModel.h
//  DSXS
//
//  Created by 李明哲 on 2018/5/31.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface POIAnnotationModel : NSObject<MAAnnotation>

@property (nonatomic, readonly, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

- (NSString *)city;

- (NSString *)area;

- (instancetype)initWithPOI:(AMapPOI *)poi;
+ (instancetype)annWithPOI:(AMapPOI *)poi;

@end
