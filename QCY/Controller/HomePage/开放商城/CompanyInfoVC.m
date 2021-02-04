//
//  CompanyInfoVC.m
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CompanyInfoVC.h"
#import <YNPageTableView.h>
#import "OpenMallModel.h"
#import <WebKit/WebKit.h>
#import "MapNavigationClass.h"
#import "FriendCricleModel.h"
#import "Alert.h"

@interface CompanyInfoVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CompanyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:SCREEN_BOUNDS style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Cell_BGColor;
        if (@available(iOS 11.0, *)) {
            _tableView.rowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    }
    return _tableView;
}

#pragma mark - UITableView代理
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//估算高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.dataSource.cellHeight_0;
    }
    else if (indexPath.row == 1) {
        return self.dataSource.cellHeight_1;
    }
    else {
        return self.dataSource.cellHeight_2;
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CompInfoCell_0 *cell = [CompInfoCell_0 cellWithTableView:tableView];
        cell.model = self.dataSource;
        return cell;
    }
    else if (indexPath.row == 1) {
        CompInfoCell_1 *cell = [CompInfoCell_1 cellWithTableView:tableView];
        cell.model = self.dataSource;
        cell.navModel = _navModel;
        return cell;
    }
    else {
        CompInfoCell_2 *cell = [CompInfoCell_2 cellWithTableView:tableView];
        
        cell.model = self.dataSource;
        
        DDWeakSelf;
        cell.cellHeightBlock = ^{

            [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
}

@end

/******   各个cell  *******/
// cell - 0
@implementation CompInfoCell_0 {
    UIView *_bgView;
    UILabel *_productType;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 11, SCREEN_WIDTH - 20, 0)];
    _bgView.layer.cornerRadius = 10;
    _bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bgView];

    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 26, _bgView.width - 55, 20)];
    titleLab.text = @"公司主营";
    titleLab.font = [UIFont systemFontOfSize:18];
    [_bgView addSubview:titleLab];
    
    _productType = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom + 15, titleLab.width, 0)];
    _productType.numberOfLines = 0;
    _productType.textColor = HEXColor(@"#666666", 1);
    _productType.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_productType];
    
}

- (void)setModel:(OpenMallModel *)model {
    _model = model;
    NSMutableArray *tempMArr = [NSMutableArray arrayWithCapacity:0];
    for (BusinessList *m in model.businessList) {
        [tempMArr addObject:m.value];
    }
    _productType.text = [tempMArr componentsJoinedByString:@"、"];
    CGFloat height = [_productType.text boundingRectWithSize:CGSizeMake(_productType.width, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:_productType.font}
                                                           context:nil].size.height;
    _productType.height = height;
    _bgView.height = _productType.bottom + 26;
    model.cellHeight_0 = _bgView.bottom;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CompInfoCell_0";
    CompInfoCell_0 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CompInfoCell_0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end


// cell - 1
@implementation CompInfoCell_1 {
    UIView *_bgView;
    UILabel *_contactLab;
    UILabel *_phoneNumLab;
    UILabel *_addressLab;
    UIButton *_goNavigationBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 11, SCREEN_WIDTH - 20, 0)];
    _bgView.layer.cornerRadius = 10;
    _bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 26, _bgView.width - 55, 20)];
    titleLab.text = @"联系信息";
    titleLab.font = [UIFont systemFontOfSize:18];
    [_bgView addSubview:titleLab];
    
    _contactLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom + 15, titleLab.width, 15)];
    _contactLab.textColor = HEXColor(@"#666666", 1);
    _contactLab.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_contactLab];
    
    _phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, _contactLab.bottom + 15, titleLab.width, 15)];
    _phoneNumLab.textColor = HEXColor(@"#666666", 1);
    _phoneNumLab.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_phoneNumLab];
    
    _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, _phoneNumLab.bottom + 15, titleLab.width, 0)];
    _addressLab.numberOfLines = 0;
    _addressLab.textColor = HEXColor(@"#666666", 1);
    _addressLab.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_addressLab];
    
    //导航按钮
    _goNavigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goNavigationBtn.frame = CGRectMake((_bgView.width - 120) / 2, 0, 120, 32);
    [_goNavigationBtn setImage:[UIImage imageNamed:@"shop_daohang"] forState:UIControlStateNormal];
    _goNavigationBtn.adjustsImageWhenHighlighted = NO;
    [_goNavigationBtn addTarget:self action:@selector(mapNavigation) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_goNavigationBtn];
}

