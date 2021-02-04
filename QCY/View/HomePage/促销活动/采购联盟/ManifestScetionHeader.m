//
//  ManifestScetionHeader.m
//  QCY
//
//  Created by i7colors on 2019/1/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ManifestScetionHeader.h"
#import "PrchaseLeagueModel.h"
#import "UIView+Border.h"

@implementation ManifestScetionHeader {
    UILabel *_nameLabel;
    UIButton *_rightBtn;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *topGap = [[UIView alloc] init];
    topGap.backgroundColor = HEXColor(@"#EDEDED", 1);
    topGap.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    [self addSubview:topGap];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.frame = CGRectMake(40, 10, SCREEN_WIDTH - 80, 30);
    [self addSubview:nameLabel];
    [nameLabel addBorderView:LineColor width:0.5f direction:BorderDirectionRight];
    _nameLabel = nameLabel;
    
    //右侧展开收缩按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(nameLabel.right, nameLabel.top, 40, nameLabel.height);
    [rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:rightBtn];
    _rightBtn = rightBtn;
//    [_rightBtn addBorderView:LineColor width:0.5f direction:BorderDirectionBottom];
}


- (void)setModel:(PrchaseLeagueModel *)model {
    _model = model;
    
    _nameLabel.text = model.meetingName;

    UIImage *image = model.isOpen ? [UIImage imageNamed:@"cg_top"] : [UIImage imageNamed:@"cg_bottom"];
    [_rightBtn setImage:image forState:UIControlStateNormal];
}


- (void)btnClick {
    if (self.rightBtnClick) {
        _model.isOpen = !_model.isOpen;
        self.rightBtnClick(_model.isOpen);
    }
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ManifestScetionHeader";
    // 1.缓存中取
    ManifestScetionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[ManifestScetionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}

@end
