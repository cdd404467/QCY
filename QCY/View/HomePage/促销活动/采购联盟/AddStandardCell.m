//
//  AddStandardCell.m
//  QCY
//
//  Created by i7colors on 2019/3/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AddStandardCell.h"
#import "HelperTool.h"

@interface AddStandardCell()
@property (nonatomic, strong)UILabel *textLab;
@end

@implementation AddStandardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.blueColor;
    bgView.layer.borderWidth = 1.f;
    bgView.layer.borderColor = HEXColor(@"#E8E8E8", 1).CGColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(32);
    }];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.numberOfLines = 1;
    textLab.backgroundColor = [UIColor whiteColor];
    textLab.textColor = HEXColor(@"#3C3C3C", 1);
    [bgView addSubview:textLab];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-32);
    }];
    _textLab = textLab;

    //删除图标
    UIButton *jianbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jianbtn.userInteractionEnabled = YES;
    [jianbtn setImage:[UIImage imageNamed:@"cg_jian"] forState:UIControlStateNormal];
    [jianbtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:jianbtn];
    [jianbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView);
        make.right.mas_equalTo(bgView.mas_right).offset(0);
        make.width.height.mas_equalTo(32);
    }];
}

- (void)setItemTitle:(NSString *)itemTitle {
    _itemTitle = itemTitle;
    _textLab.text = itemTitle;
}

- (void)btnClick {
    if (self.jianBtnClick) {
        self.jianBtnClick(_itemTitle);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AddStandardCell";
    AddStandardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddStandardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
