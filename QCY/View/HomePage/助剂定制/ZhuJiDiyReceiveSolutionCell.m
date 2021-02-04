//
//  ZhuJiDiyReceiveSolutionCell.m
//  QCY
//
//  Created by i7colors on 2019/8/9.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyReceiveSolutionCell.h"
#import "HelperTool.h"
#import "ZhuJiDiyModel.h"

const static CGFloat gap = 15.f;

@interface ZhuJiDiyReceiveSolutionCell()
@property (nonatomic, copy) NSString *jumpFrom;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *companyNameLab;
@property (nonatomic, strong) UILabel *productLeftLab;
@property (nonatomic, strong) UILabel *productRightLab;
@property (nonatomic, strong) UILabel *demoLeftLab;
@property (nonatomic, strong) UILabel *demoRightLab;
@property (nonatomic, strong) UILabel *desLeftLab;
@property (nonatomic, strong) UILabel *desRightLab;
@property (nonatomic, strong) UILabel *timeLeftLab;
@property (nonatomic, strong) UILabel *timeRightLab;
@property (nonatomic, strong) UIView *lineBot;
@property (nonatomic, strong) UIButton *acceptBtn;
@end

@implementation ZhuJiDiyReceiveSolutionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = Main_BgColor;
//        [self setupUI];
//    }
//
//    return self;
//}

- (instancetype)initWithStyleType:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSString *)jumpFrom {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Main_BgColor;
        self.jumpFrom = jumpFrom;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(13, 0, SCREEN_WIDTH - 13 * 2, 100)];
    _bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bgView];
    CGFloat top = 0;
    //助剂定制
    if ([_jumpFrom isEqualToString:@"myZhuJiDiy"]) {
        UILabel *companyNameLab = [[UILabel alloc] init];
        companyNameLab.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:companyNameLab];
        _companyNameLab = companyNameLab;
        [companyNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.right.mas_equalTo(-80);
        }];
        
        UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        acceptBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [acceptBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        acceptBtn.layer.cornerRadius = 10.f;
        [_bgView addSubview:acceptBtn];
        _acceptBtn = acceptBtn;
        [acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(companyNameLab);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 49.3, _bgView.width - 40, 0.7)];
        line.backgroundColor = LineColor;
        [_bgView addSubview:line];
        top = 50;
    }
    
    //供应产品名称
    _productLeftLab = [[UILabel alloc] initWithFrame:CGRectMake(20, top + gap + 4, 100, 12)];
    _productLeftLab.text = @"供应产品名称:";
    _productLeftLab.font = [UIFont systemFontOfSize:12];
    _productLeftLab.textColor = HEXColor(@"#868686", 1);
    [_bgView addSubview:_productLeftLab];
    
    _productRightLab = [[UILabel alloc] initWithFrame:CGRectMake(_productLeftLab.right, _productLeftLab.top, _bgView.width - _productLeftLab.right, _productLeftLab.height)];
    _productRightLab.numberOfLines = 0;
    _productRightLab.textColor = HEXColor(@"#212121", 1);
    _productRightLab.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:_productRightLab];
    
    //需要提供样品
    _demoLeftLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _productLeftLab.bottom + gap, _productLeftLab.width, _productLeftLab.height)];
    _demoLeftLab.text = @"需要提供样品:";
    _demoLeftLab.font = _productLeftLab.font;
    _demoLeftLab.textColor = _productLeftLab.textColor;
    [_bgView addSubview:_demoLeftLab];
    
    _demoRightLab = [[UILabel alloc] initWithFrame:CGRectMake(_demoLeftLab.right, _demoLeftLab.top, _bgView.width - _demoLeftLab.right, _demoLeftLab.height)];
    _demoRightLab.numberOfLines = 0;
    _demoRightLab.textColor = _productRightLab.textColor;
    _demoRightLab.font = _productRightLab.font;
    [_bgView addSubview:_demoRightLab];
    
    //应用工艺描述
    _desLeftLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _demoLeftLab.bottom + gap, _demoLeftLab.width, _demoLeftLab.height)];
    _desLeftLab.text = @"应用工艺描述:";
    _desLeftLab.font = _productLeftLab.font;
    _desLeftLab.textColor = _productLeftLab.textColor;
    [_bgView addSubview:_desLeftLab];
    
    _desRightLab = [[UILabel alloc] initWithFrame:CGRectMake(_desLeftLab.right, _desLeftLab.top, _bgView.width - _desLeftLab.right, _desLeftLab.height)];
    _desRightLab.numberOfLines = 0;
    _desRightLab.textColor = _productRightLab.textColor;
    _desRightLab.font = _productRightLab.font;
    [_bgView addSubview:_desRightLab];
    
    //提交时间
    _timeLeftLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _desLeftLab.bottom + gap, _desLeftLab.width, _desLeftLab.height)];
    _timeLeftLab.text = @"提交时间:";
    _timeLeftLab.font = _productLeftLab.font;
    _timeLeftLab.textColor = _productLeftLab.textColor;
    [_bgView addSubview:_timeLeftLab];
    
    _timeRightLab = [[UILabel alloc] initWithFrame:CGRectMake(_timeLeftLab.right, _timeLeftLab.top, _bgView.width - _timeLeftLab.right, _timeLeftLab.height)];
    _timeRightLab.numberOfLines = 0;
    _timeRightLab.textColor = _productRightLab.textColor;
    _timeRightLab.font = _productRightLab.font;
    [_bgView addSubview:_timeRightLab];
    
    _lineBot = [[UIView alloc] initWithFrame:CGRectMake(20, 0, _bgView.width - 40, 0.7)];
    _lineBot.backgroundColor = LineColor;
    [_bgView addSubview:_lineBot];
}

