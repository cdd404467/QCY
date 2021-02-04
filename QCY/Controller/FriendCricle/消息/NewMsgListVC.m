//
//  NewMsgListVC.m
//  QCY
//
//  Created by i7colors on 2019/4/18.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "NewMsgListVC.h"
#import "NavControllerSet.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "Msg_CommentsVC.h"
#import "Msg_DianZanVC.h"
#import "Msg_RemindUsersVC.h"
#import "Msg_FocusMeVC.h"


@interface NewMsgListVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray<NSString *> *dataSource;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation NewMsgListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"印染圈消息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:NFT_FC_UnreadMessage_Refresh object:nil];
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self.view addSubview:self.tableView];
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //只要点进来就是全部已读
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FC_ReadMsg" object:nil userInfo:nil];
}



//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray<NSString *> *mArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0" ,nil];
        _dataSource = mArr;
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorColor = RGBA(225, 225, 225, 1);
        _tableView.backgroundColor = Like_Color;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,60, 0, 0)];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
    }
    return _tableView;
}


- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_All_Msg_Count,User_Token];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                         NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //未读评论数目
            [weakself.dataSource replaceObjectAtIndex:0 withObject:To_String(json[@"data"][@"comment_message_not_read_count"])];
            //未读点赞数目
            [weakself.dataSource replaceObjectAtIndex:1 withObject:To_String(json[@"data"][@"like_message_not_read_count"])];
            //未读@我的消息数目
            [weakself.dataSource replaceObjectAtIndex:2 withObject:To_String(json[@"data"][@"notice_message_not_read_count"])];
            //未读好友消息数目
            [weakself.dataSource replaceObjectAtIndex:3 withObject:To_String(json[@"data"][@"follow_message_not_read_count"])];
            [weakself.tableView reloadData];
//            NSLog(@"--- %@",weakself.dataSource);
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            Msg_CommentsVC *vc = [[Msg_CommentsVC alloc] init];
            vc.messageType = @"dyeComment";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            Msg_DianZanVC *vc = [[Msg_DianZanVC alloc] init];
            vc.messageType = @"dyeLike";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            Msg_RemindUsersVC *vc = [[Msg_RemindUsersVC alloc] init];
            vc.messageType = @"dyeNotice";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            Msg_FocusMeVC *vc = [[Msg_FocusMeVC alloc] init];
            vc.messageType = @"dyeFollow";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}


//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArr = @[@"评论",@"点赞",@"@我的",@"好友粉丝"];
    NewMsgCell *cell = [NewMsgCell cellWithTableView:tableView];
    cell.icomImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fc_msg_%@",@(indexPath.row).stringValue]];
    cell.nameLab.text = titleArr[indexPath.row];
    cell.badgeStr = self.dataSource[indexPath.row];
    
    return cell;
}

@end

@interface NewMsgCell()
@property (nonatomic, strong)UILabel *badgeLab;
@end


@implementation NewMsgCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    _badgeLab.backgroundColor = MainColor;
    if (selected) {
        [self.badgeLab setHighlighted:NO];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
//    _badgeLab.backgroundColor = MainColor;
    if (highlighted) {
        [self.badgeLab setHighlighted:NO];
    }
}

//可以不让cell改变子控件的背景颜色
- (void)layoutSubviews
{
    [super layoutSubviews];
    _badgeLab.backgroundColor = MainColor;
}

- (void)setupUI {
    _icomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    [self.contentView addSubview:_icomImageView];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_icomImageView.right + 20, 20, 200, 20)];
    _nameLab.font = [UIFont systemFontOfSize:15];
    _nameLab.textColor = HEXColor(@"#3C3C3C", 1);
    [self.contentView addSubview:_nameLab];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.image = [UIImage imageNamed:@"arrow_right"];
    [self.contentView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.icomImageView);
    }];
    
    UILabel *badgeLab = [[UILabel alloc] init];
    badgeLab.textAlignment = NSTextAlignmentCenter;
    badgeLab.backgroundColor = MainColor;
    badgeLab.hidden = YES;
    badgeLab.layer.cornerRadius = 18 / 2;
    badgeLab.clipsToBounds = YES;
    badgeLab.textColor = UIColor.whiteColor;
    badgeLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:badgeLab];
    [badgeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightImageView.mas_left).offset(-15);
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(rightImageView);
    }];
    _badgeLab = badgeLab;
}

- (void)setBadgeStr:(NSString *)badgeStr {
    _badgeStr = badgeStr;
    
    _badgeLab.hidden = [badgeStr integerValue] == 0 ? YES : NO;
    
    if ([badgeStr integerValue] > 99)
        badgeStr = @"99+";
    
    CGFloat width = [badgeStr boundingRectWithSize:CGSizeMake(50, 18)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_badgeLab.font}
                                                context:nil].size.width;
    if (badgeStr.length != 1) {
        [_badgeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width + 10);
        }];
    }
    _badgeLab.text = badgeStr;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"NewMsgCell";
    NewMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NewMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
