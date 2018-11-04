//
//  ProductDetailsVC.m
//  QCY
//
//  Created by i7colors on 2018/9/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductDetailsVC.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "ProductDetailHeaderView.h"
#import "UIView+Border.h"
#import <SDAutoLayout.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ProductDetailBasicParaCell.h"
#import "ProductDetailSectionHeader.h"
#import "OpenMallModel.h"

@interface ProductDetailsVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)ProductInfoModel *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProductDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    
//    [self setupBottomBar];
    
    [self requestData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HEXColor(@"#d9d9d9", 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
//            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.rowHeight = UITableViewAutomaticDimension;
        ProductDetailHeaderView *header = [[ProductDetailHeaderView alloc] init];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40 + KFit_H(210) + 60);
        _tableView.tableHeaderView = header;
        
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = HEXColor(@"#d9d9d9", 1);
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}

- (void)requestData {
   
    NSString *urlString = [NSString stringWithFormat:URL_Product_DetailInfo,_productID];
    
    [CddHUD show];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [ProductInfoModel mj_objectWithKeyValues:json[@"data"]];
            weakself.dataSource.propMap = [PropMap mj_objectArrayWithKeyValuesArray:weakself.dataSource.propMap];
            [weakself setupBottomBar];
        }
        [CddHUD hideHUD];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 51;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSource.propMap.count == 0) {
        return 1;
    } else {
        return _dataSource.propMap.count;
    }
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    ProductDetailSectionHeader *header = [ProductDetailSectionHeader headerWithTableView:tableView];
    
    return header;
}

//估算高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.propMap.count == 0) {
        return 60;
    } else {
        return UITableViewAutomaticDimension;
    }
    
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductDetailBasicParaCell *cell = [ProductDetailBasicParaCell cellWithTableView:tableView];
    
    if (_dataSource.propMap.count == 0) {
        cell.noneLabel.hidden = NO;
    } else {
        cell.noneLabel.hidden = YES;
        cell.model = _dataSource.propMap[indexPath.row];
    }
    
    return cell;
}

- (void)setupBottomBar {
    [self.view addSubview:self.tableView];
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
    //进入店铺
    UIButton *goInToShop = [UIButton buttonWithType:UIButtonTypeCustom];
    goInToShop.frame = CGRectMake(0, 0, KFit_W(60), 49);
    [goInToShop addBorderLayer:LineColor width:1.f direction:BorderDirectionRight];
    [goInToShop setImage:[UIImage imageNamed:@"shop_icon"] forState:UIControlStateNormal];
    [goInToShop setTitle:@"进入店铺" forState:UIControlStateNormal];
    [goInToShop setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
    goInToShop.titleLabel.font = [UIFont systemFontOfSize:10];
    goInToShop.titleLabel.textAlignment = NSTextAlignmentCenter;
    goInToShop.imageView.contentMode = UIViewContentModeScaleAspectFit;
    goInToShop.adjustsImageWhenHighlighted = NO;
    [bottomView addSubview:goInToShop];
    
    goInToShop.imageView.sd_layout
    .topSpaceToView(goInToShop, 7)
    .centerXEqualToView(goInToShop)
    .widthIs(23)
    .heightIs(20);
    
    goInToShop.titleLabel.sd_layout
    .bottomSpaceToView(goInToShop, 7)
    .leftEqualToView(goInToShop)
    .rightEqualToView(goInToShop)
    .heightIs(12);
    
    //联系客服
    UIButton *contactService = [UIButton buttonWithType:UIButtonTypeCustom];
    contactService.frame = CGRectMake(goInToShop.frame.size.width, 0, goInToShop.frame.size.width, 49);
    [contactService setImage:[UIImage imageNamed:@"contact_icon"] forState:UIControlStateNormal];
    [contactService setTitle:@"联系客服" forState:UIControlStateNormal];
    [contactService setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
    contactService.titleLabel.font = [UIFont systemFontOfSize:10];
    contactService.titleLabel.textAlignment = NSTextAlignmentCenter;
    contactService.imageView.contentMode = UIViewContentModeScaleAspectFit;
    contactService.adjustsImageWhenHighlighted = NO;
    [bottomView addSubview:contactService];
    
    contactService.imageView.sd_layout
    .topSpaceToView(contactService, 7)
    .centerXEqualToView(contactService)
    .widthIs(23)
    .heightIs(20);
    
    contactService.titleLabel.sd_layout
    .bottomSpaceToView(contactService, 7)
    .leftEqualToView(contactService)
    .rightEqualToView(contactService)
    .heightIs(12);
    
    //发起询价
//    UIButton *askPrice= [UIButton buttonWithType:UIButtonTypeCustom];
//    askPrice.frame = CGRectMake(goInToShop.frame.size.width * 2, 0, (SCREEN_WIDTH - goInToShop.frame.size.width * 2) / 2, 49);
//    [askPrice setTitle:@"发起询价" forState:UIControlStateNormal];
//    askPrice.titleLabel.font = [UIFont systemFontOfSize:15];
//    [askPrice setTitleColor:MainColor forState:UIControlStateNormal];
//    [askPrice addBorderLayer:MainColor width:3.f direction:BorderDirectionAll];
//    [bottomView addSubview:askPrice];
    
    //一键呼叫
    UIButton *callBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(goInToShop.frame.size.width * 2, 0, SCREEN_WIDTH - goInToShop.frame.size.width * 2, 49);
    callBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
    [callBtn setTitle:@"一键呼叫" forState:UIControlStateNormal];
    callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    callBtn.adjustsImageWhenHighlighted = NO;
    callBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGRect rect = CGRectMake(0, 0, callBtn.frame.size.width, 49);
    [ClassTool addLayer:callBtn frame:rect];
    [callBtn bringSubviewToFront:callBtn.titleLabel];
    [callBtn bringSubviewToFront:callBtn.imageView];
    [bottomView addSubview:callBtn];
    
    callBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    callBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    
//    callBtn.imageView.sd_layout
//    .leftSpaceToView(callBtn, KFit_W(12))
//    .centerYEqualToView(callBtn)
//    .widthIs(19)
//    .heightIs(20);
//
//    callBtn.titleLabel.sd_layout
//    .centerYEqualToView(callBtn)
//    .rightSpaceToView(callBtn, KFit_W(12))
//    .widthIs(90)
//    .heightIs(20);
}


@end
