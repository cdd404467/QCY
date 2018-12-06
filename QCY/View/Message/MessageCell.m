//
//  MessageCell.m
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MessageCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "MessageModel.h"


@interface MessageCell()
@end


@implementation MessageCell {
    UILabel *_msgState;
    UILabel *_productName;
    UILabel *_timeLabel;
    UILabel *_msgContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    //已读未读状态
    UILabel *msgState = [[UILabel alloc] init];
    msgState.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:msgState];
    [msgState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(KFit_W(32));
        
    }];
    _msgState = msgState;
    
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.textColor = HEXColor(@"#000000", 1);
    productName.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(msgState);
        make.left.mas_equalTo(msgState.mas_right).offset(7);
        make.right.mas_equalTo(KFit_W(-145));
    }];
    _productName = productName;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = HEXColor(@"#868686", 1);
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(productName);
        make.width.mas_equalTo(KFit_W(125));
    }];
    _timeLabel = timeLabel;
    
    //消息文本
    UILabel *msgContent = [[UILabel alloc] init];
    msgContent.numberOfLines = 2;
    msgContent.font = [UIFont systemFontOfSize:12];
    msgContent.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:msgContent];
    [msgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName);
        make.right.mas_equalTo(timeLabel);
        make.top.mas_equalTo(productName.mas_bottom).offset(5);
        make.height.mas_equalTo(35);
    }];
    _msgContent = msgContent;
    
    //gap
    UIView *gap = [[UIView alloc] init];
    gap.backgroundColor = Cell_BGColor;
    [self.contentView addSubview:gap];
    [gap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(6);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)setModel:(MessageModel *)model {
    _model = model;
    //已读还是未读
    if (isRightData(model.isRead)) {
        //已读
        if ([model.isRead isEqualToString:@"1"]) {
            _msgState.text = @"已读";
            _msgState.textColor = HEXColor(@"#868686", 1);
        } else {
            _msgState.text = @"未读";
            _msgState.textColor = HEXColor(@"#F10215", 1);
        }
        
    }
    
    if isRightData(model.createdAt)
        _timeLabel.text = model.createdAt;
    
    //产品名字
    if isRightData(model.productName)
        _productName.text = model.productName;
        
    //消息文本
    if isRightData(model.content)
        _msgContent.text = model.content;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
