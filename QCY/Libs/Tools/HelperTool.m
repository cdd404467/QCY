//
//  HelperTool.m
//  QCY
//
//  Created by i7colors on 2018/9/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HelperTool.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>

@implementation HelperTool

//  添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

//找到导航栏的黑线
+ (UIImageView *)findNavLine:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findNavLine:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//圆角
+ (void)setRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius {
    [view layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

//获取当前显示的控制器
+ (UIViewController *)getCurrentVC
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
    
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//1.colors 渐变的颜色
//2.locations 渐变颜色的分割点
//3.startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变

+ (void)textGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}

// 视频转换为MP4
+ (NSURL *)convertToMp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    return mp4Url;
}

+ (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

//视频压缩
+ (NSURL *)yasuoVideoNewUrl:(NSURL *)url {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    // 沙盒目录
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *destFilePath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateTime]];
    NSURL *destUrl = [NSURL fileURLWithPath:destFilePath];
    //将视频文件copy到沙盒目录中
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager copyItemAtURL:url toURL:destUrl error:&error];
//    NSLog(@"压缩前--%.2fk",[self getFileSize:destFilePath]);
    // 进行压缩
    AVAsset *asset = [AVAsset assetWithURL:destUrl];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.shouldOptimizeForNetworkUse = YES;
    // 创建导出的url
    NSString *resultPath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"h%@.mp4",dateTime]];
    session.outputURL = [NSURL fileURLWithPath:resultPath];
    // 必须配置输出属性
    session.outputFileType = AVFileTypeMPEG4;
    // 导出视频
    [session exportAsynchronouslyWithCompletionHandler:^{
//        NSLog(@"压缩后---%.2fk",[self getFileSize:resultPath]);
//        NSLog(@"视频导出完成");
    }];
    
    return session.outputURL;
}


+ (NSString*)dataPath
{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

//版本比较,1 - 线上大于当前版本，要更新， 0 - 版本相同
+ (NSInteger)compareVersionWithOnline:(NSString *)onlineVersion oldVersion:(NSString *)oldVersion {
    // 都为空，相等，返回0
    if (!onlineVersion && !oldVersion) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!onlineVersion && oldVersion) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (onlineVersion && !oldVersion) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [onlineVersion componentsSeparatedByString:@"."];
    NSArray *v2Array = [oldVersion componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

//解决小数点精度问题
+ (NSString*)getStringFrom:(double)doubleVal {
    NSString* stringValue = @"0.00";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.usesSignificantDigits = true;
    formatter.maximumSignificantDigits = 100;
    formatter.groupingSeparator = @"";
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    stringValue = [formatter stringFromNumber:@(doubleVal)];
    
    return stringValue;
}

@end
