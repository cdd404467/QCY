//
//  WXKeyBoardView.m
//  QCY
//
//  Created by i7colors on 2018/11/30.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "WXKeyBoardView.h"


@interface WXKeyBoardView()<UITextViewDelegate>


@end

@implementation WXKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        self.backgroundColor = HEXColor(@"#fafafa", 1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = RGBA(204, 204, 204, 1);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.returnKeyType = UIReturnKeySend;
    //没文字时return不可点击
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius = 4;
    _textView.layer.borderWidth = 0.6f;
    _textView.layer.borderColor = HEXColor(@"#e0e0e0", 1).CGColor;
    _textView.delegate = self;
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(topLine.mas_bottom).offset(9);
        make.bottom.mas_equalTo(-9);
//        make.right.mas_equalTo(-100);
        make.right.mas_equalTo(-20);
    }];
    
    //    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _submitBtn.layer.cornerRadius = 4;
    //    _submitBtn.clipsToBounds = YES;
    //    _submitBtn.enabled = NO;
    //    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_submitBtn setTitleColor:RGBA(0, 0, 0, 0.3) forState:UIControlStateDisabled];
    //    [_submitBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#297cf6", 1)] forState:UIControlStateNormal];
    //    [_submitBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#acb1b9", 0.8)] forState:UIControlStateDisabled];
    //    [_submitBtn setTitle:@"发送" forState:UIControlStateNormal];
    //    [self addSubview:_submitBtn];
    //    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.bottom.mas_equalTo(self.textView);
    //        make.right.mas_equalTo(-20);
    //        make.left.mas_equalTo(self.textView.mas_right).offset(20);
    //    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.tvDelegate respondsToSelector:@selector(clickReturn)]) {
            [self.tvDelegate clickReturn];
        }
        return NO;  //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
