//
//  GroupBuyBargainVC.m
//  QCY
//
//  Created by i7colors on 2019/7/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyBargainVC.h"
#import "MyGroupBuyingTBCell.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "GroupBuyingModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import <WXApi.h>
#import "BargainHeaderView.h"
#import <MJRefresh.h>


@interface GroupBuyBargainVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BargainHeaderView *headerView;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *barganID;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation GroupBuyBargainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我发起的砍价";
    _barganID = self.infoDataSource.buyerId;
    _groupID = self.infoDataSource.groupID;
    [self.view addSubview:self.tableView];
    [self requestData];
}

- (BargainHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BargainHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 490)];
        _headerView.backgroundColor = Like_Color;
        [_headerView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.shareBtn setTitle:@"分享给好友,帮你砍价更优惠" forState:UIControlStateNormal];
        _headerView.model = _infoDataSource;
    }
    
    return _headerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorColor = RGBA(233, 233, 233, 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 18, 0, 18);
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableHeaderView = self.headerView;
        
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
                weakself.pageNumber++;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}



//分享
- (void)share{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    [imageArray addObject:ImgStr(_infoDataSource.productPic)];
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/cut.html?mainId=%@&buyerId=%@",ShareString,_groupID,_barganID];
                          
    NSString *text = [NSString stringWithFormat:@"亲们帮帮忙,我正在参与七彩云电商\"%@\"砍价活动",_infoDataSource.productName];
    [ClassTool shareSomething:imageArray urlStr:shareStr title:@"【团购砍价】" text:text];
}

- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_MyBargan_List,User_Token,_groupID,_barganID,self.pageNumber,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            NSArray<GroupBuyBarGainModel *> *tempArr = [GroupBuyBarGainModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (GroupBuyBarGainModel *model in tempArr) {
                model.priceUnit = weakself.infoDataSource.priceUnit;
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"header";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        UILabel *recordLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        recordLab.text = @"好友帮记录";
        recordLab.font = [UIFont systemFontOfSize:15];
        recordLab.textAlignment = NSTextAlignmentCenter;
        recordLab.backgroundColor = UIColor.whiteColor;
        [header addSubview:recordLab];
        
        UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH / 2, 30)];
        nickLab.font = [UIFont systemFontOfSize:13];
        nickLab.text = @"昵称";
        nickLab.backgroundColor = Like_Color;
        nickLab.textAlignment = NSTextAlignmentCenter;
        [header addSubview:nickLab];
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(nickLab.width, nickLab.top, SCREEN_WIDTH / 2, 30)];
        priceLab.font = [UIFont systemFontOfSize:13];
        priceLab.backgroundColor = Like_Color;
        priceLab.text = @"砍价金额";
        priceLab.textAlignment = NSTextAlignmentCenter;
        [header addSubview:priceLab];
    }
    
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BargainCell *cell = [BargainCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"暂无砍价记录";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
//                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
//                                 };
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}
//
//// 如果不实现此方法的话,无数据时下拉刷新不可用
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}
//
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return 250;
//}

@end

@implementation BargainCell {
    //昵称
    UILabel *_nickNameLab;
    //砍价金额
    UILabel *_bargainPriceLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //昵称
    _nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 46)];
    _nickNameLab.font = [UIFont systemFontOfSize:15];
    _nickNameLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nickNameLab];
    
    //砍价金额
    _bargainPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameLab.width, 0, SCREEN_WIDTH / 2, 46)];
    _bargainPriceLab.font = _nickNameLab.font;
    _bargainPriceLab.textColor = HEXColor(@"#ED3851", 1);
    _bargainPriceLab.textAlignment = _nickNameLab.textAlignment;
    [self.contentView addSubview:_bargainPriceLab];
    
}

- (void)setModel:(GroupBuyBarGainModel *)model {
    _model = model;
    
    _nickNameLab.text = model.nickName;
    _bargainPriceLab.text = [NSString stringWithFormat:@"已砍掉 %@元/%@",model.cutPrice,model.priceUnit];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"BargainCell";
    BargainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BargainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
