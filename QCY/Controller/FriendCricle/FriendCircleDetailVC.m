//
//  FriendCircleDetailVC.m
//  QCY
//
//  Created by i7colors on 2018/12/11.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCircleDetailVC.h"
#import <YNPageViewController.h>
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import "FCDetailCommentVC.h"
#import "FCDetailZanVC.h"
#import "HelperTool.h"
#import "FriendCricleModel.h"
#import <UIImageView+WebCache.h>
#import "CommonNav.h"
#import "ClassTool.h"
#import "MacroHeader.h"
#import "CddHUD.h"
#import "NetWorkingPort.h"
#import "FriendCricleModel.h"
#import <Masonry.h>
#import "TimeAbout.h"
#import "WeiChatPhotoView.h"
#import <Masonry.h>
#import "WXKeyBoardView.h"
#import <WXApi.h>
#import <UIScrollView+EmptyDataSet.h>


@interface FriendCircleDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate,TVDelegate>
@property (nonatomic, strong)YNPageViewController *ynVC;
@property (nonatomic, strong)CommonNav *nav;
@property (nonatomic, strong)FriendCricleModel *headerDataSource;
@property (nonatomic, strong)WXKeyBoardView *kbView;
@property (nonatomic, assign)BOOL isCommentUser;    //是否是回复别人的评论
@property (nonatomic, copy)NSString *commentID;
@property (nonatomic, strong)UIButton *zanBtn;
@end

@implementation FriendCircleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    
    [self requestData];
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //添加监听 键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown) name:UIKeyboardDidHideNotification object:nil];
}

- (CommonNav *)nav {
    if (!_nav) {
        _nav = [[CommonNav alloc] init];
        _nav.backgroundColor = [UIColor whiteColor];
        _nav.titleLabel.text = @"详情";
        [_nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
            [_nav.rightBtn setTitle:@"分享" forState:UIControlStateNormal];
            [_nav.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_nav.rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return _nav;
}

- (void)setupBottomView {
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"fc_bottom_comment"] forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    commentBtn.adjustsImageWhenHighlighted = NO;
    commentBtn.tag = 1001;
    [self.view addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
    }];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 49);
    [ClassTool addLayer:commentBtn frame:rect];
    [commentBtn bringSubviewToFront:commentBtn.titleLabel];
    [commentBtn bringSubviewToFront:commentBtn.imageView];
    [commentBtn addTarget:self action:@selector(gotoComment) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    
    
    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [zanBtn setTitleColor:HEXColor(@"#3C3C3C", 1) forState:UIControlStateNormal];
    [zanBtn setImage:[UIImage imageNamed:@"fc_bottom_zan"] forState:UIControlStateNormal];
    [zanBtn setTitle:@"点赞" forState:UIControlStateNormal];
    zanBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    zanBtn.adjustsImageWhenHighlighted = NO;
    zanBtn.tag = 1002;
    [zanBtn addTarget:self action:@selector(giveYouZan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zanBtn];
    [zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.width.bottom.mas_equalTo(commentBtn);
    }];
    zanBtn.backgroundColor = RGBA(235, 235, 235, 1);
    zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    zanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    _zanBtn = zanBtn;
    
    UIView* bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - Bottom_Height_Dif, SCREEN_WIDTH, Bottom_Height_Dif)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    
    _kbView = [[WXKeyBoardView alloc] init];
    _kbView.top = SCREEN_HEIGHT;
    [self.view addSubview:_kbView];
}

- (void)gotoComment {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    _kbView.textView.placeholder = @"评论:";
    _isCommentUser = NO;
    _kbView.tvDelegate = self;
    [_kbView.textView becomeFirstResponder];
}

#pragma mark - 分享
- (void)share{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if isRightData(_headerDataSource.pic1) {
        [imageArray addObject:ImgStr(_headerDataSource.pic1)];
    } else {
        [imageArray addObject:Logo];
    }
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/friendCircle.html?id=%@",ShareString,_tieziID];
    [ClassTool shareSomething:imageArray urlStr:shareStr title:_headerDataSource.postUser text:_headerDataSource.content];
}

//监听点击return
- (void)clickReturn {
    [_kbView.textView resignFirstResponder];
    [self publishComments];
}

