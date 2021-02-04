//
//  MyServiceCell.m
//  QCY
//
//  Created by i7colors on 2018/11/9.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyServiceCell.h"


@implementation MyServiceCell

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
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(KFit_W(38), 30, SCREEN_WIDTH - KFit_W(38 * 2), 265);
    bgView.layer.cornerRadius = 10;
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 5;
   
    [self.contentView addSubview:bgView];
    
    
    NSArray *titleArr1 = @[@"热线电话",@"七彩云微信",@"地址"];
    NSArray *titleArr2 = @[@"400-920-8599",@"i7_colors 七彩云电商",@"上海市徐汇区钦州北路1199号88栋4层"];
    CGFloat labelHeight = 16;
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label_1 = [[UILabel alloc] init];
        label_1.textColor = HEXColor(@"#333333", 1);
        label_1.font = [UIFont systemFontOfSize:14];
        label_1.text = titleArr1[i];
        [bgView addSubview:label_1];
        [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(25));
            make.right.mas_equalTo(KFit_W(-25));
            make.height.mas_equalTo(labelHeight);
            make.top.mas_equalTo(15 + i * 70);
        }];
        
        UILabel *label_2 = [[UILabel alloc] init];
        label_2.textColor = HEXColor(@"#666666", 1);
        label_2.font = [UIFont systemFontOfSize:14];
        label_2.text = titleArr2[i];
        [bgView addSubview:label_2];
        [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(label_1);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(label_1.mas_bottom).offset(14);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(label_2);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(label_2.mas_bottom).offset(3);
        }];
        
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"callBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(22);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(bgView);
        make.width.mas_equalTo(KFit_W(180));
    }];
    
}

//一键呼叫
- (void)callPhone {
    NSString *phoneNum = CompanyContact;
    NSString *tel = [NSString stringWithFormat:@"tel://%@",phoneNum];
    //开线程，解决ios10调用慢的问题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:tel]];
        });
    });
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyServiceCell";
    MyServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
