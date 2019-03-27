//
//  CircleClassifyVC.m
//  QCY
//
//  Created by i7colors on 2019/3/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CircleClassifyVC.h"
#import "MacroHeader.h"
#import <SDAutoLayout.h>
#import "NavControllerSet.h"
#import <SGPagingView.h>
#import "FriendCircleVC.h"
#import "PublishFriendCircleVC.h"
#import "FriendCircleDelegate.h"
#import <Masonry.h>
#import "HelperTool.h"
#import <UIImageView+WebCache.h>
#import "MyFriendCircleInfoVC.h"

#define HiddenOffsetY 56

@interface CircleClassifyVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,FriendCircleDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (nonatomic, strong) UIImageView *leftMyheaderImage;
@end

@implementation CircleClassifyVC {
    CGFloat tableViewOffsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
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
    [publishBtn setImage:[UIImage imageNamed:@"friend_publish"] forState:UIControlStateNormal];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    publishBtn.adjustsImageWhenHighlighted = NO;
    publishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [publishBtn setTitleColor:MainColor forState:UIControlStateNormal];
    
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
    
    [publishBtn addTarget:self action:@selector(jumpToPublishVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self vhl_setNavBarBackgroundColor:HEXColor(@"#f3f3f3", 1)];
    [self vhl_setNavBarShadowImageHidden:YES];
    self.navigationItem.titleView = [self configTitleView];
}

- (SGPageTitleView *)configTitleView {
    NSArray *titleArr = @[@"热门", @"发现", @"关注"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#868686", 1);
    configure.indicatorColor = MainColor;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 5.f;
    configure.titleSelectedColor = MainColor;
    configure.titleFont = [UIFont boldSystemFontOfSize:16];
//    configure.titleSelectedFont = [UIFont systemFontOfSize:17];
    configure.titleTextZoomRatio = 0.2;
    configure.needBounces = NO;
    configure.titleTextZoom = YES;
    configure.indicatorAnimationTime = 0.3f;
    configure.titleGradientEffect = YES;
    
    CGRect titleRect = CGRectMake(0, 0, KFit_W(190), 44);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = UIColor.clearColor;
    _pageTitleView.selectedIndex = 1;
    
    FriendCircleVC *vc_1 = [[FriendCircleVC alloc] init];
   
    
    FriendCircleVC *vc_2 = [[FriendCircleVC alloc] init];
    self.delegate = vc_2;
    vc_2.friendDelegate = self;
    
    FriendCircleVC *vc_3 = [[FriendCircleVC alloc] init];
   
    CGRect contentRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:contentRect parentVC:self childVCs:@[vc_1,vc_2,vc_3]];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
    
    return self.pageTitleView;
}



//present到发布朋友圈页面
- (void)jumpToPublishVC {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
    }
    DDWeakSelf;
    PublishFriendCircleVC *vc = [[PublishFriendCircleVC alloc] init];
    vc.publishComoletedBlock = ^{
        if ([weakself.delegate respondsToSelector:@selector(publishCompleted)]){
            [weakself.delegate publishCompleted];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

//跳转到我的个人信息页面
- (void)jumpToMyInfo {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.ofType = @"mine";
    [self.navigationController pushViewController:vc animated:YES];
}


//我的朋友圈tableViewg滚动监听
- (void)tableViewContentOffsetY:(CGFloat)offsetY {
    tableViewOffsetY = offsetY;
    if (offsetY > HiddenOffsetY) {
        _leftMyheaderImage.hidden = NO;
    } else {
        _leftMyheaderImage.hidden = YES;
    }
}

- (void)leftHeaderIconChange:(NSString *)headerUrl {
    if (headerUrl) {
        [_leftMyheaderImage sd_setImageWithURL:ImgUrl(headerUrl) placeholderImage:PlaceHolderImg];
    } else {
        _leftMyheaderImage.image = DefaultImage;
    }
}

#pragma mark pagetitle 代理方法

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
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
    if (targetIndex != 1 && progress == 1.0) {
        _leftMyheaderImage.hidden = YES;
    }
    //滚动到发现页面
    if (targetIndex == 1 && progress == 1.0) {
        if (tableViewOffsetY > HiddenOffsetY) {
             _leftMyheaderImage.hidden = NO;
        } else {
            _leftMyheaderImage.hidden = YES;
        }
    }
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}


@end
