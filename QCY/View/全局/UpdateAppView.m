//
//  UpdateAppView.m
//  DSXS
//
//  Created by 李明哲 on 2018/7/16.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import "UpdateAppView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "UIView+Geometry.h"

@interface UpdateAppView()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation UpdateAppView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setupUIWithText:(NSString *)text isMustUpdate:(NSString *)updateType {
    DDWeakSelf;
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    self.frame = SCREEN_BOUNDS;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.6);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [[UIImage imageNamed:@"update_app_img"] stretchableImageWithLeftCapWidth:0 topCapHeight:100];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    CGFloat imageWidth = KFit_W(280);
    CGFloat imageHeight = KFit_W(350);
    imageView.frame = CGRectMake( (SCREEN_WIDTH - imageWidth) / 2 , SCREEN_HEIGHT + imageHeight, imageWidth, imageHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.center = weakself.center;
    }];
    
    if ([updateType isEqualToString:@"0"]) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.backgroundColor = [UIColor redColor];
        [closeBtn setImage:[UIImage imageNamed:@"close_update"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(removeSignView) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发现新版本!";
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(25);
    }];
    
    [imageView addSubview:self.scrollView];
    _scrollView.width = imageWidth - _scrollView.left * 2;
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"V %@ 更新内容",_version];
    versionLabel.textColor = [UIColor blackColor];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.frame = CGRectMake(0, 0, _scrollView.width, 35);
    [self.scrollView addSubview:versionLabel];
    
    
    UILabel *updateText = [[UILabel alloc]init];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attText length])];
    updateText.attributedText = attText;
    updateText.lineBreakMode = NSLineBreakByWordWrapping;
    updateText.numberOfLines = 0;
    updateText.textColor = RGBA(51, 51, 51, 1);
    updateText.font = [UIFont systemFontOfSize:12];
    
    [self.scrollView addSubview:updateText];
   
    CGSize size = [updateText sizeThatFits:CGSizeMake(_scrollView.width, MAXFLOAT)];
    
    [updateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakself.scrollView.width - KFit_W(16));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(35);
        make.height.mas_equalTo(@(size.height));
    }];
    self.scrollView.contentSize = CGSizeMake(_scrollView.width, size.height + 35 + 10);
    
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    updateBtn.backgroundColor = MainColor;
    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateBtn.layer.cornerRadius = 20;
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [imageView addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-20);
    }];
    [updateBtn addTarget:self action:@selector(checkVersionUpdata) forControlEvents:UIControlEventTouchUpInside];
//    updateBtn.layer.shadowColor = RGBA(170, 172, 174, 1).CGColor;
//    updateBtn.layer.shadowOffset = CGSizeMake(4,-5);
//    updateBtn.layer.shadowOpacity = 1.0f;
//    updateBtn.layer.shadowRadius = 4.f;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(KFit_W(23), KFit_W(90), KFit_W(225), KFit_W(195))];
        _scrollView.backgroundColor = [UIColor whiteColor];
        //是否可以滚动
        _scrollView.scrollEnabled = YES;
        //禁止水平滚动
        _scrollView.alwaysBounceHorizontal = NO;
        //允许垂直滚动
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
//        _scrollView.backgroundColor = [UIColor blueColor];
    }
    return _scrollView;
}

- (void)checkVersionUpdata {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateUrl]];
}

//移除视图
- (void)removeSignView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

@end
