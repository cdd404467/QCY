//
//  ClassTool.h
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//用来封装 上传文件 的数据模型
@interface FormData : NSObject
@property(nonatomic,strong)NSData * fileData;//文件数据
@property(nonatomic,copy)NSString * fileName;//文件名.jpg
@property(nonatomic,copy)NSString * name;//参数名
@property(nonatomic,copy)NSString * fileType;//文件类型
@end


typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
} GradientType;

@interface ClassTool : NSObject
+ (NSString *)getApiToken:(BOOL)isGetFromNet;
+ (UIButton *)customBackBtn;

/*** (0,0)(1.0,0) 水平
    (0,0)(0,1.0) 垂直 ***/
+ (void)addLayer:(UIView *)view;
+ (void)addLayer:(UIView *)view frame:(CGRect)frame;
+ (void)addLayer:(UIView *)view frame:(CGRect)frame startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint;
//水平渐变
+ (void)addLayerHorizontal:(UIView *)view frame:(CGRect)frame startColor:(UIColor *)sColor endColor:(UIColor *)eColor;
//垂直渐变
+ (void)addLayerVertical:(UIView *)view frame:(CGRect)frame startColor:(UIColor *)sColor endColor:(UIColor *) eColor;

+ (UIImage*)getGradedImage:(UIView *)view colors:(NSArray<UIColor *> *)colors gradientType:(GradientType)type;

+ (UIImage *)layerFromStartColor:(UIColor *)startColor stopColor:(UIColor *)stopColor view:(UIView *)view;
/**
 get请求
 
 @param requestUrl 请求路径
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary *)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

/**
 post请求
 
 @param requestUrl 请求路径
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)postRequest:(NSString *)requestUrl Params:(NSMutableDictionary *)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

//获取图片
+ (void)getRequestWithStream:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;
//上传文件
+ (void)uploadFile:(NSString *)requestUrl Params:(NSMutableDictionary *)params DataSource:(FormData *)dataSource Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure Progress:(void(^)(float percent))percent;
//上传多个文件
+ (void)uploadWithMutilFile:(NSString *)requestUrl Params:(NSMutableDictionary *)params ImgsArray:(NSArray *)ImgsArray Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure Progress:(void(^)(float percent))percent;

//分享
+ (void)shareSomething:(NSMutableArray<NSString *> *)imageArray urlStr:(NSString *)urlStr title:(NSString *)title text:(NSString *)text;

//数组转json字符串
+ (NSString *)arrayToJSONString:(NSArray *)array;
@end
