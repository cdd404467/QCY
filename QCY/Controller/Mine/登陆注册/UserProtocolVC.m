//
//  UserProtocolVC.m
//  QCY
//
//  Created by i7colors on 2018/12/7.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UserProtocolVC.h"
#import <WebKit/WebKit.h>
#import "HelperTool.h"


@interface UserProtocolVC ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end



@implementation UserProtocolVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [super useImgMode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundColor:Like_Color];
    self.view.backgroundColor = Like_Color;

    [self loadWebView];
    [self setBottomView];
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_HEIGHT, 3);
        [_progressView setTrackTintColor:MainColor];
        _progressView.progressTintColor = RGBA(72, 209, 204, 1);
    }
    return _progressView;
}

- (void)loadWebView
{
    [self.view addSubview:self.progressView];
    //1.创建WKWebView
    _webView = [[WKWebView alloc] init];
    _webView.backgroundColor = UIColor.whiteColor;
    //2.创建URL
    NSString *urlString = _webUrl;
    NSURL *URL = [NSURL URLWithString:urlString];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    [_webView loadRequest:request];
    //5.添加到视图
    [self.view insertSubview:_webView atIndex:0];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.bottom.mas_equalTo(-TABBAR_HEIGHT);
    }];
    
    [self.webView.superview layoutIfNeeded];
    [HelperTool setRound:self.webView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:30.0f];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

//添加KVO监听,计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
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
    }
}

- (void)setBottomView {
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.backgroundColor = Like_Color;
    [bottomBtn setTitle:@"阅读并同意" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
    }];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
