//
//  OperateMenuView.m
//  QCY
//
//  Created by i7colors on 2018/11/28.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OperateMenuView.h"
#import "Friend.h"


@interface OperateMenuView()

@property (nonatomic, strong) UIView *menuView;

@end

@implementation OperateMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(SCREEN_WIDTH - kOperateBtnWidth, 0, kOperateBtnWidth, kOperateHeight);
        _show = NO;
        [self setUpUI];
    }
    return self;
}

#pragma mark - 设置UI
- (void)setUpUI
{
    // 菜单容器视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kOperateWidth - kOperateBtnWidth, 0, kOperateWidth - kOperateBtnWidth, kOperateHeight)];
    view.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:74.0/255.0 blue:75.0/255.0 alpha:1.0];
    view.layer.cornerRadius = 6.0;
    view.layer.masksToBounds = YES;
    // 点赞
    UUButton *btn = [[UUButton alloc] initWithFrame:CGRectMake(0, 0, view.width/2, kOperateHeight)];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    btn.spacing = 3;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"menu_zan"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _zanBtn = btn;
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right-5, 8, 0.5, kOperateHeight-16)];
    line.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [view addSubview:line];
    // 评论
    UUButton *btnComment = [[UUButton alloc] initWithFrame:CGRectMake(line.right, 0, btn.width, kOperateHeight)];
    btnComment.backgroundColor = [UIColor clearColor];
    btnComment.titleLabel.font = [UIFont systemFontOfSize:14.0];
    btnComment.spacing = 3;
    [btnComment setTitle:@"评论" forState:UIControlStateNormal];
    [btnComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnComment setImage:[UIImage imageNamed:@"menu_comment"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnComment];
    self.menuView = view;
    [self addSubview:self.menuView];
    // 菜单操作按钮
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kOperateWidth - kOperateBtnWidth, 0, kOperateBtnWidth,kOperateHeight)];
    UIButton *button = [[UIButton alloc] init];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [button setImage:[UIImage imageNamed:@"menu_nor"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"menu_hl"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    self.menuBtn = button;
    [self addSubview:self.menuBtn];
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.width.height.mas_equalTo(kOperateBtnWidth);
    }];
}

- (void)setZanBtnTitle:(NSString *)zanBtnTitle {
    _zanBtnTitle = zanBtnTitle;
    [_zanBtn setTitle:zanBtnTitle forState:UIControlStateNormal];
}


#pragma mark - 显示/不显示
- (void)setShow:(BOOL)show
{
    _show = show;
    
    CGFloat swidth = kOperateBtnWidth;
    CGFloat sLeft = SCREEN_WIDTH - kOperateBtnWidth;
    
    CGFloat menu_left = kOperateWidth - kOperateBtnWidth;
    CGFloat menu_width = 0;
    
    
    if (_show) {
        menu_left = 0;
        menu_width = kOperateWidth - kOperateBtnWidth;
        swidth = kOperateWidth;
        sLeft = SCREEN_WIDTH - kOperateWidth;
    }
    
    self.width = swidth;
    self.left = sLeft;
    self.menuView.width = menu_width;
    self.menuView.left = menu_left;
}

- (void)setShowAnima:(BOOL)showAnima {
    if (!_show) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    }
    _show = showAnima;
    CGFloat swidth = kOperateBtnWidth;
    CGFloat sLeft = SCREEN_WIDTH - kOperateBtnWidth;
    
    CGFloat menu_left = kOperateWidth-kOperateBtnWidth;
    CGFloat menu_width = 0;
    if (_show) {
        swidth = kOperateWidth;
        sLeft = SCREEN_WIDTH - kOperateWidth;
        menu_left = 0;
        menu_width = kOperateWidth-kOperateBtnWidth;
    }
    
    if (_show) {
        self.width = swidth;
        self.left = sLeft;
    }

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuView.width = menu_width;
        self.menuView.left = menu_left;
    } completion:^(BOOL finished) {
        self.width = swidth;
        self.left = sLeft;
    }];
//    [UIView animateWithDuration:0.2 animations:^{
//        self.menuView.width = menu_width;
//        self.menuView.left = menu_left;
//    }];
}

#pragma mark - 事件
- (void)menuClick
{
    if (!_show) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    }
    _show = !_show;
    CGFloat swidth = kOperateBtnWidth;
    CGFloat sLeft = SCREEN_WIDTH - kOperateBtnWidth;
    
    CGFloat menu_left = kOperateWidth-kOperateBtnWidth;
    CGFloat menu_width = 0;
    if (_show) {
        swidth = kOperateWidth;
        sLeft = SCREEN_WIDTH - kOperateWidth;
        menu_left = 0;
        menu_width = kOperateWidth-kOperateBtnWidth;
    }
    
    if (_show) {
        self.width = swidth;
        self.left = sLeft;
    }

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuView.width = menu_width;
        self.menuView.left = menu_left;
    } completion:^(BOOL finished) {
        self.width = swidth;
        self.left = sLeft;
    }];
   
//    [UIView animateWithDuration:0.2 animations:^{
//        self.menuView.width = menu_width;
//        self.menuView.left = menu_left;
//    }];
}

//点赞事件
- (void)likeClick
{
    if (self.likeMoment) {
        self.likeMoment();
    }
}

//评论事件
- (void)commentClick
{
    if (self.commentMoment) {
        self.commentMoment();
    }
}


@end
