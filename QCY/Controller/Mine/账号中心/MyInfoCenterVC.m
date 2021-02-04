//
//  MyInfoCenterVC.m
//  QCY
//
//  Created by i7colors on 2018/11/12.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyInfoCenterVC.h"
#import "ClassTool.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import "ResetPassword.h"
#import "CompanyApproveVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "UserInfoModel.h"
#import "QCYAlertView.h"
#import "JudgeTools.h"

@interface MyInfoCenterVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) UserInfoModel *dataSource;
@property (nonatomic, strong) MyInfoCenterHeaderView *headerView;
@end

@implementation MyInfoCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[UserInfoModel alloc] init];
    self.dataSource.status = @"empty";
    [self setNavBar];
    [self.view addSubview:self.tableView];
    [self requestData];
    [self registerNoti];
}
//个人用户信息
- (void)registerNoti {
    //修改头像监听
    NSString *notiName1 = @"changeHeader";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeader:) name:notiName1 object:nil];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSArray *arr = @[@[@"名称",@"密码"],@[@"账号类型"]];
        _titleArray = [NSMutableArray arrayWithArray:arr];
    }
    
    return _titleArray;
}

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        NSString *userType = [NSString string];
        if (isCompanyUser) {
            userType = @"企业账号";
        } else {
            userType = [NSString stringWithFormat:@"个人账号(点击申请企业账号)"];
//            userType = [NSString stringWithFormat:@"个人账号"];
        }
//        NSArray *arr = @[@[Get_UserName,@"修改密码"],@[userType]];
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:Get_UserName,@"修改密码", nil];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObject:userType];
        _infoArray = [NSMutableArray arrayWithCapacity:0];
        [_infoArray addObject:arr1];
        [_infoArray addObject:arr2];
    }
    
    return _infoArray;
}

- (MyInfoCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MyInfoCenterHeaderView alloc] init];
        DDWeakSelf;
        _headerView.headerBlock = ^{
            [weakself jumpToChangeHeader];
        };
    }
    
    return _headerView;
}

#pragma mark - 获取认证状态
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_CompanyCert_Status,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            self.dataSource = [UserInfoModel mj_objectWithKeyValues:json[@"data"]];
            NSString *status = self.dataSource.status;
            //未认证
        
            NSString *subtitle = @"个人账号";
        
            if ([status isEqualToString:@"empty"]) {
                subtitle = @"个人账号(点击申请企业账号)";
            }
            //审核中
            else if ([status isEqualToString:@"wait_audit"]) {
                subtitle = @"个人账号(审核中)";
            }
            //已锁定
            else if ([status isEqualToString:@"checked"]) {
                subtitle = @"个人账号(已锁定)";
            }
            //审核未通过
            else if ([status isEqualToString:@"audit_fail"]) {
                subtitle = @"个人账号(审核未通过,点击重新申请)";
            }
            //审核通过
            else if ([status isEqualToString:@"audit"]) {
                subtitle = @"企业账号";
            }
        
            [self.infoArray[1] replaceObjectAtIndex:0 withObject:subtitle];
            
            //修改本地保存的信息
            BOOL isCom = self.dataSource.isCompany_User.boolValue;
            
            if (isCom != isCompanyUser) {
                NSMutableDictionary *userDict = [User_Info mutableCopy];
                [userDict setObject:isCom ? json[@"data"][@"companyName"] : @"" forKey:@"companyName"];
                [userDict setObject:json[@"data"][@"isCompany"] forKey:@"isCompany"];
                [UserDefault setObject:userDict forKey:@"userInfo"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAllDataWithThis" object:nil userInfo:nil];
                [self.headerView changeInfo];
            }
            
            [self.tableView reloadData];
            
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)setNavBar {
    self.title = @"账号中心";
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    [ClassTool addLayer:nav frame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundView:nav];
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    self.backBtnTintColor = UIColor.whiteColor;
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavBar];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HEXColor(@"#f5f5f5", 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
//        _tableView.separatorStyle = UITableViewCellSeparatorStyle;
        [_tableView setSeparatorColor : HEXColor(@"#ebebeb", 1)];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}


