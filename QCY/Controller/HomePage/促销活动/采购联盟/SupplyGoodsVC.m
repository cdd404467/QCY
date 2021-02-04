//
//  SupplyGoodsVC.m
//  QCY
//
//  Created by i7colors on 2019/3/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SupplyGoodsVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "PrchaseLeagueModel.h"
#import "HomePageSectionHeader.h"
#import "SupplyGoodsTBCell.h"
#import "ClassTool.h"
#import "AddCustomGoodsVC.h"
#import <UIImageView+WebCache.h>
#import "ContactsInfoCell.h"
#import <XHWebImageAutoSize.h>
#import "CddHUD.h"
#import "MobilePhone.h"
#import "AutoImageCell.h"
#import <UMAnalytics/MobClick.h>

@interface SupplyGoodsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)OrderOrSupplyModel *dataSource;
@property (nonatomic, assign)NSInteger noDeleteCount;
@property (nonatomic, strong)NSMutableArray<ContactsInfoCell *> *tempCellArray;
@end

@implementation SupplyGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要供货";
    [self.view addSubview:self.tableView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView cellForRowAtIndexPath:indexPath];
    ContactsInfoCell *cell = [ContactsInfoCell cellWithTableView:self.tableView];
    self.tempCellArray = [NSMutableArray arrayWithObject:cell];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"采购联盟-供货-%@",_pName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"采购联盟-供货-%@",_pName]];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#f5f5f5", 1);
        _tableView.bounces = NO;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}

- (void)setupUI {
    //确认添加商品按钮
    if ([_state isEqualToString:@"0"]) {
        UILabel *footer = [[UILabel alloc] init];
        footer.font = [UIFont systemFontOfSize:16];
        footer.text = @"活动已结束!";
        footer.textColor = HEXColor(@"#333333", 1);
        footer.textAlignment = NSTextAlignmentCenter;
        footer.backgroundColor = Like_Color;
        [self.view addSubview:footer];
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-Bottom_Height_Dif);
            make.height.mas_equalTo(49);
        }];
    } else {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"提交" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [ClassTool addLayer:addBtn];
        [self.view addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-Bottom_Height_Dif);
            make.height.mas_equalTo(49);
        }];
    }
}


//点击提交数据
- (void)submit {
    if ([self judgeRight] == NO) {
        return;
    }
    
    NSMutableArray *goodsArr = [NSMutableArray arrayWithCapacity:0];
    //从数据源中拿选中的商品
    for (MeetingShopListModel *model in _dataSource.meetingList.data) {
        if (model.isSelect == YES) {
            NSString *boolStr = [NSString string];
            if (model.isCustom == YES) {
                boolStr = @"1";
            } else {
                boolStr = @"0";
            }
            //找出打钩的标准模型，放到一个数组
            NSMutableArray *alreadySelArr = [NSMutableArray arrayWithCapacity:0];
            for (MeetingTypeListModel *m in model.meetingTypeList) {
                //遍历模型，从meetingTypeList拿出已经打钩的标准，准备展示出来
                if (m.isSelectStand == YES) {
                    [alreadySelArr addObject:m];
                }
            }
            //遍历这个数组
            NSMutableArray *stArr = [NSMutableArray arrayWithCapacity:0];
            for (MeetingTypeListModel *m in alreadySelArr) {
                [stArr addObject:m.referenceType];
            }
            NSString *stString = [stArr componentsJoinedByString:@","];
            
            NSDictionary *goodsDict = @{@"shopName":model.shopName,
                                        @"packing":model.packing,
                                        @"diyShop ":boolStr,
                                        @"price":model.price,
                                        @"priceUnit":@"元/吨",
                                        @"numUnit":@"吨",
                                        @"outputNum":model.outputNum,
                                        @"orderStatus":@"1",
                                        @"referenceType":stString,
                                        @"effectiveTime":model.effectiveTime
                                        };
            NSMutableDictionary *goodsMutablDict = [NSMutableDictionary dictionaryWithDictionary:goodsDict];
            if (model.isCustom == NO) {
                [goodsMutablDict setObject:model.shopID forKey:@"id"];
            }
            [goodsArr addObject:goodsDict];
        }
    }
    
    NSArray *areaArray = [_dataSource.areaSelect_data componentsSeparatedByString:@"-"];
    NSDictionary *dict = @{
                           @"companyName":_dataSource.companyTF_data,
                           @"name":_dataSource.contactTF_data,
                           @"positioner":_dataSource.workTF_data,
                           @"phone":_dataSource.phoneTF_data,
                           @"payType":_dataSource.paySelect_data,
                           @"accountPeriod":_dataSource.dateSelect_data,
                           @"provinceName":areaArray[0],
                           @"cityName":areaArray[1],
                           @"address":_dataSource.detailArea_data,
                           @"meetingId":_goodsID,
                           @"meetingList":[ClassTool arrayToJSONString:goodsArr],
                           @"from":@"app_ios"
                           };
    
//    NSLog(@"------- %@",dict);
//    return;
    DDWeakSelf;
    [CddHUD showWithText:@"提交中..." view:self.view];
    [ClassTool postRequest:URL_Order_Goods Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"-----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"供货成功" view:weakself.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        
    }];
    
}

