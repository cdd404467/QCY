//
//  ContestantsCell.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ContestantsCell.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import "HelperTool.h"
#import "VoteModel.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import <YYText.h>
#import "ClassTool.h"
#import "HelperTool.h"

@interface ContestantsCell()
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UIImageView *medalImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *desLabel;
@property (nonatomic, strong)YYLabel *voteNumLab;
@property (nonatomic, strong)UILabel *numberLab;
@property (nonatomic, strong)UIButton *voteBtn;
@property (nonatomic, strong)UILabel *rankLab;
@end

@implementation ContestantsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(@"#f3f3f3", 1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.frame = CGRectMake(9, 10, SCREEN_WIDTH - 9 * 2, 135);
    cellView.layer.cornerRadius = 10.f;
    [self.contentView addSubview:cellView];
    
    //头像
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(5, 9, 90, 90);
    [cellView addSubview:headerImageView];
    [HelperTool setRound:headerImageView corner:UIRectCornerAllCorners radiu:10.f];
    _headerImageView = headerImageView;
    
    CGFloat labWidth = cellView.width - headerImageView.right - 10 * 2;
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(headerImageView.right + 10, headerImageView.top, labWidth, 14);
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.numberOfLines = 2;
    [cellView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    //描述
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 3, nameLabel.width, 30);
    desLabel.font = [UIFont systemFontOfSize:12];
    desLabel.textColor = HEXColor(@"#868686", 1);
    desLabel.numberOfLines = 2;
    [cellView addSubview:desLabel];
    _desLabel = desLabel;
    
    //投票数
    YYLabel *voteNumLab = [[YYLabel alloc] init];
    [cellView addSubview:voteNumLab];
    [voteNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.left);
        make.bottom.mas_equalTo(headerImageView.mas_bottom).offset(3);
        make.width.mas_equalTo(nameLabel.width / 2 + 10);
    }];
    _voteNumLab = voteNumLab;
    
    //编号
//    UILabel *numberLab = [[UILabel alloc] init];
//    numberLab.font = [UIFont systemFontOfSize:14];
//    numberLab.textColor = HEXColor(@"#868686", 1);
//    numberLab.textAlignment = NSTextAlignmentRight;
//    [cellView addSubview:numberLab];
//    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(nameLabel);
//        make.bottom.mas_equalTo(voteNumLab);
//        make.left.mas_equalTo(voteNumLab.mas_right).offset(5);
//    }];
//    _numberLab = numberLab;
    
    //奖牌
    UIImageView *medalImageView = [[UIImageView alloc] init];
//    medalImageView.frame = CGRectMake(0, 0, 28, 36);
    medalImageView.hidden = YES;
    [self.contentView addSubview:medalImageView];
    [medalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nameLabel);
        make.bottom.mas_equalTo(voteNumLab);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(36);
    }];
    _medalImageView = medalImageView;
    
    //没奖牌的给排名
    UILabel *rankLab = [[UILabel alloc] init];
    rankLab.font = [UIFont italicSystemFontOfSize:40];
    rankLab.textAlignment = NSTextAlignmentRight;
    rankLab.textColor = HEXColor(@"#DAA520", 1);
//    rankLab.frame = CGRectMake(0, 0, headerImageView.width, 36);
    rankLab.hidden = YES;
    [cellView addSubview:rankLab];
    [rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nameLabel);
        make.bottom.mas_equalTo(voteNumLab);
        make.height.mas_equalTo(36);
    }];
    _rankLab = rankLab;
    
    //投票按钮
    UIButton *voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voteBtn.frame = CGRectMake(0, 105, cellView.width, 30);
    [voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [voteBtn addTarget:self action:@selector(voteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:voteBtn];
    [ClassTool addLayer:voteBtn frame:CGRectMake(0, 0, voteBtn.width, voteBtn.height)];
    [HelperTool setRound:voteBtn corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:10.f];
    _voteBtn = voteBtn;
}

- (void)setModel:(VoteUserModel *)model {
    _model = model;
    
    [_headerImageView sd_setImageWithURL:ImgUrl(model.pic) placeholderImage:PlaceHolderImg];
    
    CGFloat labHeight = [model.name boundingRectWithSize:CGSizeMake(_nameLabel.width, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:_nameLabel.font}
                                                     context:nil].size.height;
    if (labHeight > 40)
        labHeight = 34;
    _nameLabel.height = labHeight;
    _nameLabel.text = model.name;
    //描述
    _desLabel.text = model.descriptionStr;
    _desLabel.top = _nameLabel.bottom + 3;
    
    //投票数
    NSString *text = [NSString stringWithFormat:@"%@票",model.ticketNum];
    NSMutableAttributedString *mutableText= [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_color = HEXColor(@"#868686", 1);
    mutableText.yy_font = [UIFont systemFontOfSize:14];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, model.ticketNum.length)];
    [mutableText yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(0, model.ticketNum.length)];
    _voteNumLab.attributedText = mutableText;
    
    //编号
//    _numberLab.text = [NSString stringWithFormat:@"编号:%@",model.number];
    
    //排名
    if ([model.sort isEqualToString:@"1"]) {
        _medalImageView.hidden = NO;
        _rankLab.hidden = YES;
        _medalImageView.image = [UIImage imageNamed:@"tp_number1"];
    } else if ([model.sort isEqualToString:@"2"]) {
        _medalImageView.hidden = NO;
        _rankLab.hidden = YES;
        _medalImageView.image = [UIImage imageNamed:@"tp_number2"];
    } else if ([model.sort isEqualToString:@"3"]) {
        _medalImageView.hidden = NO;
        _rankLab.hidden = YES;
        _medalImageView.image = [UIImage imageNamed:@"tp_number3"];
    } else {
        _rankLab.hidden = NO;
        _medalImageView.hidden = YES;
        _rankLab.text = model.sort;
    }
    
    //已投票数，如果是0，显示投票按钮
    if ([model.joinedTicketNum isEqualToString:@"0"]) {
        [_voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    } else {
        [_voteBtn setTitle:[NSString stringWithFormat:@"已投%@票",model.joinedTicketNum ] forState:UIControlStateNormal];
    }
}


- (void)voteBtnClick {
    if (self.voteClickBlock) {
        self.voteClickBlock(_model.voteUserID);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ContestantsCell";
    ContestantsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ContestantsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
