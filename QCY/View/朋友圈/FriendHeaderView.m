//
//  FriendHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/11/26.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendHeaderView.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"

@implementation FriendHeaderView {
    UIImageView *_typeImage;
    UILabel *_typeLabel;
    UIImageView *_headerImage;
    UILabel *_nickName;
    UILabel *_rzLabel;
    UIImageView *_bigVImage;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
//    UIView *topGap = [[UIView alloc] init];
//    topGap.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
//    topGap.backgroundColor = HEXColor(@"#D3D3D3", 0.6);
//    [self addSubview:topGap];
    
    UIView *botGap = [[UIView alloc] init];
    botGap.frame = CGRectMake(0, 50, SCREEN_WIDTH, 6);
    botGap.backgroundColor = HEXColor(@"#D3D3D3", 0.6);
    [self addSubview:botGap];
    
    // 头像
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.layer.cornerRadius = 25;
    headerImage.clipsToBounds = YES;
    [self addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
        make.right.mas_equalTo(KFit_W(-19));
        make.width.mas_equalTo(50);
    }];
    _headerImage = headerImage;
    
    UIImageView *bigVImage = [[UIImageView alloc] init];
    bigVImage.layer.cornerRadius = 9;
    bigVImage.clipsToBounds = YES;
    bigVImage.image = [UIImage imageNamed:@"bigV_img"];
    bigVImage.hidden = YES;
    [self addSubview:bigVImage];
    [bigVImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.right.bottom.mas_equalTo(headerImage);
    }];
    _bigVImage = bigVImage;
    
    //名字
    UILabel *nickName = [[UILabel alloc] init];
    nickName.textColor = [UIColor blackColor];
    nickName.textAlignment = NSTextAlignmentRight;
    nickName.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerImage.mas_left).offset(-12);
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(7);
    }];
    _nickName = nickName;
    
    //是否认证
    UILabel *rzLabel = [[UILabel alloc] init];
    rzLabel.font = [UIFont systemFontOfSize:12];
    rzLabel.textColor = HEXColor(@"#686D74", 1);
    [self addSubview:rzLabel];
    [rzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nickName);
        make.bottom.mas_equalTo(-12);
    }];
    _rzLabel = rzLabel;
    
    //未登录时显示的label
    UILabel *noLoginLabel = [[UILabel alloc] init];
    noLoginLabel.backgroundColor = [UIColor whiteColor];
    noLoginLabel.textAlignment = NSTextAlignmentCenter;
    noLoginLabel.textColor = [UIColor blackColor];
    noLoginLabel.hidden = YES;
    noLoginLabel.font = [UIFont systemFontOfSize:16];
    noLoginLabel.text = @"你还没有登录";
    [self addSubview:noLoginLabel];
    [noLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _noLoginLabel = noLoginLabel;
}

- (void)setModel:(FriendCricleInfoModel *)model {
    _model = model;
    
    //朋友圈头像
    if isRightData(model.communityPhoto) {
        [_headerImage sd_setImageWithURL:ImgUrl(model.communityPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImage.image = DefaultImage;
    }
    
    //昵称
    _nickName.text = model.nickName;
    
    //是否认证
    NSString *certStr = [NSString string];
    if ([model.isCompanyType isEqualToString:@"1"]) {
        certStr = @"已认证";
        _bigVImage.hidden = NO;
    } else {
        if ([model.isDyeV isEqualToString:@"-1"]) {
            certStr = @"未认证";
            _bigVImage.hidden = YES;
        } else if ([model.isDyeV isEqualToString:@"0"]) {
            certStr = @"认证失败";
            _bigVImage.hidden = YES;
        } else if ([model.isDyeV isEqualToString:@"1"]) {
            certStr = @"已认证";
            _bigVImage.hidden = NO;
        } else if ([model.isDyeV isEqualToString:@"2"]) {
            certStr = @"审核中";
            _bigVImage.hidden = YES;
        }
    }
    _rzLabel.text = certStr;
}



@end
