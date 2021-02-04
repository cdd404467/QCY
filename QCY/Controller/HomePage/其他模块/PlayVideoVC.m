//
//  PlayVideoVC.m
//  QCY
//
//  Created by i7colors on 2020/4/14.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PlayVideoVC.h"
#import <SJVideoPlayer.h>
#import <UIImageView+WebCache.h>
#import <SJUIKit/NSAttributedString+SJMake.h>

@interface PlayVideoVC ()
@property (nonatomic, strong) SJVideoPlayer *player;
@end

@implementation PlayVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self vhl_setNavBarTitleColor:UIColor.clearColor];
    [self vhl_setNavBarBackgroundAlpha:0.0];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarHidden:YES];
    [self setupUI];
}


- (void)setupUI {
    
    _player = [SJVideoPlayer player];
    [self.view addSubview:_player.view];
    NSString *videoUrl = [NSString stringWithFormat:@"%@%@",Photo_URL,_dataSource.videoUrl];
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrl]];
    DDWeakSelf;
    asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(weakself.dataSource.title);
        make.textColor(UIColor.whiteColor);
    }];
    _player.URLAsset = asset;
    NSString *picture = [NSString string];
    if (isRightData(_dataSource.videoLdUrl)) {
        picture = _dataSource.videoLdUrl;
    } else {
        picture = _dataSource.videoHdUrl;
    }
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
