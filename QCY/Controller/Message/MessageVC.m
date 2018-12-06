//
//  MessageVC.m
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MessageVC.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "MsgChildVC.h"
#import "MsgSystemVC.h"


#define Child_Height SCREEN_HEIGHT - NAV_HEIGHT - 86 - TABBAR_HEIGHT
#define Child_Count 2
@interface MessageVC ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIButton *buyerMsg_btn;
@property (nonatomic, strong)UIButton *sellerMsg_btn;
@property (nonatomic, strong)UIButton *systemMsg_btn;
@property (nonatomic, strong)UIButton *selectedBtn; //选中按钮
@property (nonatomic, assign)NSInteger currentSelectBtnTag;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = View_Color;
    
    [self setNavBar];
    [self setupUI];
    
    [self.view addSubview:self.scrollView];
    [self addVCs];
}

- (void)setNavBar {
    self.nav.titleLabel.text = @"消息";
    self.nav.backgroundColor = [UIColor clearColor];
    self.nav.bottomLine.hidden = YES;
    self.nav.backBtn.hidden = YES;
    self.nav.titleLabel.textColor = [UIColor whiteColor];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, NAV_HEIGHT + 86, SCREEN_WIDTH, Child_Height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * Child_Count,Child_Height);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (void)addVCs {
    MsgChildVC *vc_1 = [[MsgChildVC alloc]init];
    vc_1.type = @"buyer";
    [self addChildViewController:vc_1];
    
    MsgChildVC *vc_2 = [[MsgChildVC alloc]init];
    vc_2.type = @"seller";
    [self addChildViewController:vc_2];
    
//    MsgSystemVC *vc_3 = [[MsgSystemVC alloc]init];
//    [self addChildViewController:vc_3];
    
    [self scrollViewDidEndDecelerating:self.scrollView];
}


//滑动减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取contentOffset
    CGPoint currentOffset = scrollView.contentOffset;
    
    NSInteger page = currentOffset.x / SCREEN_WIDTH;
    
    //取出对应控制器
    UIViewController *viewController = self.childViewControllers[page];
    
    
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(page * SCREEN_WIDTH, 0, SCREEN_WIDTH, Child_Height);
    //之前的按钮
    UIButton *btn = (UIButton *)[self.view viewWithTag:_currentSelectBtnTag];
    btn.selected = NO;
    //即将选中的按钮
    NSInteger cur_tag = page + 1000;
    UIButton *btn_sel = (UIButton *)[self.view viewWithTag:cur_tag];
    btn_sel.selected = YES;
    self.selectedBtn = btn_sel;
    _currentSelectBtnTag = cur_tag;
}


- (void)setupUI {
    UIView *topBg = [[UIView alloc] init];
    topBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT + 46);
    UIImage *image = [UIImage imageNamed:@"msg_bg"];
    topBg.layer.contents = (id)image.CGImage;
    [self.view insertSubview:topBg belowSubview:self.nav];
    
    CGFloat leftGap = 8;
    CGFloat centergap = 18;
    CGFloat width = (SCREEN_WIDTH - leftGap * 2 - centergap * (Child_Count - 1)) / Child_Count;
    
    for (NSInteger i = 0; i < Child_Count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 10;
        btn.clipsToBounds = YES;
        btn.tag = 1000 + i;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(btnClickSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topBg.mas_bottom).offset(-5);
            make.left.mas_equalTo(leftGap + (width + centergap) * i);
            make.height.mas_equalTo(65);
            make.width.mas_equalTo(width);
        }];
        
        if (i == 0) {
            _buyerMsg_btn = btn;
            [_buyerMsg_btn setTitle:@"买家消息" forState:UIControlStateNormal];
            [_buyerMsg_btn setImage:[UIImage imageNamed:@"msg_buyer_black"] forState:UIControlStateNormal];
            [_buyerMsg_btn setImage:[UIImage imageNamed:@"msg_buyer_white"] forState:UIControlStateSelected];
            //默认选择第一个
            _buyerMsg_btn.selected = YES;
            self.selectedBtn = _buyerMsg_btn;
            _currentSelectBtnTag = _buyerMsg_btn.tag;
        } else if (i == 1) {
            _sellerMsg_btn = btn;
            [_sellerMsg_btn setTitle:@"卖家消息" forState:UIControlStateNormal];
            [_sellerMsg_btn setImage:[UIImage imageNamed:@"msg_seller_black"] forState:UIControlStateNormal];
            [_sellerMsg_btn setImage:[UIImage imageNamed:@"msg_seller_white"] forState:UIControlStateSelected];
        } else {
            _systemMsg_btn = btn;
            [_systemMsg_btn setTitle:@"系统消息" forState:UIControlStateNormal];
            [_systemMsg_btn setImage:[UIImage imageNamed:@"msg_sys_black"] forState:UIControlStateNormal];
            [_systemMsg_btn setImage:[UIImage imageNamed:@"msg_sys_white"] forState:UIControlStateSelected];
        }
    }
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
        [self.scrollView setContentOffset:CGPointMake(page * SCREEN_WIDTH, 0) animated:YES];
        
        //取出对应控制器
        UIViewController *viewController = self.childViewControllers[page];
        [self.scrollView addSubview:viewController.view];
        viewController.view.frame = CGRectMake(page * SCREEN_WIDTH, 0, SCREEN_WIDTH, Child_Height);
    }
    
    self.selectedBtn = sender;
}



//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
