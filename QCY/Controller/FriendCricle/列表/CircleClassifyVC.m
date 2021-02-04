//
//  CircleClassifyVC.m
//  QCY
//
//  Created by i7colors on 2019/3/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CircleClassifyVC.h"
#import <SDAutoLayout.h>
#import "NavControllerSet.h"
#import <SGPagingView.h>
#import "FriendCircleVC.h"
#import "PublishFriendCircleVC.h"
#import "FriendCircleDelegate.h"
#import "HelperTool.h"
#import <UIImageView+WebCache.h>
#import "MyFriendCircleInfoVC.h"
#import "FriendFind_ClassifyVC.h"
#import "FCUnReadMsgView.h"
#import "NewMsgListVC.h"
#import <UMAnalytics/MobClick.h>

#define HiddenOffsetY 56

@interface CircleClassifyVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,FriendCircleDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (nonatomic, strong) UIImageView *leftMyheaderImage;
@property (nonatomic, strong)FCUnReadMsgView *msgView;
@end

@implementation CircleClassifyVC {
    CGFloat tableViewOffsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self dealWithMsg];
    NSString *FCMsg = @"FC_UnRead_Msg_message";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithMsg) name:FCMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alreadyRead) name:@"FC_ReadMsg" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"印染圈"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"印染圈"];
}

//接收到未读消息
- (void)dealWithMsg {
    [self newMsgTip:Get_Badge_Fc];
}

#pragma mark 有消息提示
- (void)newMsgTip:(NSString *)tips {
    DDWeakSelf;
    if (tips.integerValue == 0)
        return;
    
    NSString *tipText = [NSString stringWithFormat:@"您有%@条新的消息",tips];
    if ([self.view viewWithTag:444]) {
        _msgView.title = tipText;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            weakself.pageContentScrollView.top = weakself.pageContentScrollView.top + 35;
            weakself.pageContentScrollView.height = weakself.pageContentScrollView.height - 35;
        }];
        FCUnReadMsgView *msgView = [FCUnReadMsgView new];
        msgView.tag = 444;
        msgView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 35);
        msgView.title = tipText;
        [msgView.unReadBtn addTarget:self action:@selector(goToReadMsg) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:msgView];
        _msgView = msgView;
    }
}

- (void)goToReadMsg {
    NewMsgListVC *vc = [[NewMsgListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alreadyRead {
    [self removeNewMsgTip];
    NSMutableDictionary *userDict = [User_Info mutableCopy];
    [userDict setObject:@"0" forKey:@"fcBadge"];
    [UserDefault setObject:userDict forKey:@"userInfo"];
    [self.navigationController.tabBarController.viewControllers[1].tabBarItem setBadgeValue:nil];
}

//移除视图
- (void)removeNewMsgTip {
    [_msgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_msgView removeFromSuperview];
    DDWeakSelf;
    if (_pageContentScrollView.top > NAV_HEIGHT) {
        [UIView animateWithDuration:0.2 animations:^{
            weakself.pageContentScrollView.top = weakself.pageContentScrollView.top - 35;
            weakself.pageContentScrollView.height = weakself.pageContentScrollView.height + 35;
        }];
    }
}

- (void)setNavBar {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 38)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *leftMyheaderImage = [[UIImageView alloc] init];
    leftMyheaderImage.frame = CGRectMake(6, 0, 38, 38);
    [view addSubview:leftMyheaderImage];
    leftMyheaderImage.hidden = YES;
    leftMyheaderImage.layer.cornerRadius = 19;
    leftMyheaderImage.clipsToBounds = YES;
    [HelperTool addTapGesture:leftMyheaderImage withTarget:self andSEL:@selector(jumpToMyInfo)];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    _leftMyheaderImage = leftMyheaderImage;
    
    //发布按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 0, 38, 44);
    UIImage *image = [UIImage imageNamed:@"friend_publish"];
    [publishBtn setImage:[image imageWithTintColor_My:UIColor.blackColor] forState:UIControlStateNormal];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    publishBtn.adjustsImageWhenHighlighted = NO;
    publishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [publishBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(jumpToPublishVC) forControlEvents:UIControlEventTouchUpInside];
    
    publishBtn.imageView.sd_layout
    .topSpaceToView(publishBtn, 4)
    .centerXEqualToView(publishBtn)
    .widthIs(24)
    .heightIs(23);

    publishBtn.titleLabel.sd_layout
    .bottomSpaceToView(publishBtn, 4)
    .leftEqualToView(publishBtn)
    .rightEqualToView(publishBtn)
    .heightIs(12);
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    self.navigationItem.titleView = [self configTitleView];
}

- (SGPageTitleView *)configTitleView {
    NSArray *titleArr = @[@"发现", @"热门", @"关注"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = HEXColor(@"#868686", 1);
    configure.indicatorColor = UIColor.blackColor;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 5.f;
    configure.titleSelectedColor = UIColor.blackColor;
    configure.titleFont = [UIFont boldSystemFontOfSize:17];
//    configure.titleTextZoomRatio = 0.2;
    configure.needBounces = NO;
    configure.titleTextZoom = YES;
    configure.indicatorAnimationTime = 0.2f;
    configure.titleGradientEffect = YES;
    
    CGRect titleRect = CGRectMake(0, 0, KFit_W(190), 44);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = UIColor.clearColor;
    _pageTitleView.selectedIndex = 0;
    
    FriendCircleVC *vc_1 = [[FriendCircleVC alloc] init];
    vc_1.type = @"topic";
    vc_1.tbFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
    vc_1.firstType = @"hot";
    
    FriendFind_ClassifyVC *vc_2 = [[FriendFind_ClassifyVC alloc] init];
   
    FriendCircleVC *vc_3 = [[FriendCircleVC alloc] init];
    vc_3.type = @"topic";
    vc_3.tbFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
    vc_3.firstType = @"focus";
    
    CGRect contentRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:contentRect parentVC:self childVCs:@[vc_2, vc_1,vc_3]];
//    _pageContentScrollView.delegatePageContentScrollView = self;
    _pageContentScrollView.isScrollEnabled = NO;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
    
    return self.pageTitleView;
}


//present到发布朋友圈页面
- (void)jumpToPublishVC {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
    }
    PublishFriendCircleVC *vc = [[PublishFriendCircleVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

//跳转到我的个人信息页面
- (void)jumpToMyInfo {
    NSString *notiName = @"hiddenKeyBoard";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.ofType = @"mine";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark pagetitle 代理方法

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    
    NSString *notiName = @"hiddenKeyBoard";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
    
    if (selectedIndex == 1) {
        if (tableViewOffsetY > HiddenOffsetY) {
            _leftMyheaderImage.hidden = NO;
        } else {
            _leftMyheaderImage.hidden = YES;
        }
    } else {
        _leftMyheaderImage.hidden = YES;
    }
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    //只要到其他页面，肯定是隐藏
//    if (targetIndex != 1 && progress == 1.0) {
//        _leftMyheaderImage.hidden = YES;
//    }
//    //滚动到发现页面
//    if (targetIndex == 1 && progress == 1.0) {
//        if (tableViewOffsetY > HiddenOffsetY) {
//             _leftMyheaderImage.hidden = NO;
//        } else {
//            _leftMyheaderImage.hidden = YES;
//        }
//    }
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
