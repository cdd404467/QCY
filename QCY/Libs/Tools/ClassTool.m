//
//  ClassTool.m
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ClassTool.h"
#import "MacroHeader.h"
#import <AFNetworking.h>
#import "NetWorkingPort.h"
#import "AES128.h"
#import "CddHUD.h"

@implementation ClassTool

+ (UIButton *)customBackBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 2, 50, 40);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    return backBtn;
}

//添加垂直渐变
+ (void)addLayerVertical:(UIView *)view frame:(CGRect)frame startColor:(UIColor *)sColor endColor:(UIColor *) eColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)sColor.CGColor, (__bridge id)eColor.CGColor];
    gradientLayer.locations = @[@0.0, @0.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(0.0,1.0);
    gradientLayer.frame = frame;
    //    [view.layer addSublayer:gradientLayer];
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)addLayer:(UIView *)view frame:(CGRect)frame {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#f26c27"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#ee2788"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.3);
    gradientLayer.endPoint = CGPointMake(1.0,0.7);
    gradientLayer.frame = frame;
//    [view.layer addSublayer:gradientLayer];
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)addLayer:(UIView *)view {
    [self addLayer:view frame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
}

+ (void)afnErrorState:(NSInteger)errorCode {
    //获取状态吗
    //  NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    if (errorCode == -1009) {
//        [ClassTool showSuccessOrFailSVP:@"请检查网络" displayTime:1.5 isSuccess:NO];
    } else if (errorCode == -1001) {
        [CddHUD hideHUD];
        
//        if ([self getCurrentVC].navigationController != nil) {
//            [[self getCurrentVC].navigationController.view addSubview:_progressHUD];
//        }else{
        
//            [[self getCurrentVC].view addSubview:_progressHUD];
//        }
        [CddHUD showTextOnlyDelay:@"请求超时" view:[self getCurrentVC].view];
//        [CddHUD showTextOnlyDelay:@"请求超时"];
    } else {
        [CddHUD showTextOnlyDelay:@"请求失败"];
    }
}

//获取apiToken,先判断本地

+ (NSString *)getApiToken:(BOOL)isGetFromNet {
    
    NSString *apiName = [NSString stringWithFormat:URL_API_TOKEN,[AES128 AES128Encrypt]];
//    NSString *apiTokenUrlString = [NSString stringWithFormat:@"%@%@",URL_ALL_API,apiName];
    //获取本地存储的apiToken
    __block NSString *localApiToken = [UserDefault objectForKey:@"apiToken"];
    //创建信号
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //本地如果没有apiToken，就去后台请求
    if (!localApiToken || [localApiToken isEqualToString:@""] || isGetFromNet == YES) {
//        AFHTTPSessionManager * apiTokenManager = [AFHTTPSessionManager manager];
        NSURL *URL = [NSURL URLWithString:URL_ALL_API];
        AFHTTPSessionManager *apiTokenManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
//        [apiTokenManager setSecurityPolicy:[self customSecurityPolicy]];
        //将参数json序列化
        apiTokenManager.requestSerializer = [AFJSONRequestSerializer serializer];
        apiTokenManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        [apiTokenManager GET:apiName parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            localApiToken = responseObject[@"data"];
//            if (localApiToken && ![localApiToken isEqualToString:@""] && ![localApiToken isEqualToString:@"null"] && localApiToken != NULL) {
            if (isRightData(localApiToken)){
                [UserDefault setObject:localApiToken forKey:@"apiToken"];
                [UserDefault synchronize];
            }
            dispatch_semaphore_signal(semaphore);   //发送信号
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            localApiToken = @"没网我就呵呵了";     //不加这句话(代码)，在没网且本地没apiToken的时候，就boom了，很尴尬
            dispatch_semaphore_signal(semaphore);   //发送信号
        }];
    } else {
        dispatch_semaphore_signal(semaphore);   //发送信号
    }
    //没收到信号之前一直会卡在这里
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return localApiToken;
}

//接收非json的数据，文件流
+ (void)getRequestWithStream:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
//    NSString *urlString = [URL_ALL_API stringByAppendingString:requestUrl];
    //请求
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSURL *URL = [NSURL URLWithString:URL_ALL_API];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    //将参数json序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //将d返回的头http序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
    
}


// Get请求带apiToken
+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSString *requestOne = [requestUrl stringByReplacingOccurrencesOfString:@"QCYDSSIGNCDD" withString:[ClassTool getApiToken:NO]];
//    NSString *urlStringOne = [URL_ALL_API stringByAppendingString:requestOne];
    //获得请求管理者
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSURL *URL = [NSURL URLWithString:URL_ALL_API];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    manager.requestSerializer.timeoutInterval = 30.0f;
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    //json序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //发送Get请求
    [manager GET:requestOne parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"INVALID_SIGN"]) {
            //第二次请求的参数要改变（apiToken）
            NSString *requestTwo = [requestUrl stringByReplacingOccurrencesOfString:@"QCYDSSIGNCDD" withString:[ClassTool getApiToken:YES]];
//            NSString *urlStringTwo = [URL_ALL_API stringByAppendingString:requestTwo];
            //发起第二次请求
            [manager GET:requestTwo parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                    if(![To_String(responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
                        [CddHUD hideHUD];
                        [CddHUD showTextOnlyDelay:responseObject[@"msg"]];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    [ClassTool afnErrorState:error.code];
                    failure(error);
                }
            }];
            
        }else {
            if (success) {
                success(responseObject);
                if(![To_String(responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
                    [CddHUD hideHUD];
                    [CddHUD showTextOnlyDelay:responseObject[@"msg"]];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [ClassTool afnErrorState:error.code];
            failure(error);
        }
    }];
}

// Post请求
+ (void)postRequest:(NSString *)requestUrl Params:(NSMutableDictionary *)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    [params setValue:[ClassTool getApiToken:NO] forKey:@"sign"];
//    NSString *urlString = [URL_ALL_API stringByAppendingString:requestUrl];
    
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSURL *URL = [NSURL URLWithString:URL_ALL_API];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
   
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    //发送Post请求
    [manager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"INVALID_SIGN"]) {
            //修改第二次请求字典中的apiToken
            [params setValue:[ClassTool getApiToken:YES] forKey:@"apiToken"];
            //修改签名,判断字典里有没有签名这个字段，有的话修改后再请求
            if ([params objectForKey:@"sign"]) {
                [params removeObjectForKey:@"sign"];
                [params setValue:[ClassTool getApiToken:YES] forKey:@"sign"];
            }
            //发起第二次请求
            [manager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                    if(![To_String(responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
                        [CddHUD hideHUD];
                        [CddHUD showTextOnlyDelay:responseObject[@"msg"]];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    [ClassTool afnErrorState:error.code];
                    failure(error);
                }
            }];
        } else {
            if (success) {
                success(responseObject);
                if(![To_String(responseObject[@"code"]) isEqualToString:@"SUCCESS"]) {
                    [CddHUD hideHUD];
                    [CddHUD showTextOnlyDelay:responseObject[@"msg"]];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [ClassTool afnErrorState:error.code];
            failure(error);
        }
    }];
}

//支持https
+ (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ssl" ofType:@"cer"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *certData = [NSData data];
    
    if ([fileManager fileExistsAtPath:cerPath]) {
        certData = [NSData dataWithContentsOfFile:cerPath];
    }
    else {
        NSLog(@"ssl证书不存在");
    }
  
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}


+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *View = [[window subviews] objectAtIndex:0];
    UIView *frontView = [[View subviews] lastObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    else{
        result = window.rootViewController;
    }
    return result;
}


@end
