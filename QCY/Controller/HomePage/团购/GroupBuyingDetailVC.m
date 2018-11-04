//
//  GroupBuyingDetailVC.m
//  QCY
//
//  Created by i7colors on 2018/11/2.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingDetailVC.h"
#import "CommonNav.h"
#import "MacroHeader.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import "GroupBuyDetailHeaderView.h"

@interface GroupBuyingDetailVC ()

//@property (nonatomic, strong)ProductInfoModel *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GroupBuyingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self requestData];
    [self setNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setNavBar {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"七彩云团购会";
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}


- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_GroupBuy_Detail,_groupID];
    
    [CddHUD show];
//    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//            weakself.dataSource = [ProductInfoModel mj_objectWithKeyValues:json[@"data"]];
//            weakself.dataSource.propMap = [PropMap mj_objectArrayWithKeyValuesArray:weakself.dataSource.propMap];
//            [weakself setupBottomBar];
        }
        [CddHUD hideHUD];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