#pragma mark - 网络请求
- (void)requestData {
    DDWeakSelf;
    [CddHUD show:self.view];
    NSString *urlString = [NSString stringWithFormat:URL_FC_Detail,_tieziID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.headerDataSource = [FriendCricleModel mj_objectWithKeyValues:json[@"data"]];
            [weakself setupPageVC];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

/*** 发表评论 ***/
- (void)publishComments {

    if (_kbView.textView.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入您要发表的内容" view:self.view];
        return;
    }

    NSString *commentID = [NSString string];
    if (_isCommentUser == YES) {
        commentID = _commentID;;
    } else {
        commentID = @"";
    }

    NSDictionary *dict = @{@"token":User_Token,
                           @"dyeId":_tieziID,
                           @"content":_kbView.textView.text,
                           @"parentId":commentID
                           };
    [CddHUD show:self.view];
    DDWeakSelf;
    [ClassTool postRequest:URL_Publish_Comments Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//            CommentListModel *dict = [CommentListModel mj_objectWithKeyValues:json[@"data"]];
//            NSDictionary *userInfo = @{@"oneComment":dict};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"commentChange" object:@"add" userInfo:nil];
        }
    } Failure:^(NSError *error) {

    }];
}

//点赞
- (void)giveYouZan {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    NSDictionary *dict = @{@"token":User_Token,
                           @"dyeId":_tieziID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Click_Zan Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //
//        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"zanChange" object:nil userInfo:nil];
            [weakself.zanBtn setTitle:@"已赞" forState:UIControlStateNormal];
            weakself.zanBtn.userInteractionEnabled = NO;
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)setupPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    //    /// 控制tabbar 和 nav
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = YES;
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
    configration.normalItemColor = [UIColor blackColor];
    configration.selectedItemColor = MainColor;
    configration.lineColor = MainColor;
    configration.itemFont = [UIFont systemFontOfSize:15];
    configration.selectedItemFont = [UIFont boldSystemFontOfSize:15];
    configration.showBottomLine = YES;
    configration.bottomLineHeight = 0.6;

    //    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.bottomLineBgColor = HEXColor(@"#D3D3D3", 0.6);
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = NAV_HEIGHT;
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    //header
    FCDetailHeaderView *header = [[FCDetailHeaderView alloc] init];
    header.headerModel = _headerDataSource;
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, header.bottom);
    
    vc.headerView = header;
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    [_nav removeFromSuperview];
    [self.view addSubview:self.nav];
    [self setupBottomView];
    /// 如果隐藏了导航条可以 适当改y值
    //    pageVC.view.yn_y = kYNPAGE_NAVHEIGHT;
//    vc.view.height = NAV_HEIGHT;
}


- (NSArray *)getArrayVCs {
    
    FCDetailCommentVC *vc_1 = [[FCDetailCommentVC alloc] init];
    vc_1.tieziID = _tieziID;
    DDWeakSelf;
    vc_1.clickCellPLBlock = ^(NSString *commentID, NSString *isSelf, NSString *user) {
        if ([isSelf isEqualToString:@"0"]) {
            weakself.commentID = commentID;
            weakself.kbView.textView.placeholder = [NSString stringWithFormat:@"回复%@:",user];
            weakself.isCommentUser = YES;
            weakself.kbView.tvDelegate = self;
            [weakself.kbView.textView becomeFirstResponder];
        }
    };
    FCDetailZanVC *vc_2 = [[FCDetailZanVC alloc] init];
    vc_2.tieziID = _tieziID;
    
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    return @[@"评论", @"点赞"];
}

#pragma mark - 代理方法
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[FCDetailCommentVC class]]) {
        return [(FCDetailCommentVC *)vc tableView];
    } else {
        return [(FCDetailZanVC *)vc tableView];
    }
    
}

//滚动监听
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //    NSLog(@"--- contentOffset = %f, progress = %f", contentOffset, progress);
}

#pragma mark -键盘监听方法
- (void)keyBoardWillShow:(NSNotification *)notification
{
    //     获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.kbView.transform = CGAffineTransformMakeTranslation(0, -(keyBoardHeight + self.kbView.height));
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    //    NSLog(@"---- %f",keyBoardHeight + self.kbView.height);
}

- (void)keyBoardWillHide:(NSNotification *)notificaiton
{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notificaiton.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.kbView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

//键盘消失
- (void)keyboardDown {
    _kbView.textView.text = @"";
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


/******************************************* 自定义的headerView *******************************************/

@interface FCDetailHeaderView()
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UIImageView *levelImage;
// 正文
@property (nonatomic, strong) UILabel *mainLabel;
// 名称
@property (nonatomic, strong) UILabel *nickNameLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
// 图片九宫格
@property (nonatomic, strong) WeiChatPhotoView *photoGroup;
@end

@implementation FCDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //头像
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.frame = CGRectMake(10, 5 + NAV_HEIGHT, 55, 55);
    [HelperTool setRound:headerImage corner:UIRectCornerAllCorners radiu:55 / 2];
    [self addSubview:headerImage];
    _headerImage = headerImage;
    
    //昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.frame = CGRectMake(headerImage.right + 10, headerImage.top + 5, 0, 20);
    nickNameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    nickNameLabel.textColor = HEXColor(@"#ED3851", 1);
    nickNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nickNameLabel];
    _nickNameLabel = nickNameLabel;
    //等级图标
    UIImageView *levelImage = [[UIImageView alloc] init];
    levelImage.frame = CGRectMake(0, nickNameLabel.top, 20, 20);
    levelImage.contentMode =  UIViewContentModeCenter;
    [self addSubview:levelImage];
    _levelImage = levelImage;
    
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLabel.frame = CGRectMake(_nickNameLabel.left, _nickNameLabel.bottom + 10, SCREEN_WIDTH - _nickNameLabel.left - 30, 15);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:_timeLabel];
    // 正文视图
    _mainLabel = [[UILabel alloc] init];;
    _mainLabel.font = [UIFont systemFontOfSize:15.0];
    _mainLabel.numberOfLines = 0;
    _mainLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _mainLabel.hidden = YES;
    [self addSubview:_mainLabel];
    // 图片九宫格
    _photoGroup = [[WeiChatPhotoView alloc] initWithFrame:CGRectZero];
    [self addSubview:_photoGroup];
}

