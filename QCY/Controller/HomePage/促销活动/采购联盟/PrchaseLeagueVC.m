//
//  PrchaseLeagueVC.m
//  QCY
//
//  Created by i7colors on 2019/1/8.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PrchaseLeagueVC.h"
#import "PromotionsHeaderView.h"
#import "CddHUD.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import <MJRefresh.h>
#import "PrchaseLeagueCell.h"
#import "PrchaseLeagueModel.h"
#import "MyManifestVC.h"
#import "PromotionsModel.h"
#import "OrderGoodsVC.h"
#import "SupplyGoodsVC.h"
#import "CGLMMobileView.h"


@interface PrchaseLeagueVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, strong)NSMutableArray *bannerDataSource;
@property (nonatomic, strong)CGLMMobileView *bindView;
@end

@implementation PrchaseLeagueVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"采购联盟";
    [self loadData];
}

- (void)setupUI {
    UIButton *lookOverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookOverBtn setTitle:@"查看我的货单" forState:UIControlStateNormal];
    [lookOverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookOverBtn addTarget:self action:@selector(alertBindMobile) forControlEvents:UIControlEventTouchUpInside];
    [ClassTool addLayer:lookOverBtn];
    [self.view addSubview:lookOverBtn];
    [lookOverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}

- (void)checkSMSAndJump {
    [self.bindView endEditing:YES];
    NSDictionary *dict = @{@"phone":_bindView.phoneTF.text,
                           @"code":_bindView.passwdTF.text,
                           };
    DDWeakSelf;
    [CddHUD show:_bindView];
    [ClassTool postRequest:URL_Cglm_Check_SMS Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.bindView];
        //        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"验证成功" view:weakself.bindView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.bindView removeSignView];
                    MyManifestVC *vc = [[MyManifestVC alloc] init];
                    vc.phoneNumber = weakself.bindView.phoneTF.text;
                    [weakself.navigationController pushViewController:vc animated:YES];
                });
            });

        } else {
            [CddHUD showTextOnlyDelay:@"验证码错误" view:weakself.bindView];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        PromotionsHeaderView *header = [[PromotionsHeaderView alloc] init];
        header.bannerArray = [_bannerDataSource copy];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(144));
        _tableView.tableHeaderView = header;
        
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page++;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}

- (NSMutableArray *)bannerDataSource {
    if (!_bannerDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _bannerDataSource = mArr;
    }
    return _bannerDataSource;
}

- (void)alertBindMobile {
//    MyManifestVC *vc = [[MyManifestVC alloc] init];
//    vc.phoneNumber = @"18252889110";
//    [self.navigationController pushViewController:vc animated:YES];
    CGLMMobileView *bindView = [[CGLMMobileView alloc]init];
    [bindView.loginBtn addTarget:self action:@selector(checkSMSAndJump) forControlEvents:UIControlEventTouchUpInside];
    [bindView.cancelBtn addTarget:self action:@selector(cancelJunp) forControlEvents:UIControlEventTouchUpInside];
    [UIApplication.sharedApplication.keyWindow addSubview:bindView];
    _bindView = bindView;
}

//取消
- (void)cancelJunp {
    [CddHUD hideHUD:_bindView];
    [_bindView removeSignView];
}

#pragma mark -  首次进入请求
- (void)loadData {
    DDWeakSelf;
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取banner
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"App_Meeting_Info"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *bannerArr = [PromotionsModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                for (PromotionsModel *model in bannerArr) {
                    [weakself.bannerDataSource addObject:ImgUrl(model.ad_image)];
                }
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //第二个线程，获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Purchase_League_List,weakself.page,Page_Count];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            [CddHUD hideHUD:weakself.view];
//                                                    NSLog(@"----== %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.totalNum = [json[@"totalCount"] intValue];
                NSArray *tempArr = [PrchaseLeagueModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            dispatch_group_leave(group);
            NSLog(@" Error : %@",error);
        }];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.view addSubview:weakself.tableView];
            [weakself setupUI];
            [CddHUD hideHUD:weakself.view];
        });
    });
    
}

//加载更多
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Purchase_League_List,_page,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        
//                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [PrchaseLeagueModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 187;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrchaseLeagueCell *cell = [PrchaseLeagueCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    DDWeakSelf;
    cell.btnClickBlock = ^(NSInteger tag, PrchaseLeagueModel * _Nonnull model) {
        //订货(采购)
        if (tag == 1000) {
            OrderGoodsVC *vc = [[OrderGoodsVC alloc] init];
            vc.goodsID = model.goodsID;
            vc.state = model.isType;
            vc.pName = model.meetingName;
            [weakself.navigationController pushViewController:vc animated:YES];
        } else {
            SupplyGoodsVC *vc = [[SupplyGoodsVC alloc] init];
            vc.goodsID = model.goodsID;
            vc.state = model.isType;
            vc.pName = model.meetingName;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

@end
