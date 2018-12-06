//
//  ShopMainPageHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ShopMainPageHeaderView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "HelperTool.h"
#import <SDCycleScrollView.h>
#import "OpenMallModel.h"
#import <YYWebImage.h>

@interface ShopMainPageHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *bannerView; //轮播图
@property (nonatomic, strong)OpenMallModel *model;
@end

@implementation ShopMainPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}


//创建轮播图,50
- (void)setupUI:(NSInteger)number model:(OpenMallModel *)model {
    _model = model;
    NSMutableArray *bannerArr = [NSMutableArray arrayWithCapacity:0];
    if isRightData(model.banner1) 
        [bannerArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.banner1]];
    
    if isRightData(model.banner2)
        [bannerArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.banner2]];
    
    if isRightData(model.banner3)
        [bannerArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.banner3]];
    
    if isRightData(model.banner4)
        [bannerArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.banner4]];
    
    if isRightData(model.banner5)
        [bannerArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.banner5]];
    
    
//    NSArray *arr = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1240469072,2191573380&fm=26&gp=0.jpg",
//                     @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=889553397,2093664619&fm=26&gp=0.jpg",
//                     @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1397299872,1564665821&fm=26&gp=0.jpg",
//                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4225846828,2497659140&fm=11&gp=0.jpg"];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, floor(KFit_H(210)));
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:bannerArr];
    bannerView.delegate = self;
    bannerView.autoScrollTimeInterval = 3.f;
    bannerView.pageDotColor = [UIColor whiteColor];
    bannerView.currentPageDotColor = MainColor;
    [self addSubview:bannerView];
    _bannerView = bannerView;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bannerView.mas_bottom);
        make.height.mas_equalTo(50);
        make.left.right.mas_equalTo(0);
    }];
    //公司logo
    UIImageView *companyLogo = [[UIImageView alloc] init];
    companyLogo.layer.borderColor = HEXColor(@"#E5E5E5", 1).CGColor;
    companyLogo.layer.borderWidth = 1.f;
    [bgView addSubview:companyLogo];
    [companyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.left.mas_equalTo(4);
    }];
    if isRightData(model.logo) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Photo_URL,model.logo]];
        [companyLogo yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];
    }
    
    
    //公司名字
    UILabel *companyName = [[UILabel alloc] init];
    companyName.font = [UIFont boldSystemFontOfSize:13];
    companyName.textColor = [UIColor blackColor];
    [bgView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(companyLogo.mas_right).offset(9);
        make.top.mas_equalTo(companyLogo);
        make.width.mas_equalTo(KFit_W(150));
        make.height.mas_equalTo(15);
    }];
    if isRightData(model.companyName)
        companyName.text = model.companyName;
    
    //信用等级
    UILabel *cText = [[UILabel alloc] init];
    cText.font = [UIFont systemFontOfSize:9];
    cText.text = @"信用等级:";
    cText.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:cText];
    [cText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(companyLogo);
        make.left.mas_equalTo(companyName);
    }];
    
    //星星背景
    UIView *starView = [[UIView alloc] init];
    [bgView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cText.mas_right).offset(5);
        make.height.mas_equalTo(10);
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(cText);
    }];
    
    
    //几颗星星
    for (NSInteger i = 0;i < 5; i ++) {
        UIImageView *starImage = [[UIImageView alloc] init];
        starImage.frame = CGRectMake(12 * i, 0, 10, 10);
        [starView addSubview:starImage];
        if (i < number) {
            starImage.image = [UIImage imageNamed:@"star_selected"];
        } else {
            starImage.image = [UIImage imageNamed:@"star_unselected"];
        }
    }
    
    //一键呼叫按钮
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [callBtn setImage:[UIImage imageNamed:@"call_btn_110x25"] forState:UIControlStateNormal];
    [bgView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15 * Scale_W);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(companyLogo);
        make.width.mas_equalTo(100 * Scale_W);
    }];
}



- (void)callPhone {
//    NSString *phoneNum = [NSString string];
//    if isRightData(_model.phone) {
//        phoneNum = _model.phone;
//    } else {
//        phoneNum = CompanyContact;
//    }
    
    NSString *tel = [NSString stringWithFormat:@"tel://%@",CompanyContact];
    //开线程，解决ios10调用慢的问题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:tel]];
        });
    });
}


@end
