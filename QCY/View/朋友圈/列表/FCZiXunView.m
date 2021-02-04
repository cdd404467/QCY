//
//  FCZiXunView.m
//  QCY
//
//  Created by i7colors on 2019/4/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCZiXunView.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"

@implementation FCZiXunView {
    UIImageView *_imageView;
    UILabel *_titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5);
        make.width.height.mas_equalTo(40);
    }];
    _imageView = imageView;
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.numberOfLines = 0;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(5);
        make.top.bottom.right.mas_equalTo(0);
    }];
    _titleLab = titleLab;
}

- (void)setModel:(ShareBeanModel *)model {
    _model = model;
    [_imageView sd_setImageWithURL:ImgUrl(model.pic) placeholderImage:PlaceHolderImg];
    _titleLab.text = model.title;
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = HEXColor(@"#cdd2df", 1);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC));
    DDWeakSelf;
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.backgroundColor = HEXColor(@"#f3f3f3", 1);
        if (weakself.clickZiXunViewBlock) {
            weakself.clickZiXunViewBlock();
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = HEXColor(@"#f3f3f3", 1);
}

@end
