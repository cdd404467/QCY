//
//  StandardView.m
//  QCY
//
//  Created by i7colors on 2019/1/24.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "StandardView.h"

@interface StandardView()

@property (nonatomic, strong)NSMutableArray *labelArray;

@end

#define Max_Count 14

@implementation StandardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithCount:Max_Count];
    }

    return self;
}

- (void)setupUIWithCount:(NSInteger)count {
    _labelArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < count; i ++) {
        UILabel *standardLabel = [[UILabel alloc] init];
        standardLabel.layer.borderWidth = 1.f;
        standardLabel.frame = CGRectZero;
        standardLabel.layer.cornerRadius = 4.f;
        standardLabel.hidden = YES;
        standardLabel.font = [UIFont systemFontOfSize:13];
        standardLabel.textAlignment = NSTextAlignmentCenter;
        [_labelArray addObject:standardLabel];
        [self addSubview:standardLabel];
    }
}

- (void)setNameArr:(NSArray<NSString *> *)nameArr {
    _nameArr = nameArr;
    //重置一下label的显示状态，不然数据复用会导致显示不正常
    for (UILabel *lab in _labelArray) {
        lab.hidden = YES;
    }
    CGFloat leftGap = 12;
    CGFloat centerGap = 15;
    CGFloat topGap = 7;
    CGFloat width = (SCREEN_WIDTH - leftGap * 2 - centerGap) / 2;
    CGFloat height = 25;
    UILabel *label = nil;
    NSArray<UIColor *> * baseColorArr = [NSArray arrayWithObjects:HEXColor(@"#ED3851", 1), HEXColor(@"#FF721F", 1), HEXColor(@"#FF721F", 1), HEXColor(@"#4f74ff", 1),nil];
    NSInteger realCount = nameArr.count;
    if (nameArr.count > Max_Count)
        realCount = Max_Count;
    for (NSInteger i = 0; i < realCount; i ++) {
        //每行个数
        NSInteger colNum = i % 2;
        //行数
        NSInteger rowNum = i / 2;

        CGFloat labelX = leftGap + colNum * (width + centerGap);
        CGFloat labelY = rowNum * (height + topGap);
        CGRect frame = CGRectMake(labelX, labelY, width, height);
        NSInteger colorNum = i % baseColorArr.count;

        label = _labelArray[i];
        label.frame = frame;
        label.hidden = NO;
        UIColor *color = baseColorArr[colorNum];
        label.layer.borderColor = color.CGColor;
        label.textColor = color;
        label.text = nameArr[i];
    }
    self.height = label.bottom;
}

@end
