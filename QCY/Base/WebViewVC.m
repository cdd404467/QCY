//
//  WebViewVC.m
//  QCY
//
//  Created by i7colors on 2019/4/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "WebViewVC.h"
#import <WebKit/WebKit.h>


@interface WebViewVC ()<WKNavigationDelegate>
@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, assign)CGFloat wvHeight;
@end

@implementation WebViewVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _needBottom = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title)
        self.title = @"七彩云电商";
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavigationSwitchStyle:1];
    [self.backBtn setImage:[UIImage imageNamed:@"close_back"] forState:UIControlStateNormal];
    self.backBtn.left = self.backBtn.left;
    
    if (self.needBottom == YES) {
        [self setBottomView];
    }
    self.wvHeight = self.needBottom == YES ? SCREEN_HEIGHT - NAV_HEIGHT - Bottom_Height_Dif - 45 : SCREEN_HEIGHT - NAV_HEIGHT;
    [self loadWebView];
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_HEIGHT, 3);
        [_progressView setTrackTintColor:MainColor];
//        _progressView.progressTintColor = RGBA(72, 209, 204, 1);
        _progressView.progressTintColor = UIColor.clearColor;
    }
    return _progressView;
}

- (void)loadWebView
{
    [self.view addSubview:self.progressView];
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,self.wvHeight)];
    _webView.backgroundColor = UIColor.whiteColor;
    _webView.navigationDelegate = self;
    //2.创建URL
    NSString *urlString = _webUrl;
    NSURL *URL = [NSURL URLWithString:urlString];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    [_webView loadRequest:request];
    //5.添加到视图
    //    self.webView = webView;
    [self.view insertSubview:_webView belowSubview:_progressView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //修改字体大小（方法一）
//    NSString *fontSize = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",45];
//    [ webView evaluateJavaScript:fontSize completionHandler:nil];

    
    //修改字体颜色
//    NSString *colorString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#000000'"];
//    [webView evaluateJavaScript:colorString completionHandler:nil];
}

//添加KVO监听,计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.leftBtn.enabled = self.webView.canGoBack;
    self.rightBtn.enabled = self.webView.canGoForward;
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        if (newprogress == 1)
        {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }
        else
        {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
    
}

- (void)setBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - Bottom_Height_Dif - 45, SCREEN_WIDTH, 45)];
    bottomView.backgroundColor = Like_Color;
    [self.view addSubview:bottomView];
    
    UIImage *image = [UIImage imageNamed:@"webview_back"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 5, 30, 30);
    [leftBtn setImage:image forState:UIControlStateNormal];
    [leftBtn setImage:[image imageWithTintColor_My:RGBA(0, 0, 0, 0.25)] forState:UIControlStateDisabled];
    [leftBtn addTarget:self action:@selector(webViewGoBack) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftBtn];
    leftBtn.centerX = bottomView.width / 4;
    leftBtn.centerY = bottomView.height / 2;
    _leftBtn = leftBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 5, 30, 30);
    [rightBtn setImage:image forState:UIControlStateNormal];
    [rightBtn setImage:[image imageWithTintColor_My:RGBA(0, 0, 0, 0.25)] forState:UIControlStateDisabled];
    [rightBtn addTarget:self action:@selector(webViewGoForward) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightBtn];
    rightBtn.centerX = bottomView.width / 4 * 2;
    rightBtn.centerY = leftBtn.centerY;
    rightBtn.transform = CGAffineTransformMakeRotation(M_PI);
    _rightBtn = rightBtn;
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(0, 5, 30, 30);
    [refreshBtn setImage:[UIImage imageNamed:@"webView_refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(webViewReload) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:refreshBtn];
    refreshBtn.centerX = bottomView.width / 4 * 3;
    refreshBtn.centerY = leftBtn.centerY;
}



//webView 返回事件
- (void)webViewGoBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

//前进
- (void)webViewGoForward {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)webViewReload {
    [self.webView reload];
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}
@end
