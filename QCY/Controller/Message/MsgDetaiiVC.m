//
//  MsgDetaiiVC.m
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MsgDetaiiVC.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "MessageModel.h"
#import <Masonry.h>
#import "AskToBuyDetailsVC.h"

@interface MsgDetaiiVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)MessageModel *dataSource;
@end

@implementation MsgDetaiiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self requestData];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        //是否可以滚动
        _scrollView.scrollEnabled = YES;
        //禁止水平滚动
        _scrollView.alwaysBounceHorizontal = NO;
        //允许垂直滚动
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
//        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)setupNav {
    self.nav.titleLabel.text = @"消息详情";
    [ClassTool addLayer:self.nav frame:self.nav.frame];
    self.nav.titleLabel.textColor = [UIColor whiteColor];
    self.nav.bottomLine.hidden = YES;
    [self.nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
}

#pragma mark - 请求详情
- (void)requestData {
    DDWeakSelf;
    //    [CddHUD show];
    NSString *urlString = [NSString stringWithFormat:URL_AskBuy_Msg_Detail,User_Token,_msgID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [MessageModel mj_objectWithKeyValues:json[@"data"]];
            if (weakself.alreadyReadBlock) {
                weakself.alreadyReadBlock(weakself.msgID);
            }
            [weakself setupUI];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)setupUI {
    CGFloat totalHeight;
    [self.view addSubview:self.scrollView];
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:14];
    productName.textColor = [UIColor blackColor];
    productName.numberOfLines = 0;
    productName.text = _dataSource.productName;
    [self.scrollView addSubview:productName];
    CGSize size1 = [productName sizeThatFits:CGSizeMake(SCREEN_WIDTH - 24, MAXFLOAT)];
    productName.frame = CGRectMake(12, 24, SCREEN_WIDTH - 24, size1.height);
    totalHeight = 24 + size1.height;
    
    //正文
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = HEXColor(@"#868686", 1);
    contentLabel.numberOfLines = 0;
    contentLabel.text = _dataSource.content;
    [self.scrollView addSubview:contentLabel];
    CGSize size2 = [contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 24, MAXFLOAT)];
    contentLabel.frame = CGRectMake(12, totalHeight + 12, SCREEN_WIDTH - 24, size2.height);
    totalHeight = totalHeight + 12 + size2.height;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = HEXColor(@"#868686", 1);
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    timeLabel.text = _dataSource.createdAt;
    timeLabel.frame = CGRectMake(12, totalHeight + 80, SCREEN_WIDTH - 24, 16);
    [self.scrollView addSubview:timeLabel];
    totalHeight = totalHeight + 80 + 16 + 22;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, totalHeight);
    
    
    //跳转详情
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jumpBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jumpToDetail) forControlEvents:UIControlEventTouchUpInside];
    [jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:jumpBtn];
    [self.view addSubview:jumpBtn];
    [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}

- (void)jumpToDetail {
    AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
    vc.buyID = _dataSource.enquiryId;
    [self.navigationController pushViewController:vc animated:YES];
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

@end
