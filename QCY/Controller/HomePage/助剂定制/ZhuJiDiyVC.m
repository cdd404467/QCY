//
//  ZhuJiDiyVC.m
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyVC.h"
#import <MJRefresh.h>
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "ZhuJiDiyCell.h"
#import "CddHUD.h"
#import "ZhuJiDiyModel.h"
#import "ZhuJiDiyDetailVC.h"
#import "HelperTool.h"
#import "PostZhuJiDiyVC.h"
#import <UIImageView+WebCache.h>


@interface ZhuJiDiyVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)BaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView *headerView;
@end

@implementation ZhuJiDiyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业专场定制";
    [self.view addSubview:self.tableView];
    [self requestData];
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
- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
                weakself.pageNumber++;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(144))];
        [_headerView sd_setImageWithURL:ImgUrl(_bannerURL)];
        _tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}


- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URLGet_ZhuJiDiy_List,User_Token,self.pageNumber,Page_Count,_specialID];
    
    if (self.isFirstLoadData == YES) {
        [CddHUD show:self.view];
    }
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                        NSLog(@"--- %@",json);
            weakself.totalNumber = [json[@"totalCount"] intValue];
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                if (weakself.pageNumber == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                NSArray *tempArr = [ZhuJiDiyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                [weakself.tableView.mj_footer endRefreshing];
                if (weakself.isFirstLoadData)
                    [weakself setupUI];
                weakself.isFirstLoadData = NO;
                [weakself.tableView reloadData];
            }
        }
        [CddHUD hideHUD:weakself.view];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无助剂定制发布";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - tableView代理方法
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuJiDiyDetailVC *vc = [[ZhuJiDiyDetailVC alloc] init];
    ZhuJiDiyModel *model = _dataSource[indexPath.row];
    vc.zhuJiDiyID = model.zhujiDiyID;
    vc.jumpFrom = @"home";
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuJiDiyCell *cell = [ZhuJiDiyCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    UIImageView *issueImg = [[UIImageView alloc] init];
    issueImg.image = [UIImage imageNamed:@"issue_img"];
    issueImg.layer.shadowColor = RGBA(0, 0, 0, 0.5).CGColor;
    issueImg.layer.shadowOffset = CGSizeMake(-6, 6);
    issueImg.layer.shadowOpacity = 1.0f;
    [HelperTool addTapGesture:issueImg withTarget:self andSEL:@selector(jumpToPostVC)];
    [self.view insertSubview:issueImg aboveSubview:_tableView];
    [self.view addSubview:issueImg];
    [issueImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(58);
        make.right.mas_equalTo(-9);
        make.bottom.mas_equalTo(-(58 + Bottom_Height_Dif));
    }];
    
    //文字
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 2;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = @"助剂\n定制";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [issueImg addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)jumpToPostVC {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    
    PostZhuJiDiyVC *vc = [[PostZhuJiDiyVC alloc] init];
    vc.specialCompanyName = _specialCompanyName;
    vc.specialID = _specialID;
    DDWeakSelf;
    vc.refreshZhuJiDiyListBlock = ^{
        weakself.pageNumber = 1;
        [weakself requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end

