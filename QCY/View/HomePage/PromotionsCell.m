//
//  PromotionsCell.m
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PromotionsCell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import <YYWebImage.h>
#import "HomePageModel.h"
#import "HelperTool.h"
#import "UIView+Geometry.h"

@interface PromotionsCell()
@property (nonatomic, strong)NSMutableArray *typeArray;
@end

@implementation PromotionsCell {
    UIImageView *_imageView;
    UILabel *_desText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (NSMutableArray *)typeArray {
    if (!_typeArray) {
        _typeArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _typeArray;
}

- (void)setupUI {
    UIView *gap = [[UIView alloc] init];
    gap.backgroundColor = RGBA(0, 0, 0, 0.1);
    [self.contentView addSubview:gap];
    [gap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(6);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width = SCREEN_WIDTH * 0.5;
    CGFloat height = KFit_W(75.0);
    for (NSInteger i = 0; i < dataSource.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 1000 + i;
        [self.contentView addSubview:imageView];
        BannerModel *model = dataSource[i];
        [imageView yy_setImageWithURL:[NSURL URLWithString:ImgStr(model.ad_image)] placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        [HelperTool addTapGesture:imageView withTarget:self andSEL:@selector(linkOfJump:)];
        
        if (dataSource.count % 2 == 0) {
            imageView.frame = CGRectMake((i % 2) * width, (i / 2) * height, width, height);
        } else {
            if (i == 0) {
                imageView.frame = CGRectMake(0, 0, width * 2, height);
            } else {
                imageView.frame = CGRectMake(((i + 1) % 2) * width, ((i + 1) / 2) * height, width, height);
            }
        }
        
    }

}


- (void)linkOfJump:(id)sender {
    //活动的名字数组
    NSArray<NSString *> * promotionsName = [NSArray arrayWithObjects:@"group_buy",@"sales",@"meeting",@"vote",@"auction", nil];
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag - 1000;
    BannerModel *model = _dataSource[tag];
    for (NSInteger i = 0; i < promotionsName.count; i ++) {
        if ([model.ad_name isEqualToString:promotionsName[i]]) {
            if (self.promotionsBlock) {
                self.promotionsBlock(i);
            }
        }
    }
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"promotionsCell";
    PromotionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PromotionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
