//
//  MapNavigationClass.m
//  QCY
//
//  Created by i7colors on 2019/7/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MapNavigationClass.h"
#import "FriendCricleModel.h"
#import "CddActionSheetView.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>


@implementation MapNavigationClass

+ (void)showMapNavigationWithModel:(FCMapNavigationModel *)model {
    NSArray *endLocation = @[@(model.targetLat),@(model.targetLon)];
    NSMutableArray *maps = [NSMutableArray array];
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        baiduMapDic[@"url"] = [self baiduMap:model];
        [maps addObject:baiduMapDic];
    }
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        gaodeMapDic[@"url"] = [self iosMap:model];
        [maps addObject:gaodeMapDic];
    }
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",endLocation[0], endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < maps.count; i++) {
        NSString * title = maps[i][@"title"];
        [mArr addObject:title];
    }
    
    NSArray *titleArr = @[[mArr copy]];
    DDWeakSelf;
    CddActionSheetView *sheetView = [[CddActionSheetView alloc] initWithOptions:titleArr completion:^(NSInteger index) {
        if (index == 0) {
            [weakself appleMap:model];
        } else {
            NSString *urlString = maps[index][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    } cancel:^{
        NSLog(@"取消");
    }];
    [sheetView show];
}


//百度地图
+ (NSString *)baiduMap:(FCMapNavigationModel *)model {
    NSString *urlString =[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",model.targetLat, model.targetLon,model.endLocationName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlString;
}

//高德地图
+ (NSString *)iosMap:(FCMapNavigationModel *)model {
    NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0", model.nowLat, model.nowLon,@"我的位置", model.targetLat, model.targetLon, model.endLocationName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlString;
}

//腾讯地图
+ (NSString *)qqMap:(FCMapNavigationModel *)model {
    NSString *urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%lf,%lf&policy=1&referer=tengxun",model.endLocationName,model.targetLat,model.targetLon];
//    if (model.targetLat != 0 && model.targetLon != 0) {
//        urlString = [NSString stringWithFormat:@"%@&tocoord=%f,%f&to=%@",urlString, model.targetLat, model.targetLon ,model.endLocationName];
//    } else {
//
//    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlString;
}

//苹果原生地图
+ (void)appleMap:(FCMapNavigationModel *)model {
    //终点坐标
    CLLocationCoordinate2D desCoordinate = CLLocationCoordinate2DMake(model.targetLat, model.targetLon);
    //用户位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    currentLocation.name = @"我的位置";
    
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
    toLocation.name = [NSString stringWithFormat:@"%@",model.endLocationName];
    
    NSDictionary *dict = @{
                           MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                           MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                           MKLaunchOptionsShowsTrafficKey : @(YES)
                           };
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:dict];
}
@end
