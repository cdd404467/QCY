//
//  MessageVC.m
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MessageVC.h"
#import "MsgChildVC.h"
#import "MsgSystemVC.h"
#import "ClassTool.h"
#import "UIView+Border.h"
#import <UMAnalytics/MobClick.h>
#import "MsgCountBtn.h"


#define Child_Height SCREEN_HEIGHT - NAV_HEIGHT - 80 - TABBAR_HEIGHT
#define Child_Count 3
@interface MessageVC ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)MsgCountBtn *buyerMsg_btn;
@property (nonatomic, strong)MsgCountBtn *sellerMsg_btn;
@property (nonatomic, strong)MsgCountBtn *systemMsg_btn;
@property (nonatomic, strong)UIButton *selectedBtn; //选中按钮
@property (nonatomic, assign)NSInteger currentSelectBtnTag;
@property (nonatomic, copy) NSArray *vcArray;
@end

@implementation MessageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _index = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MsgChildVC *vc_1 = [[MsgChildVC alloc]init];
    vc_1.userType = @"buyer";
    
    MsgChildVC *vc_2 = [[MsgChildVC alloc]init];
    vc_2.userType = @"seller";
    
    MsgSystemVC *vc_3 = [[MsgSystemVC alloc]init];
    
    self.vcArray = @[vc_1,vc_2,vc_3];
    self.view.backgroundColor = View_Color;
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgCountApns) name:App_Notification_Change_MsgCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUnStartIndex) name:@"msgtab_item_selected" object:nil];
    
    [self.view addSubview:self.scrollView];
    [self changeScrolPageWithIndex:_index];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.navigationItem.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navigationItem.title];
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, NAV_HEIGHT + 80, SCREEN_WIDTH, Child_Height);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * Child_Count,Child_Height);
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}


- (void)setUnStartIndex {
    [self changeScrolPageWithIndex:_index];
    //默认选择第一个
    [self btnClickSelected:[self.view viewWithTag:_index + 1000]];
}

//手动翻页
- (void)changeScrolPageWithIndex:(NSInteger)index {
    [SingleShareManger shareInstance].msgIndex = index;
    [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    UIViewController *viewController = self.vcArray[index];
    [viewController viewWillAppear:YES];
    [self.scrollView addSubview:viewController.view];
    [self addChildViewController:viewController];
    viewController.view.frame = CGRectMake(index * SCREEN_WIDTH, 0, SCREEN_WIDTH, Child_Height);
}

//用来设置或重新设置三个按钮上数字显示
- (void)msgCountApns {
    _buyerMsg_btn.badgeValue = Msg_Buyer_Count_Get;
    _sellerMsg_btn.badgeValue = Msg_Seller_Count_Get;
    _systemMsg_btn.badgeValue = Msg_Sys_Count_Get;
}

- (void)setupUI {
    CGFloat leftGap = 0;
    CGFloat centergap = 0;
    CGFloat width = (SCREEN_WIDTH - leftGap * 2 - centergap * (Child_Count - 1)) / Child_Count;
    for (NSInteger i = 0; i < Child_Count; i++) {
        MsgCountBtn *btn = [MsgCountBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftGap + (width + centergap) * i, NAV_HEIGHT, width, 80);
        btn.tag = 1000 + i;
        btn.imagePosition = SCCustomButtonImagePositionTop;
        btn.backgroundColor = HEXColor(@"#F3F3F3", 1);
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:HEXColor(@"#868686", 1) forState:UIControlStateNormal];
        [btn setTitleColor:HEXColor(@"#ED3851", 1) forState:UIControlStateSelected];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(btnClickSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:btn];
        [btn addBorderView:HEXColor(@"E5E5E5", 1) width:0.6f direction:BorderDirectionTop | BorderDirectionBottom];
        if (i == 0) {
            _buyerMsg_btn = btn;
            [_buyerMsg_btn setTitle:@"我是买家" forState:UIControlStateNormal];
            [_buyerMsg_btn setImage:[UIImage imageNamed:@"msg_buyer_normal"] forState:UIControlStateNormal];
            [_buyerMsg_btn setImage:[UIImage imageNamed:@"msg_buyer_select"] forState:UIControlStateSelected];
        } else if (i == 1) {
            [btn addBorderView:HEXColor(@"E5E5E5", 1) width:0.6f direction:BorderDirectionLeft | BorderDirectionRight];
            _sellerMsg_btn = btn;
            [_sellerMsg_btn setTitle:@"我是卖家" forState:UIControlStateNormal];
            [_sellerMsg_btn setImage:[UIImage imageNamed:@"msg_seller_normal"] forState:UIControlStateNormal];
            [_sellerMsg_btn setImage:[UIImage imageNamed:@"msg_seller_select"] forState:UIControlStateSelected];
        } else {
            _systemMsg_btn = btn;
            [_systemMsg_btn setTitle:@"系统消息" forState:UIControlStateNormal];
            [_systemMsg_btn setImage:[UIImage imageNamed:@"msg_sys_normal"] forState:UIControlStateNormal];
            [_systemMsg_btn setImage:[UIImage imageNamed:@"msg_sys_select"] forState:UIControlStateSelected];
        }
    }
    
    [self msgCountApns];
    UIButton *selectedBtn = (UIButton *)[self.view viewWithTag:1000 + _index];
    //默认选择第一个
    selectedBtn.selected = YES;
    self.selectedBtn = selectedBtn;
    _currentSelectBtnTag = selectedBtn.tag;
}

//判断选择的按钮
- (void)btnClickSelected:(UIButton *)sender {
    //其他按钮
    self.selectedBtn.selected = NO;
    //当前选中按钮
    //如果按下的按钮是之前已经按下的
    if (sender == self.selectedBtn ) {
        sender.selected = YES;
    } else {
        sender.selected = !sender.selected;
        _currentSelectBtnTag = sender.tag;
        //点击按钮翻页
        NSInteger page = _currentSelectBtnTag - 1000;
        [self changeScrolPageWithIndex:page];
    }
    self.selectedBtn = sender;
}

@end
