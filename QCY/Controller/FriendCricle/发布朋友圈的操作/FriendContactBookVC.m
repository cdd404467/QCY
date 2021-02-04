//
//  FriendContactBookVC.m
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendContactBookVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <UIScrollView+EmptyDataSet.h>
#import "FriendCricleModel.h"
#import "FriendBookCell.h"

@interface FriendContactBookVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ZiMuModel *oriDataSource;
@property (nonatomic, strong)NSMutableArray<NSMutableArray *> *dataSource;
@property (nonatomic, strong)UILabel *totalLab;
@end

@implementation FriendContactBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友通讯录";
    [self.view addSubview:self.tableView];
    [self.rightNavBtn addTarget:self action:@selector(selecteComplete) forControlEvents:UIControlEventTouchUpInside];
    [self requestData];
}

//经过筛选后的数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray<NSString *> *arr1 = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray<NSArray *> *arr2 = [NSMutableArray arrayWithCapacity:0];
        _dataSource = [NSMutableArray arrayWithObjects:arr1, arr2, nil];
    }
    return _dataSource;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    
        _tableView.separatorColor = RGBA(220, 220, 220, 1);
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
        _tableView.sectionIndexColor = HEXColor(@"#708090", 1);
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        self.totalLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        self.totalLab.textColor = RGBA(0, 0, 0, 0.7);
        self.totalLab.textAlignment = NSTextAlignmentCenter;
        self.totalLab.font = [UIFont systemFontOfSize:16];
        _tableView.tableFooterView = self.totalLab;
        
    }
    return _tableView;
}

//选择完成
- (void)selecteComplete {
    [self.selectArray removeAllObjects];
    for (NSArray *arr in self.dataSource[1]) {
        for (FriendCricleInfoModel *model in arr) {
            if (model.isSelectFriend == YES)
                [self.selectArray addObject:model];
        }
    }
   
    if (self.selectedCompleteBlock) {
        self.selectedCompleteBlock(self.selectArray);
    }
    
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_FriendsBook_List,User_Token];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                         NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.oriDataSource = [ZiMuModel mj_objectWithKeyValues:json[@"data"]];
            [weakself dealWithJson];
            NSInteger total = 0;
            for (NSInteger i = 0; i < self.dataSource[1].count; i++) {
                total += [self.dataSource[1][i] count];
            }
            self.totalLab.text = [NSString stringWithFormat:@"共%ld个好友",(long)total];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"你还没有好友哦";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource[0].count;
}
//每组的cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[1][section] count];
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

//section的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

//section的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}


//分区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        
    return self.dataSource[0][section];
}

//TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = RGBA(245, 245, 245, 0.8);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:RGBA(84, 204, 84, 1)];
    [header.textLabel setFont:[UIFont systemFontOfSize:17]];
    [header.textLabel setTextAlignment:NSTextAlignmentLeft];
}

/** 右侧索引列表*/
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.dataSource[0] copy];
}


//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendBookCell *cell = [FriendBookCell cellWithTableView:tableView];
    cell.model = self.dataSource[1][indexPath.section][indexPath.row];
    return cell;
}



