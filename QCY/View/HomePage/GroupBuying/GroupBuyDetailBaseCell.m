//
//  GroupBuyDetailBaseCell.m
//  QCY
//
//  Created by i7colors on 2018/11/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyDetailBaseCell.h"
#import "MacroHeader.h"
#import <Masonry.h>

@implementation GroupBuyDetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(13));
        make.right.mas_equalTo(KFit_W(-13));
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    
    
}

@end
