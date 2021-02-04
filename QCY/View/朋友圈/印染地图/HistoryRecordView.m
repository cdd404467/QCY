//
//  HistoryRecordView.m
//  QCY
//
//  Created by i7colors on 2019/7/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HistoryRecordView.h"



static const CGFloat leftGap = 20;
static const CGFloat topGap = 15;

@interface HistoryRecordView()
//按钮数组
@property (nonatomic, strong) NSMutableArray *buttonsArray;
//label
@property (nonatomic, strong) UILabel *historyLab;
@end

@implementation HistoryRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _historyLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 20)];
    _historyLab.font = [UIFont systemFontOfSize:15];
    _historyLab.textColor = RGBA(0, 0, 0, 0.7);
    _historyLab.text = @"历史选择";
    [self addSubview:_historyLab];
    
    _buttonsArray = [NSMutableArray arrayWithCapacity:0];
    CGFloat width = (SCREEN_WIDTH - leftGap * 4) / 3;
    CGFloat height = 35;
    for (NSInteger i = 0; i < 6; i++) {
        HistoryButton *button = [HistoryButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width, height);
        button.backgroundColor = HEXColor(@"#ededed", .5);
        button.layer.cornerRadius = 4.f;
        button.hidden = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonsArray addObject:button];
        [self addSubview:button];
    }
}

- (void)clickBtn:(HistoryButton *)sender {
    if (self.historyBtnClickBlock) {
        self.historyBtnClickBlock(sender.titleLabel.text, sender.type);
    }
}

- (void)setHistroyArr:(NSArray<NSString *> *)histroyArr {
    _histroyArr = histroyArr;
    for (HistoryButton *button in _buttonsArray) {
        button.hidden = YES;
    }
    
    NSInteger count = histroyArr.count;
    HistoryButton *button = nil;
    CGFloat width = (SCREEN_WIDTH - leftGap * 4) / 3;
    CGFloat height = 35;
    for (NSInteger i = 0; i < count; i ++) {
        if (i > 5) break;
        NSInteger currentLine = i / 3;
        NSInteger currentGapNum = i % 3;
        CGFloat btnX = leftGap + (leftGap + width) * currentGapNum;
        CGFloat btnY = _historyLab.bottom + topGap + currentLine * (topGap + height);
        button = _buttonsArray[i];
        button.hidden = NO;
        button.left = btnX;
        button.top = btnY;
        NSArray *arr = [(NSString *)histroyArr[i] componentsSeparatedByString:@"-"];
        if (arr.count > 1) {
            [button setTitle:arr[0] forState:UIControlStateNormal];
            button.type = [(NSString *)arr[1] integerValue];
        }
    }
    self.height = button.bottom + 15;
}

@end

@implementation HistoryButton


@end