- (void)dealWithJson {
    if (self.oriDataSource.a.count > 0) {
        self.oriDataSource.a = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.a];
        [self.dataSource[0] addObject:@"A"];
        [self.dataSource[1] addObject:self.oriDataSource.a];
    }
    if (self.oriDataSource.b.count > 0) {
        self.oriDataSource.b = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.b];
        [self.dataSource[0] addObject:@"B"];
        [self.dataSource[1] addObject:self.oriDataSource.b];
    }
    if (self.oriDataSource.c.count > 0) {
        self.oriDataSource.c = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.c];
        [self.dataSource[0] addObject:@"C"];
        [self.dataSource[1] addObject:self.oriDataSource.c];
    }
    if (self.oriDataSource.d.count > 0) {
        self.oriDataSource.d = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.d];
        [self.dataSource[0] addObject:@"D"];
        [self.dataSource[1] addObject:self.oriDataSource.d];
    }
    if (self.oriDataSource.e.count > 0) {
        self.oriDataSource.e = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.e];
        [self.dataSource[0] addObject:@"E"];
        [self.dataSource[1] addObject:self.oriDataSource.e];
    }
    if (self.oriDataSource.f.count > 0) {
        self.oriDataSource.f = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.f];
        [self.dataSource[0] addObject:@"F"];
        [self.dataSource[1] addObject:self.oriDataSource.f];
    }
    if (self.oriDataSource.g.count > 0) {
        self.oriDataSource.g = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.g];
        [self.dataSource[0] addObject:@"G"];
        [self.dataSource[1] addObject:self.oriDataSource.g];
    }
    if (self.oriDataSource.h.count > 0) {
        self.oriDataSource.h = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.h];
        [self.dataSource[0] addObject:@"H"];
        [self.dataSource[1] addObject:self.oriDataSource.h];
    }
    if (self.oriDataSource.i.count > 0) {
        self.oriDataSource.i = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.i];
        [self.dataSource[0] addObject:@"I"];
        [self.dataSource[1] addObject:self.oriDataSource.i];
    }
    if (self.oriDataSource.j.count > 0) {
        self.oriDataSource.j = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.j];
        [self.dataSource[0] addObject:@"J"];
        [self.dataSource[1] addObject:self.oriDataSource.j];
    }
    if (self.oriDataSource.k.count > 0) {
        self.oriDataSource.k = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.k];
        [self.dataSource[0] addObject:@"K"];
        [self.dataSource[1] addObject:self.oriDataSource.k];
    }
    if (self.oriDataSource.l.count > 0) {
        self.oriDataSource.l = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.l];
        [self.dataSource[0] addObject:@"L"];
        [self.dataSource[1] addObject:self.oriDataSource.l];
    }
    if (self.oriDataSource.m.count > 0) {
        self.oriDataSource.m = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.m];
        [self.dataSource[0] addObject:@"M"];
        [self.dataSource[1] addObject:self.oriDataSource.m];
    }
    if (self.oriDataSource.n.count > 0) {
        self.oriDataSource.n = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.n];
        [self.dataSource[0] addObject:@"N"];
        [self.dataSource[1] addObject:self.oriDataSource.n];
    }
    if (self.oriDataSource.o.count > 0) {
        self.oriDataSource.o = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.o];
        [self.dataSource[0] addObject:@"O"];
        [self.dataSource[1] addObject:self.oriDataSource.o];
    }
    if (self.oriDataSource.p.count > 0) {
        self.oriDataSource.p = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.p];
        [self.dataSource[0] addObject:@"P"];
        [self.dataSource[1] addObject:self.oriDataSource.p];
    }
    if (self.oriDataSource.q.count > 0) {
        self.oriDataSource.q = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.q];
        [self.dataSource[0] addObject:@"Q"];
        [self.dataSource[1] addObject:self.oriDataSource.q];
    }
    if (self.oriDataSource.r.count > 0) {
        self.oriDataSource.r = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.r];
        [self.dataSource[0] addObject:@"R"];
        [self.dataSource[1] addObject:self.oriDataSource.r];
    }
    if (self.oriDataSource.s.count > 0) {
        self.oriDataSource.s = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.s];
        [self.dataSource[0] addObject:@"S"];
        [self.dataSource[1] addObject:self.oriDataSource.s];
    }
    if (self.oriDataSource.t.count > 0) {
        self.oriDataSource.t = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.t];
        [self.dataSource[0] addObject:@"T"];
        [self.dataSource[1] addObject:self.oriDataSource.t];
    }
    if (self.oriDataSource.u.count > 0) {
        self.oriDataSource.u = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.u];
        [self.dataSource[0] addObject:@"U"];
        [self.dataSource[1] addObject:self.oriDataSource.u];
    }
    if (self.oriDataSource.v.count > 0) {
        self.oriDataSource.v = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.v];
        [self.dataSource[0] addObject:@"V"];
        [self.dataSource[1] addObject:self.oriDataSource.v];
    }
    if (self.oriDataSource.w.count > 0) {
        self.oriDataSource.w = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.w];
        [self.dataSource[0] addObject:@"W"];
        [self.dataSource[1] addObject:self.oriDataSource.w];
    }
    if (self.oriDataSource.x.count > 0) {
        self.oriDataSource.x = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.x];
        [self.dataSource[0] addObject:@"X"];
        [self.dataSource[1] addObject:self.oriDataSource.x];
    }
    if (self.oriDataSource.y.count > 0) {
        self.oriDataSource.y = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.y];
        [self.dataSource[0] addObject:@"Y"];
        [self.dataSource[1] addObject:self.oriDataSource.y];
    }
    if (self.oriDataSource.z.count > 0) {
        self.oriDataSource.z = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.z];
        [self.dataSource[0] addObject:@"Z"];
        [self.dataSource[1] addObject:self.oriDataSource.z];
    }
    if (self.oriDataSource.special.count > 0) {
        self.oriDataSource.special = [FriendCricleInfoModel mj_objectArrayWithKeyValuesArray:self.oriDataSource.special];
        [self.dataSource[0] addObject:@"#"];
        [self.dataSource[1] addObject:self.oriDataSource.special];
    }
    
    if (self.selectArray.count < 0)
        return;
    
    //如果之前选中过，就打钩
    for (NSArray *arr in self.dataSource[1]) {
        for (FriendCricleInfoModel *model in arr) {
            for (FriendCricleInfoModel *m in self.selectArray) {
                if ([model.userId isEqualToString:m.userId]) {
                    model.isSelectFriend = YES;
                }
            }
        }
    }
    
}

@end


