//
//  ManifestCell.m
//  QCY
//
//  Created by i7colors on 2019/1/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ManifestCell.h"
#import "PrchaseLeagueModel.h"
#import <YYText.h>
#import "UIView+Border.h"
#import "StandardView.h"


@implementation ManifestCell {
    UILabel *_productName;
    UILabel *_packing;
    YYLabel *_reserveNum;
    StandardView *_stView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UIView *view_one = [[UIView alloc] init];
    view_one.backgroundColor = [UIColor whiteColor];
    view_one.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    [self.contentView addSubview:view_one];
    [view_one addBorderView:RGBA(180, 180, 180, 1) width:0.5 direction:BorderDirectionTop];

    //名字
    _productName = [[UILabel alloc] init];
    _productName.frame = CGRectMake(12, 11, SCREEN_WIDTH - 24, 16);
    _productName.font = [UIFont boldSystemFontOfSize:15];
    [view_one addSubview:_productName];
    
    //包装规格
    _packing = [[UILabel alloc] init];
    _packing.font = [UIFont systemFontOfSize:12];
    _packing.textColor = HEXColor(@"#868686", 1);
    _packing.frame = CGRectMake(_productName.left, _productName.bottom + 7, _productName.width * 0.5, 18);
    [view_one addSubview:_packing];
    //预定量
    _reserveNum = [[YYLabel alloc] init];
    _reserveNum.frame = CGRectMake(_packing.right, _packing.top, _packing.width, 14);
    [view_one addSubview:_reserveNum];
    
    //底部分割线
    UIView *bsLine = [[UIView alloc] initWithFrame:CGRectMake(_productName.left, 0, _productName.width, 0.5)];
    bsLine.backgroundColor = RGBA(238, 238 , 238, 1);
    [view_one addSubview:bsLine];
    bsLine.bottom = view_one.bottom;
    
    //参考标准文字
    UILabel *standardLabel = [[UILabel alloc] init];
    standardLabel.frame = CGRectMake(_productName.left, view_one.bottom + 7, _productName.width, 13);
    standardLabel.font = [UIFont systemFontOfSize:12];
    standardLabel.textColor = HEXColor(@"#868686", 1);
    standardLabel.text = @"参考标准:";
    [self.contentView addSubview:standardLabel];
    //参考标准的View
    _stView = [[StandardView alloc] initWithFrame:CGRectMake(0, standardLabel.bottom + 5, SCREEN_WIDTH, 0)];
    [self.contentView addSubview:_stView];
}

- (void)setModel:(MeetingShopListModel *)model {
    _model = model;
    
    _productName.text = model.shopName;
    _packing.text = [NSString stringWithFormat:@"包装规格: %@",model.packing];
    NSString *rNum = model.reservationNum;
    NSString *text = [NSString stringWithFormat:@"预定订货量: %@ %@",rNum , model.numUnit];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_color = HEXColor(@"#868686", 1);
    mutableText.yy_alignment = NSTextAlignmentRight;
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(7, rNum.length)];
    [mutableText yy_setColor:HEXColor(@"#F10215", 1) range:NSMakeRange(7, rNum.length)];
    _reserveNum.attributedText = mutableText;
    
    //标准
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < model.meetingTypeList.count; i ++) {
        [nameArr addObject:[model.meetingTypeList[i] referenceType]];
    }
    
    _stView.nameArr = [nameArr copy];
    
    model.cellHeight = _stView.bottom + 11;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ManifestCell";
    ManifestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ManifestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

