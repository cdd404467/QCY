//
//  POIAnnotationModel.m
//  DSXS
//
//  Created by 李明哲 on 2018/5/31.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import "POIAnnotationModel.h"

@interface POIAnnotationModel ()

@property (nonatomic, readwrite, strong) AMapPOI *poi;

@end

@implementation POIAnnotationModel

@synthesize poi = _poi;

#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    return self.poi.address;
}
//市
- (NSString *)city
{
    return self.poi.city;
}

//区
- (NSString *)area
{
    return self.poi.district;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init])
    {
        self.poi = poi;
    }
    
    return self;
}

+ (instancetype)annWithPOI:(AMapPOI *)poi {
    
    return [[self alloc]initWithPOI:poi];
}

@end
