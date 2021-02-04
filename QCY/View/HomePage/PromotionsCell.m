//
//  PromotionsCell.m
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PromotionsCell.h"
#import <YYWebImage.h>
#import "HomePageModel.h"
#import "HelperTool.h"

@interface PromotionsCell()
@property (nonatomic, strong)ImagesViewDisPlay *imgView;
@end

@implementation PromotionsCell

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
    _imgView = [[ImagesViewDisPlay alloc] init];
    _imgView.backgroundColor = Cell_BGColor;
    DDWeakSelf;
    _imgView.promotionsBlock = ^(NSInteger type) {
        if (weakself.promotionsBlock) {
            weakself.promotionsBlock(type);
        }
    };
    [self.contentView addSubview:_imgView];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    _imgView.dataSource = dataSource;
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


@interface ImagesViewDisPlay()
@property (nonatomic, strong)NSMutableArray<UIImageView *> *imageViewArray;
@end

@implementation ImagesViewDisPlay

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageViewArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 6; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [HelperTool addTapGesture:imageView withTarget:self andSEL:@selector(linkOfJump:)];
            imageView.tag = i + 1000;
            imageView.hidden = YES;
            [self.imageViewArray addObject:imageView];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    CGFloat width = SCREEN_WIDTH * 0.5;
    CGFloat height = KFit_W(75.0);
    UIImageView *imageView = nil;
    for (UIImageView *imageView in self.imageViewArray) {
        imageView.hidden = YES;
        imageView.frame = CGRectZero;
    }
    for (NSInteger i = 0; i < dataSource.count; i ++) {
        imageView = self.imageViewArray[i];
        imageView.hidden = NO;
        BannerModel *model = dataSource[i];
        [self.imageViewArray[i] yy_setImageWithURL:[NSURL URLWithString:ImgStr(model.ad_image)] placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];

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
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageView.bottom);
}

- (void)linkOfJump:(id)sender {
    //活动的名字数组
    NSArray<NSString *> * promotionsName = [NSArray arrayWithObjects:@"group_buy",@"sales",@"meeting",@"vote",@"auction", @"proxy_market",nil];
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

@end
