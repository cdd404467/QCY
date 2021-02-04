//
//  NonmemberCompanyInfoVC.m
//  QCY
//
//  Created by i7colors on 2019/7/12.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "NonmemberCompanyInfoVC.h"
#import <WebKit/WebKit.h>
#import "FriendCricleModel.h"
#import "MapNavigationClass.h"
#import "Alert.h"


@interface NonmemberCompanyInfoVC ()<WKNavigationDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *contactBgView;
@property (nonatomic, strong) UIView *cpInfoBgView;
@property (nonatomic, strong) UILabel *contactLab;
@property (nonatomic, strong) UILabel *phoneNumLab;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UIButton *goNavigationBtn;
@end

@implementation NonmemberCompanyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业详情";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _scrollView.backgroundColor = Like_Color;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.height);
        //是否可以滚动
        _scrollView.scrollEnabled = YES;
        //禁止水平滚动
        _scrollView.alwaysBounceHorizontal = NO;
        //允许垂直滚动
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
        //        _scrollView.backgroundColor = [UIColor blueColor];
    }
    return _scrollView;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];

    _contactBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, 0)];
    _contactBgView.layer.cornerRadius = 10;
    _contactBgView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:_contactBgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 26, _contactBgView.width - 55, 20)];
    titleLab.text = @"联系信息";
    titleLab.font = [UIFont systemFontOfSize:18];
    [_contactBgView addSubview:titleLab];
    
    _contactLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom + 15, titleLab.width, 15)];
    NSString *contact = [NSString string];
    if (isRightData(_model.market.contact)) {
        contact = [NSString stringWithFormat:@"联系人:   %@",_model.market.contact];
    } else {
        contact = @"联系人:   暂无";
    }
    _contactLab.text = contact;
    _contactLab.textColor = HEXColor(@"#666666", 1);
    _contactLab.font = [UIFont systemFontOfSize:15];
    [_contactBgView addSubview:_contactLab];
    
    _phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, _contactLab.bottom + 15, titleLab.width, 15)];
    NSString *phone = [NSString string];
    if (isRightData(_model.market.phone)) {
        phone = [NSString stringWithFormat:@"联系电话:   %@",_model.market.phone];
    } else {
        phone = @"联系电话:   暂无";
    }
    _phoneNumLab.text = phone;
    _phoneNumLab.textColor = HEXColor(@"#666666", 1);
    _phoneNumLab.font = [UIFont systemFontOfSize:15];
    [_contactBgView addSubview:_phoneNumLab];
    
    _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, _phoneNumLab.bottom + 15, titleLab.width, 0)];
    NSString *address = [NSString string];
    if (isRightData(_model.address)) {
        address = [NSString stringWithFormat:@"地址:   %@",_model.address];
    } else {
        address = @"地址:   暂无";
    }
    _addressLab.text = address;
    _addressLab.numberOfLines = 0;
    _addressLab.textColor = HEXColor(@"#666666", 1);
    _addressLab.font = [UIFont systemFontOfSize:15];
    [_contactBgView addSubview:_addressLab];
    CGFloat height = [_addressLab.text boundingRectWithSize:CGSizeMake(_addressLab.width, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:_addressLab.font}
                                                    context:nil].size.height;
    _addressLab.height = height;
    
    //导航按钮
    _goNavigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goNavigationBtn.frame = CGRectMake((_contactBgView.width - 120) / 2, _addressLab.bottom + 18, 120, 32);
    [_goNavigationBtn setImage:[UIImage imageNamed:@"shop_daohang"] forState:UIControlStateNormal];
    _goNavigationBtn.adjustsImageWhenHighlighted = NO;
    [_goNavigationBtn addTarget:self action:@selector(mapNavigation) forControlEvents:UIControlEventTouchUpInside];
    [_contactBgView addSubview:_goNavigationBtn];
    _contactBgView.height = _goNavigationBtn.bottom + 26;
    
    
    //公司简介
    _cpInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(_contactBgView.left, _contactBgView.bottom + 15, SCREEN_WIDTH - 20, 100)];
    _cpInfoBgView.layer.cornerRadius = 10;
    _cpInfoBgView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:_cpInfoBgView];
    
    
    UILabel *titleLab_1 = [[UILabel alloc] initWithFrame:CGRectMake(24, 26, _cpInfoBgView.width - 55, 20)];
    titleLab_1.text = @"公司简介";
    titleLab_1.font = [UIFont systemFontOfSize:18];
    [_cpInfoBgView addSubview:titleLab_1];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom + 15, titleLab.width, 1) configuration:[self fitWebView]];
    _webView.navigationDelegate = self;
    _webView.scrollView.scrollEnabled = NO;
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_cpInfoBgView addSubview:_webView];
    if (isRightData(_model.market.descriptionStr)) {
        [_webView loadHTMLString:_model.market.descriptionStr baseURL:nil];
    }
}

- (void)mapNavigation {
    if (_navModel.targetLat == 0.0 && _navModel.targetLon == 0.0) {
        [Alert alertOne:@"暂无该地址信息!" okBtn:@"知道了" OKCallBack:^{
        }];
        return;
    }
    
    [MapNavigationClass showMapNavigationWithModel:_navModel];
}


//KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
//    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
//        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
//        if (newprogress == 1)
//        {
//
//        }
//    }
    
    if (object == _webView.scrollView && [keyPath isEqualToString:@"contentSize"])
    {
        self.webView.height = self.webView.scrollView.contentSize.height;
        _cpInfoBgView.height = _webView.bottom + 26;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _cpInfoBgView.bottom + 40);
    }
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    if (webView == _webView) {
//        NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.webView.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
//        [_webView evaluateJavaScript:meta completionHandler:^(id _Nullable complete, NSError * _Nullable error) {
//            if (complete != nil) {
//                NSLog(@"complete %@", complete);
//            } else if (error) {
//                NSLog(@"error %@", error);
//            }
//        }];
//    }
//}

//网页适配屏幕
- (WKWebViewConfiguration *)fitWebView {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    wkWebConfig.userContentController = wkUController;
    
    return wkWebConfig;
}




- (void)dealloc {
    if (_webView) {
        [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
}
@end