- (void)setHeaderModel:(FriendCricleModel *)headerModel {
    _headerModel = headerModel;
    //头像
    if isRightData(headerModel.postUserPhoto) {
        [_headerImage sd_setImageWithURL:ImgUrl(headerModel.postUserPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImage.image = DefaultImage;
    }
    //昵称
    if isRightData(headerModel.postUser) {
        _nickNameLabel.text = headerModel.postUser;
        CGFloat nameWidth = [headerModel.postUser boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - _nickNameLabel.left - 25, 20)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_nickNameLabel.font}
                                                          context:nil].size.width;
        _nickNameLabel.width = nameWidth;
    }
    
    //等级图标
    NSString *imageStr = [NSString string];
    if ([headerModel.bossLevel isEqualToString:@"1"]) {
        imageStr = @"level_1";
    } else if ([headerModel.bossLevel isEqualToString:@"2"]) {
        imageStr = @"level_2";
    } else if ([headerModel.bossLevel isEqualToString:@"3"]) {
        imageStr = @"level_3";
    } else {
        imageStr = @" ";
    }
    _levelImage.image = [UIImage imageNamed:imageStr];
    _levelImage.left = _nickNameLabel.right + 2;
    
    //时间
    _timeLabel.text = [TimeAbout timestampToString:[headerModel.createdAtStamp longLongValue]];
    
    _bottom = _headerImage.bottom + 15;
    //正文
    if isRightData(headerModel.content) {
        _mainLabel.text = headerModel.content;
        CGFloat mHeight = [headerModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20 * 2, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}
                                                                  context:nil].size.height;
        _mainLabel.frame = CGRectMake(20, _bottom, SCREEN_WIDTH - 40, mHeight);
        _mainLabel.hidden = NO;
        _bottom = _mainLabel.bottom + 15;
    } else {
        _mainLabel.hidden = YES;
        _mainLabel.frame = CGRectMake(20, _bottom, SCREEN_WIDTH - 40, 0);
    }
    
    //9个图片
    NSMutableArray *imgArr = [self addPic:headerModel];
    _photoGroup.videoURL = [NSString stringWithFormat:@"%@%@",Photo_URL,headerModel.url];
    _photoGroup.videoPicWidth = headerModel.videoPicWidth;
    _photoGroup.videoPicHight = headerModel.videoPicHigh;
    _photoGroup.pic1Width = headerModel.pic1Width;
    _photoGroup.pic1Hight = headerModel.pic1High;
    _photoGroup.type = headerModel.type;
    //放在最后
    _photoGroup.urlArray = imgArr;
    if (imgArr.count > 0) {
        _photoGroup.hidden = NO;
        _photoGroup.origin = CGPointMake(_mainLabel.left, _bottom);
        _bottom = _photoGroup.bottom + 25;
    } else {
        _photoGroup.hidden = YES;
        _bottom = _mainLabel.bottom + 25;
    }
}

//添加图片.......
- (NSMutableArray *)addPic:(FriendCricleModel *)model {
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
    if ([model.type isEqualToString:@"photo"]) {
        if isRightData(model.pic1) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic1]];
        }
        if isRightData(model.pic2) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic2]];
        }
        if isRightData(model.pic3) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic3]];
        }
        if isRightData(model.pic4) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic4]];
        }
        if isRightData(model.pic5) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic5]];
        }
        if isRightData(model.pic6) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic6]];
        }
        if isRightData(model.pic7) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic7]];
        }
        if isRightData(model.pic8) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic8]];
        }
        if isRightData(model.pic9) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic9]];
        }
    } else {
        if isRightData(model.videoPicUrl) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.videoPicUrl]];
        }
    }
    
    return imgArr;
}

@end