//判断联系人的数据有没有填写
- (BOOL)judgeRight {
    BOOL isSel = NO;
    for (MeetingShopListModel *model in _dataSource.meetingList.data) {
        if (model.isSelect == YES) {
            isSel = YES;
        }
    }
    
    if (isSel == NO) {
        [CddHUD showTextOnlyDelay:@"请至少选择一个商品" view:self.view];
        return NO;
    } else if (_dataSource.companyTF_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入公司名称" view:self.view];
        return NO;
    } else if (_dataSource.contactTF_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入联系人" view:self.view];
        return NO;
    } else if (_dataSource.workTF_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输职务" view:self.view];
        return NO;
    } else if (_dataSource.phoneTF_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return NO;
    } else if (![MobilePhone isValidMobile:_dataSource.phoneTF_data]) {
        [CddHUD showTextOnlyDelay:@"请输入正确的手机号" view:self.view];
        return NO;
    } else if (_dataSource.paySelect_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请选择付款方式" view:self.view];
        return NO;
    } else if (_dataSource.dateSelect_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请选择账期" view:self.view];
        return NO;
    } else if (_dataSource.areaSelect_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请选择地区" view:self.view];
        return NO;
    }
    
    return YES;
}

//获取数据
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_System_Goods_List,_goodsID,@"1"];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [OrderOrSupplyModel mj_objectWithKeyValues:json[@"data"]];
            weakself.dataSource.meetingList.data = [MeetingShopListModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.meetingList.data];
            weakself.noDeleteCount = weakself.dataSource.meetingList.data.count;
            for (MeetingShopListModel *model in weakself.dataSource.meetingList.data) {
                model.meetingTypeList = [MeetingTypeListModel mj_objectArrayWithKeyValuesArray:model.meetingTypeList];
            }
            [weakself.tableView reloadData];
            [weakself setupUI];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//添加自定义的商品回调，在这里进行cell添加操作
- (void)addCustomGoods {
    AddCustomGoodsVC *vc = [[AddCustomGoodsVC alloc] init];
    vc.type = @"supply";
    DDWeakSelf;
    vc.addCustomGoodsBlock = ^(MeetingShopListModel * _Nonnull model) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakself.dataSource.meetingList.data.count inSection:0];
        [weakself.dataSource.meetingList.data addObject:model];
        [self.tableView beginUpdates];
        [weakself.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataSource.meetingList.data.count > 0) {
        return 3;
    } else {
        return 0;
    }
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataSource.meetingList.data.count;
    } else {
        return 1;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 208;
    } else if(indexPath.section == 1){
        return (20 + 24) * 9;
    } else {
        return [XHWebImageAutoSize imageHeightForURL:ImgUrl(_dataSource.picIn) layoutWidth:SCREEN_WIDTH estimateHeight:200];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row > _noDeleteCount - 1) {
            return YES;
        }
        return NO;
    }
    
    return NO;
}

// 点击左滑出现的删除按钮触发
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row > _noDeleteCount - 1) {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                [_dataSource.meetingList.data removeObjectAtIndex:indexPath.row];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView endUpdates];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 0.01;
    }
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"批量订货单",@"联系人信息",@"预定货说明"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    header.moreLabel.hidden = YES;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *secFooter = [[UIView alloc] init];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.layer.cornerRadius = 5.f;
//        btn.layer.masksToBounds = YES;
//        [btn setTitle:@"添加自定义商品" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.frame = CGRectMake(47, 0, SCREEN_WIDTH - 47 * 2, 44);
//        [btn addTarget:self action:@selector(addCustomGoods) forControlEvents:UIControlEventTouchUpInside];
//        [secFooter addSubview:btn];
//        [ClassTool addLayer:btn frame:CGRectMake(0, 0, btn.width, btn.height)];
        
        return secFooter;
    } else {
        return nil;
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SupplyGoodsTBCell *cell = [SupplyGoodsTBCell cellWithTableView:tableView];
        cell.model = _dataSource.meetingList.data[indexPath.row];
        return cell;
    } else if (indexPath.section == 1) {
        ContactsInfoCell *cell = self.tempCellArray[indexPath.row];
        cell.model = _dataSource;
        return cell;
    } else {
        AutoImageCell *cell = [AutoImageCell cellWithTableView:tableView];
        [cell.cellImageView sd_setImageWithURL:ImgUrl(_dataSource.picOut) placeholderImage:PlaceHolderImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            /** 缓存image size */
            [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
                /** reload  */
                if(result)  [tableView  xh_reloadDataForURL:imageURL];
            }];
        }];
        return cell;
    }
    
}

@end
