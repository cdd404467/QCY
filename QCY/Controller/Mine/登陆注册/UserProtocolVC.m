//
//  UserProtocolVC.m
//  QCY
//
//  Created by i7colors on 2018/12/7.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UserProtocolVC.h"
#import <WebKit/WebKit.h>
#import "MacroHeader.h"

@interface UserProtocolVC ()
@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation UserProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.titleLabel.text = @"用户协议";
    [self loadWebView];
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, NAV_HEIGHT - 1.5, SCREEN_HEIGHT, 3);
        [_progressView setTrackTintColor:MainColor];
        _progressView.progressTintColor = RGBA(72, 209, 204, 1);
    }
    return _progressView;
}


- (void)loadWebView
{
    [self.nav addSubview:self.progressView];
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT)];
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