- (void)setModel:(OpenMallModel *)model {
    _model = model;
    
    NSString *contact = [NSString string];
    if (isRightData(model.contact)) {
        contact = [NSString stringWithFormat:@"联系人:   %@",model.contact];
    } else {
        contact = @"联系人:   暂无";
    }
    _contactLab.text = contact;
    
    NSString *phone = [NSString string];
    if (isRightData(model.phone)) {
        phone = [NSString stringWithFormat:@"联系电话:   %@",model.phone];
    } else {
        phone = @"联系电话:   暂无";
    }
    
    _phoneNumLab.text = phone;
    
    
    NSString *address = [NSString string];
    if (isRightData(model.company.address)) {
        address = [NSString stringWithFormat:@"地址:   %@",model.company.address];
    } else {
        address = @"地址:   暂无";
    }
    _addressLab.text = address;
    CGFloat height = [_addressLab.text boundingRectWithSize:CGSizeMake(_addressLab.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:_addressLab.font}
                                                     context:nil].size.height;
    _addressLab.height = height;
    _goNavigationBtn.top = _addressLab.bottom + 18;
    _bgView.height = _goNavigationBtn.bottom + 26;
    model.cellHeight_1 = _bgView.bottom;
}

- (void)mapNavigation {
    if (_navModel.targetLat == 0.0 && _navModel.targetLon == 0.0) {
        [Alert alertOne:@"暂无该地址信息!" okBtn:@"知道了" OKCallBack:^{
        }];
        return;
    }
    [MapNavigationClass showMapNavigationWithModel:_navModel];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CompInfoCell_1";
    CompInfoCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CompInfoCell_1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

// cell - 2

@interface CompInfoCell_2()

@end

@implementation CompInfoCell_2 {
    UIView *_bgView;
    UILabel *_desLab;
    WKWebView *_webView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 11, SCREEN_WIDTH - 20, 0)];
    _bgView.layer.cornerRadius = 10;
    _bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 26, _bgView.width - 55, 20)];
    titleLab.text = @"公司简介";
    titleLab.font = [UIFont systemFontOfSize:18];
    [_bgView addSubview:titleLab];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom + 15, titleLab.width, 1) configuration:[self fitWebView]];
    _webView.scrollView.scrollEnabled = NO;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_bgView addSubview:_webView];
//
//    _desLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom + 15, titleLab.width, 0)];
//    _desLab.numberOfLines = 0;
//    _desLab.textColor = HEXColor(@"#666666", 1);
//    _desLab.font = [UIFont systemFontOfSize:15];
//    [_bgView addSubview:_desLab];
}

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

- (void)setModel:(OpenMallModel *)model {
    _model = model;
    if (isRightData(model.descriptionStr))
        [_webView loadHTMLString:model.descriptionStr baseURL:nil];
    
//    _desLab.text = model.descriptionStr;
//    CGFloat height = [_desLab.text boundingRectWithSize:CGSizeMake(_desLab.width, CGFLOAT_MAX)
//                                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                                 attributes:@{NSFontAttributeName:_desLab.font}
//                                                    context:nil].size.height;
//    _desLab.height = height;
//    _bgView.height = _desLab.bottom + 26;
//    model.cellHeight_2 = _bgView.bottom;
}

//KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];

        if (newprogress == 1)
        {
            _webView.height = _webView.scrollView.contentSize.height;
    
            _bgView.height = _webView.bottom + 26;
            
//            if (_bgView.bottom == _model.cellHeight_2 && _webView.height > 10)
//                return;
//
//            _model.cellHeight_2 = _bgView.bottom;
//            if (self.cellHeightBlock) {
//                self.cellHeightBlock();
//            }

            if (_bgView.bottom != _model.cellHeight_2) {
                if (_webView.height > 10) {
                    _model.cellHeight_2 = _bgView.bottom;
                }
                if (self.cellHeightBlock) {
                    self.cellHeightBlock();
                }
            }
        }

    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CompInfoCell_2";
    CompInfoCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CompInfoCell_2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
