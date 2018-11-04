//
//  OpenMallVC_Cell.m
//  QCY
//
//  Created by i7colors on 2018/9/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OpenMallVC_Cell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import "HelperTool.h"
#import "UIImageView+CornerRadius.h"
#import "OpenMallModel.h"
#import "LXTagsView.h"
#import <YYWebImage.h>
#import <UIImageView+WebCache.h>

@implementation OpenMallVC_Cell {
    UIView *_imageBgView;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_contactLabel;
    UILabel *_areaLabel;
    LXTagsView *_tagsView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(KFit_W(9), 5, SCREEN_WIDTH - KFit_W(9) * 2, 120);
    [HelperTool setRound:bgView corner:UIRectCornerAllCorners radiu:6];
    [self.contentView addSubview:bgView];
    
    //图片的灰色背景
    UIView *imageBgView = [[UIView alloc] init];
    imageBgView.frame = CGRectMake(0, 0, 120, 120);
    imageBgView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [bgView addSubview:imageBgView];
    [HelperTool setRound:imageBgView corner:UIRectCornerTopLeft | UIRectCornerBottomLeft radiu:6];
    _imageBgView = imageBgView;
    
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0, 0, KFit_W(73), KFit_W(73));
    headerImageView.center = imageBgView.center;
    [imageBgView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //公司名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageBgView.mas_right).offset(15);
        make.top.mas_equalTo(17);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(-15);
    }];
    _nameLabel = nameLabel;
    
    //横线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(KFit_W(-30));
        make.height.mas_equalTo(1);
    }];
    
    //联系方式
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.font = [UIFont systemFontOfSize:12];
    contactLabel.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.right.equalTo(nameLabel);
        make.height.mas_equalTo(12);
    }];
    _contactLabel = contactLabel;
    
    //所在地区
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.font = [UIFont systemFontOfSize:12];
    areaLabel.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(contactLabel.mas_bottom).offset(4);
        make.right.equalTo(nameLabel);
        make.height.mas_equalTo(12);
    }];
    _areaLabel = areaLabel;
    
    //流水标签
    LXTagsView *tagsView = [[LXTagsView alloc]init];
    tagsView.allWidth = SCREEN_WIDTH - 150;
    tagsView.backgroundColor = [UIColor redColor];
    [bgView addSubview:tagsView];
    [tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(areaLabel.mas_bottom).with.offset(6);
        make.left.right.mas_equalTo(areaLabel.mas_left);
        make.bottom.mas_equalTo(-2);
    }];
    _tagsView = tagsView;
    
}

- (void)setModel:(OpenMallModel *)model {
    _model = model;
    //公司头像
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Photo_URL,model.logo]];
    [_headerImageView yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];

    //公司名字
    _nameLabel.text = model.company.companyName;
    //联系方式
    if isRightData(model.company.tel) {
        _contactLabel.text = [NSString stringWithFormat:@"联系方式：%@",model.company.tel];
    } else {
        _contactLabel.text = [NSString stringWithFormat:@"联系方式：暂无"];
    }
    //所在地区
    if isRightData(model.company.provinceName) {
        if (isRightData(model.company.cityName)) {
            _areaLabel.text = [NSString stringWithFormat:@"所在地区：%@%@",model.company.provinceName,model.company.cityName];
        } else {
            _areaLabel.text = [NSString stringWithFormat:@"所在地区：%@",model.company.provinceName];
        }
    } else {
        _areaLabel.text = [NSString stringWithFormat:@"所在地区：暂无"];
    }
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (BusinessList *m in model.businessList) {
        [mArr addObject:m.value];
    }

//    NSArray *array = @[@"将军",@"haha",@"xi",@"将军",@"ha",@"xi",@"将军",@"haha",@"xi"];
    _tagsView.dataA = mArr;
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"OpenMallVC_Cell";
    OpenMallVC_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OpenMallVC_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
