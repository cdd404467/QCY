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

@implementation FriendHeaderView {
    UIImageView *_typeImage;
    UIImageView *_headerImage;
    UILabel *_nameLabel;
    UILabel *_rzLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 62);
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *topGap = [[UIView alloc] init];
    topGap.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    topGap.backgroundColor = HEXColor(@"#D3D3D3", 0.6);
    [self addSubview:topGap];
    
    UIView *botGap = [[UIView alloc] init];
    botGap.frame = CGRectMake(0, 56, SCREEN_WIDTH, 6);
    botGap.backgroundColor = HEXColor(@"#D3D3D3", 0.6);
    [self addSubview:botGap];
    
    //账号类型
    UIImageView *typeImage = [[UIImageView alloc] init];
    [self addSubview:typeImage];
    [typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(KFit_W(60));
        make.top.mas_equalTo(6);
    }];
    _typeImage = typeImage;
    // 头像
    UIImageView *headerImage = [[UIImageView alloc] init];
    [self addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(6);
        make.bottom.offset(-6);
        make.right.mas_equalTo(KFit_W(-19));
        make.width.mas_equalTo(50);
    }];
    _headerImage = headerImage;
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerImage.mas_left).offset(12);
        make.top.mas_equalTo(15);
    }];
    _nameLabel = nameLabel;
    
    //是否认证
    UILabel *rzLabel = [[UILabel alloc] init];
    rzLabel.font = [UIFont systemFontOfSize:12];
    rzLabel.textColor = HEXColor(@"#333333", 1);
    [self addSubview:rzLabel];
    [rzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nameLabel);
        make.bottom.mas_equalTo(-16);
    }];
    _rzLabel = rzLabel;
}




@end
