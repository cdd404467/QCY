//
//  ManifestCell.m
//  QCY
//
//  Created by i7colors on 2019/1/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ManifestCell.h"
#import "PrchaseLeagueModel.h"
#import "UIView+Geometry.h"
#import "MacroHeader.h"
#import <YYText.h>
#import "UIView+Border.h"


@implementation ManifestCell {
    UILabel *_productName;
    UILabel *_packing;
    YYLabel *_reserveNum;
    UILabel *_priceDate;
    YYLabel *_priceLabel;
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
    [view_one addBorderView:LineColor width:0.5 direction:BorderDirectionTop | BorderDirectionBottom];

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
    
    _priceDate = [[UILabel alloc] init];
    _priceDate.hidden = YES;
    _priceDate.font = [UIFont systemFontOfSize:12];
    _priceDate.textColor = HEXColor(@"#868686", 1);
    _priceDate.frame = CGRectMake(_packing.left, _packing.bottom + 6, _packing.width, 14);
    [view_one addSubview:_priceDate];
    
    //价格
    _priceLabel = [[YYLabel alloc] init];
    _priceLabel.hidden = YES;
    _priceLabel.frame = CGRectMake(_priceDate.right, _priceDate.top, _priceDate.width, 18);
    [view_one addSubview:_priceLabel];
   
    //  参考标准文字
    UILabel *standardLabel = [[UILabel alloc] init];
    standardLabel.frame = CGRectMake(_productName.left, view_one.bottom + 7, _productName.width, 13);
    standardLabel.font = [UIFont systemFontOfSize:12];
    standardLabel.textColor = HEXColor(@"#868686", 1);
    standardLabel.text = @"参考标准:";
    [self.contentView addSubview:standardLabel];
    //参考标准的label
    _stView = [[StandardView alloc] initWithFrame:CGRectMake(0, standardLabel.bottom + 5, SCREEN_WIDTH, 0)];
    [self.contentView addSubview:_stView];
}

- (void)setModel:(MeetingShopListModel *)model {
    _model = model;
    
    _productName.text = model.shopName;
    _packing.text = [NSString stringWithFormat:@"包装规格: %@",model.packing];
    NSString *rNum = model.reservationNum;
    NSString *text = [NSString stringWithFormat:@"预定用货量: %@ %@",rNum , model.numUnit];
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