- (void)jumpToChangeHeader {
    ChangeHeaderVC *vc = [[ChangeHeaderVC alloc] init];
    vc.changeType = @"uc";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleArray.count;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.titleArray[section] count];
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        ResetPassword *vc = [[ResetPassword alloc] init];
        vc.passType = @"changePW";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        if (!isCompanyUser) {
            if (![_dataSource.status isEqualToString:@"checked"]) {
                CompanyApproveVC *vc = [[CompanyApproveVC alloc] init];
                vc.status = self.dataSource.status;
                vc.infoID = self.dataSource.compInfoID;
                vc.companyId = self.dataSource.companyId;
                DDWeakSelf;
                vc.refreshMyInfoBlock = ^{
                    [weakself requestData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([_dataSource.status isEqualToString:@"checked"]) {
                [QCYAlertView showWithTitle:@"提示" text:@"您的账号已锁定,请联系客服!" btnTitle:@"联系客服" handler:^{
                    [JudgeTools callService];
                } cancel:nil];
            }
        }
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.infoArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 1) {
        if (isCompanyUser) {
            cell.detailTextLabel.textColor = HEXColor(@"#F10215", 1);
            if ([_dataSource.status isEqualToString:@"checked"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.detailTextLabel.textColor = HEXColor(@"#386FED", 1);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

//改变头像的方法
- (void)changeHeader:(NSNotification *)notification {
    //头像
    NSURL *header = notification.userInfo[@"cHeader"];
    if (header) {
//        NSURL *headerUrl = [NSURL URLWithString:@"header"];
        [self.headerView.headerImage sd_setImageWithURL:header placeholderImage:nil];
    }
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@interface MyInfoCenterHeaderView()

@end

@implementation MyInfoCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116 + 60);
    UIView *headerTop = [[UIView alloc] init];
    headerTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116);
    [ClassTool addLayer:headerTop frame:CGRectMake(0, 0, SCREEN_WIDTH, 120) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self addSubview:headerTop];
    //头部白色部分
    UIView *headerInfo = [[UIView alloc] init];
    headerInfo.backgroundColor = [UIColor whiteColor];
    headerInfo.layer.cornerRadius = 10;
    [self addSubview:headerInfo];
    [headerInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerTop.mas_bottom);
        make.left.mas_equalTo(KFit_W(15));
        make.right.mas_equalTo(KFit_W(-15));
        make.height.mas_equalTo(120);
    }];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.layer.cornerRadius = 35;
    headerImage.clipsToBounds = YES;
    headerImage.backgroundColor = View_Color;
    [self addSubview:headerImage];
    [HelperTool addTapGesture:headerImage withTarget:self andSEL:@selector(clickHeader)];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerInfo.mas_top);
        make.centerX.mas_equalTo(headerInfo);
        make.height.width.mas_equalTo(70);
    }];
    _headerImage = headerImage;
    
    UIButton *change = [[UIButton alloc] init];
    change.titleLabel.font = [UIFont systemFontOfSize:15];
    [change setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
    [change setTitle:@"更换头像" forState:UIControlStateNormal];
    [change addTarget:self action:@selector(clickHeader) forControlEvents:UIControlEventTouchUpInside];
    [headerInfo addSubview:change];
    [change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(18));
        make.bottom.mas_equalTo(headerImage);
        make.height.mas_equalTo(20);
    }];
    [change sizeToFit];
    
    UIImageView *companyType = [[UIImageView alloc] init];
    [headerInfo addSubview:companyType];
    [companyType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-18));
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(KFit_W(60));
        make.bottom.mas_equalTo(headerImage);
    }];
    _companyType = companyType;
    
    UILabel *companyName = [[UILabel alloc] init];
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.font = [UIFont boldSystemFontOfSize:18];
    [headerInfo addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImage.mas_bottom).offset(30);
        make.centerX.mas_equalTo(headerInfo);
        make.left.right.mas_equalTo(0);
    }];
    _companyName = companyName;
    
    if (Get_Header) {
        NSURL *headerUrl = Get_Header;
        [headerImage sd_setImageWithURL:headerUrl placeholderImage:nil];
    } else {
        headerImage.image = DefaultImage;
    }
    
    if (isCompanyUser) {
        companyName.text = Get_CompanyName;
        companyType.image = [UIImage imageNamed:@"user_company"];
    } else {
        companyName.text = Get_UserName;
        companyType.image = [UIImage imageNamed:@"user_personal"];
    }
}

- (void)changeInfo {
    if (isCompanyUser) {
        _companyName.text = Get_CompanyName;
        _companyType.image = [UIImage imageNamed:@"user_company"];
    } else {
        _companyName.text = Get_UserName;
        _companyType.image = [UIImage imageNamed:@"user_personal"];
    }
}

- (void)clickHeader {
    if (self.headerBlock) {
        self.headerBlock();
    }
}


@end