- (void)btnClick {
    if (self.acceptBtnBlock) {
        self.acceptBtnBlock(_model.solutionID);
    }
}

- (void)setModel:(ZhuJiDiySolutionModel *)model {
    _model = model;
    if ([_jumpFrom isEqualToString:@"myZhuJiDiy"]) {
        if (isRightData(model.companyName)) {
            _companyNameLab.text = model.companyName;
        }
    }
    
    if ([model.status isEqualToString:@"diying"]) {
        [_acceptBtn setTitle:@"采纳" forState:UIControlStateNormal];
        _acceptBtn.backgroundColor = HEXColor(@"#ED3851", 1);
        _acceptBtn.enabled = YES;
    } else {
        _acceptBtn.backgroundColor = RGBA(0, 0, 0, 0.2);
        _acceptBtn.enabled = NO;
        if ([model.status isEqualToString:@"accept"]) {
            [_acceptBtn setTitle:@"已采纳" forState:UIControlStateNormal];
        } else if ([model.status isEqualToString:@"not_accept"]) {
            [_acceptBtn setTitle:@"未采纳" forState:UIControlStateNormal];
        }
    }
    
    //产品名称
    if (isRightData(model.productName)) {
        _productRightLab.text = model.productName;
    } else {
        _productRightLab.text = @"暂无信息";
    }
    _productRightLab.height = [_productRightLab.text boundingRectWithSize:CGSizeMake(_productRightLab.width, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:_productRightLab.font}
                                                        context:nil].size.height;
    _demoLeftLab.top = _productRightLab.bottom + gap;
    _demoRightLab.top = _demoLeftLab.top;
    
    //需要提供样品
    if (isRightData(model.num) && isRightData(model.numUnit)) {
        _demoRightLab.text = [NSString stringWithFormat:@"%@%@",model.num,model.numUnit];
    } else {
        _demoRightLab.text = @"暂无信息";
    }
    _demoRightLab.height = [_demoRightLab.text boundingRectWithSize:CGSizeMake(_demoRightLab.width, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:_demoRightLab.font}
                                                                  context:nil].size.height;
    _desLeftLab.top = _demoRightLab.bottom + gap;
    _desRightLab.top = _desLeftLab.top;
    
    
    //描述
    if (isRightData(model.descriptionStr)) {
        _desRightLab.text = model.descriptionStr;
    } else {
        _desRightLab.text = @"暂无描述";
    }
    _desRightLab.height = [_desRightLab.text boundingRectWithSize:CGSizeMake(_desRightLab.width, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:_desRightLab.font}
                                                            context:nil].size.height;
    _timeLeftLab.top = _desRightLab.bottom + gap;
    _timeRightLab.top = _timeLeftLab.top;
    
    //提交时间
    if (isRightData(model.createdAt)) {
        _timeRightLab.text = model.createdAt;
    } else {
        _timeRightLab.text = @"暂无信息";
    }
    
    _timeRightLab.height = [_timeRightLab.text boundingRectWithSize:CGSizeMake(_timeRightLab.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_timeRightLab.font}
                                                          context:nil].size.height;
    _bgView.height = _timeRightLab.bottom + gap + 4;
    _lineBot.top = _bgView.bottom - _lineBot.height;
    model.cellHeight = _bgView.bottom;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView type:(NSString *)jumpFrom {
    static NSString *const identifier = @"ZhuJiDiyReceiveSolutionCell";
    ZhuJiDiyReceiveSolutionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZhuJiDiyReceiveSolutionCell alloc] initWithStyleType:UITableViewCellStyleDefault reuseIdentifier:identifier type:jumpFrom];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
