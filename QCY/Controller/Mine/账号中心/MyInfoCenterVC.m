//
//  MyInfoCenterVC.m
//  QCY
//
//  Created by i7colors on 2018/11/12.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyInfoCenterVC.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import "ResetPassword.h"
#import "CompanyApproveVC.h"


@interface MyInfoCenterVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *infoArray;
@property (nonatomic, strong)UIImageView *headerImage;
@end

@implementation MyInfoCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self.view addSubview:self.tableView];
    
    [self registerNoti];
}

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
        if ([isCompany boolValue] == YES) {
            userType = @"企业账号";
        } else {
//            userType = [NSString stringWithFormat:@"个人账号(点击申请企业账号)"];
            userType = [NSString stringWithFormat:@"个人账号"];
        }
        NSArray *arr = @[@[Get_UserName,@"修改密码"],@[userType]];
        _infoArray = [NSMutableArray arrayWithArray:arr];
    }
    
    return _infoArray;
}


- (void)setNavBar {
    self.nav.titleLabel.text = @"账号中心";
    self.nav.titleLabel.textColor = [UIColor whiteColor];
    [self.nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    self.nav.bottomLine.hidden = YES;
    [ClassTool addLayer:self.nav frame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
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
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyle;
        [_tableView setSeparatorColor : HEXColor(@"#ebebeb", 1)];
        _tableView.tableHeaderView = [self setHeaderView];
        
    }
    return _tableView;
}


- (UIView *)setHeaderView {
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116 + 60);
    UIView *headerTop = [[UIView alloc] init];
    headerTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116);
    [ClassTool addLayer:headerTop frame:CGRectMake(0, 0, SCREEN_WIDTH, 120) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [header addSubview:headerTop];
    //头部白色部分
    UIView *headerInfo = [[UIView alloc] init];
    headerInfo.backgroundColor = [UIColor whiteColor];
    headerInfo.layer.cornerRadius = 10;
    [header addSubview:headerInfo];
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
    [header addSubview:headerImage];
    [HelperTool addTapGesture:headerImage withTarget:self andSEL:@selector(jumpToChangeHeader)];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerInfo.mas_top);
        make.centerX.mas_equalTo(headerInfo);
        make.height.width.mas_equalTo(70);
    }];
    _headerImage = headerImage;
    
    UILabel *change = [[UILabel alloc] init];
    change.font = [UIFont systemFontOfSize:15];
    change.textColor = HEXColor(@"#333333", 1);
    change.text = @"更换头像";
    [headerInfo addSubview:change];
    [change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(18));
        make.bottom.mas_equalTo(headerImage);
        make.right.mas_equalTo(headerImage.mas_left).offset(5);
    }];
    
    UIImageView *companyType = [[UIImageView alloc] init];
    [headerInfo addSubview:companyType];
    [companyType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-18));
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(KFit_W(60));
        make.bottom.mas_equalTo(headerImage);
    }];
    
    UILabel *companyName = [[UILabel alloc] init];
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.font = [UIFont boldSystemFontOfSize:18];
    [headerInfo addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImage.mas_bottom).offset(30);
        make.centerX.mas_equalTo(headerInfo);
        make.left.right.mas_equalTo(0);
    }];
    if ([isCompany boolValue] == YES) {
        companyName.text = Get_CompanyName;
        companyType.image = [UIImage imageNamed:@"user_company"];
    } else {
        companyName.text = Get_UserName;
        companyType.image = [UIImage imageNamed:@"user_personal"];
    }
    if (Get_Header) {
        NSURL *headerUrl = Get_Header;
        [headerImage sd_setImageWithURL:headerUrl placeholderImage:nil];
    } else {
        headerImage.image = DefaultImage;
    }
    
    return header;
}

- (void)jumpToChangeHeader {
    ChangeHeaderVC *vc = [[ChangeHeaderVC alloc] init];
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
//    if (indexPath.section == 1) {
//        if ([isCompany boolValue] == NO) {
//            CompanyApproveVC *vc = [[CompanyApproveVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
    
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([isCompany boolValue] == YES) {
            cell.detailTextLabel.textColor = HEXColor(@"#F10215", 1);
        } else {
            cell.detailTextLabel.textColor = HEXColor(@"#386FED", 1);
        }
    }
    
    return cell;
}

//改变头像的代理方法
- (void)changeHeader:(NSNotification *)notification {
    //头像
    NSURL *header = notification.userInfo[@"cHeader"];
    if (header) {
//        NSURL *headerUrl = [NSURL URLWithString:@"header"];
        [_headerImage sd_setImageWithURL:header placeholderImage:nil];
    }
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

@end
