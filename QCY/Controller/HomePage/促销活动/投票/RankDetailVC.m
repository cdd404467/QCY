//
//  RankDetailVC.m
//  QCY
//
//  Created by i7colors on 2019/2/27.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "RankDetailVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import "UIView+Geometry.h"
#import "VoteModel.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>
#import <Masonry.h>
#import <WXApi.h>
#import "NavControllerSet.h"
#import "UIViewController+BarButton.h"

@interface RankDetailVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)VoteUserModel *dataSource;

@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UIImageView *medalImageView;
@property (nonatomic, strong)UILabel *bigRankLab;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *rankLabText;
@property (nonatomic, strong)UILabel *desTextLab;
@property (nonatomic, strong)YYLabel *totalVoteLab;
@property (nonatomic, strong)UILabel *numberLab;
@property (nonatomic, strong)UIButton *voteBtn;
@end

@implementation RankDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self.view addSubview:self.scrollView];
    [self setupUI];
    [self requestData];
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
//        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (void)setNavBar {
    self.title = _pageTitle;
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        [self addRightBarButtonItemWithTitle:@"分享" action:@selector(share)];
    }
}

- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if isRightData(_dataSource.pic) {
        [imageArray addObject:ImgStr(_dataSource.pic)];
    } else {
        [imageArray addObject:Logo];
    }
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/voteMessage.html?id=%@&mainId=%@",ShareString,_joinerID,_voteID];
    NSString *text = _dataSource.descriptionStr;
    [ClassTool shareSomething:imageArray urlStr:shareStr title:_pageTitle text:text];
}

- (void)setupUI {
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake((SCREEN_WIDTH - 92) / 2, 40, 92, 92);
    [_scrollView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //投票排名
    UILabel *bigRankLab = [[UILabel alloc] init];
    bigRankLab.textColor = HEXColor(@"#DAA520", 1);
    bigRankLab.font = [UIFont italicSystemFontOfSize:44];
    bigRankLab.frame = CGRectMake(20, headerImageView.bottom + 22, 20, 40);
    bigRankLab.hidden = YES;
    [_scrollView addSubview:bigRankLab];
    _bigRankLab = bigRankLab;
    
    UIImageView *medalImageView = [[UIImageView alloc] init];
    medalImageView.frame = CGRectMake(20, headerImageView.bottom + 24, 28, 36);
    medalImageView.hidden = YES;
    [_scrollView addSubview:medalImageView];
    _medalImageView = medalImageView;
    
    //名字
    CGFloat maxLabWidth = SCREEN_WIDTH - bigRankLab.right - 30;
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.frame = CGRectMake(bigRankLab.right + 15, bigRankLab.top + 2, maxLabWidth, 16);
    nameLab.font = [UIFont boldSystemFontOfSize:16];
//    nameLab.text = _dataSource.name;
    [_scrollView addSubview:nameLab];
    _nameLab = nameLab;
    
    //排名文字label
    UILabel *rankLabText = [[UILabel alloc] init];
    rankLabText.frame = CGRectMake(nameLab.left, nameLab.bottom + 2, nameLab.width, 14);
    rankLabText.bottom = bigRankLab.bottom - 2;
//    rankLabText.text = [NSString stringWithFormat:@"NO.%@ 当前排名第%@",_dataSource.sort,_dataSource.sort];
    rankLabText.font = [UIFont systemFontOfSize:14];
    rankLabText.textColor = HEXColor(@"#868686", 1);
    [_scrollView addSubview:rankLabText];
    _rankLabText = rankLabText;
    
    //描述文本
    CGFloat desMaxWidth = SCREEN_WIDTH - 40;
    UILabel *desTextLab = [[UILabel alloc] init];
//    desTextLab.text = _dataSource.descriptionStr;
    desTextLab.numberOfLines = 0;
    desTextLab.frame = CGRectMake(20, rankLabText.bottom + 32, desMaxWidth, 50);
    desTextLab.font = [UIFont systemFontOfSize:14];
    desTextLab.textColor = HEXColor(@"#868686", 1);
    [_scrollView addSubview:desTextLab];
    _desTextLab = desTextLab;
    
    //总票数
    CGFloat wd = (SCREEN_WIDTH - 80) / 2;
    
    YYLabel *totalVoteLab = [[YYLabel alloc] init];
    totalVoteLab.frame = CGRectMake(20, desTextLab.bottom + 60, wd, 20);
    [_scrollView addSubview:totalVoteLab];
    _totalVoteLab = totalVoteLab;
    
    
    //编号
    UILabel *numberLab = [[UILabel alloc] init];
//    numberLab.text = [NSString stringWithFormat:@"编号: %@",_dataSource.number];
    numberLab.frame = CGRectMake(totalVoteLab.right + 40, totalVoteLab.top, wd, totalVoteLab.height);
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.font = [UIFont systemFontOfSize:14];
    numberLab.textColor = HEXColor(@"#868686", 1);
    [_scrollView addSubview:numberLab];
    _numberLab = numberLab;
    
    
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, numberLab.bottom + 40);
    
    
    UIButton *voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    [voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [voteBtn addTarget:self action:@selector(startVote) forControlEvents:UIControlEventTouchUpInside];
    [ClassTool addLayer:voteBtn];
    [self.view addSubview:voteBtn];
    [voteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    _voteBtn = voteBtn;
}

- (void)setData {
    [_headerImageView sd_setImageWithURL:ImgUrl(_dataSource.pic) placeholderImage:PlaceHolderImg];
    
    if ([_dataSource.sort integerValue] < 4) {
        _medalImageView.hidden = NO;
        _bigRankLab.hidden = YES;
        _medalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tp_number%@",_dataSource.sort]];
        //名字
        CGFloat maxLabWidth = SCREEN_WIDTH - _medalImageView.right - 30;
        _nameLab.left = _medalImageView.right + 15;
        _nameLab.width = maxLabWidth;
    } else {
        CGFloat rankWidth = [_dataSource.sort boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName : [UIFont italicSystemFontOfSize:44]}
                                                           context:nil].size.width;
        _bigRankLab.width = rankWidth;
        _bigRankLab.text = _dataSource.sort;
        _medalImageView.hidden = YES;
        _bigRankLab.hidden = NO;
        //名字
        CGFloat maxLabWidth = SCREEN_WIDTH - _bigRankLab.right - 30;
        _nameLab.left = _bigRankLab.right + 15;
        _nameLab.width = maxLabWidth;
    }
    

    _nameLab.text = _dataSource.name;
    
    //排名
    _rankLabText.left = _nameLab.left;
    _rankLabText.width = _nameLab.width;
    _rankLabText.text = [NSString stringWithFormat:@"NO.%@ 当前排名第%@",_dataSource.sort,_dataSource.sort];
    
    //描述
    CGFloat desMaxWidth = SCREEN_WIDTH - 40;
    CGFloat desHeight = [_dataSource.descriptionStr boundingRectWithSize:CGSizeMake(desMaxWidth, CGFLOAT_MAX)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                                 context:nil].size.height;
    _desTextLab.height = desHeight;
    _desTextLab.text = _dataSource.descriptionStr;
    
    //总票数
    _totalVoteLab.top = _desTextLab.bottom + 60;
    NSString *totalNum = _dataSource.ticketNum;
    NSString *text = [NSString stringWithFormat:@"%@ 票",totalNum];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_color = HEXColor(@"#868686", 1);
    mutableText.yy_alignment = NSTextAlignmentCenter;
    mutableText.yy_font = [UIFont systemFontOfSize:14];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, _dataSource.ticketNum.length)];
    [mutableText yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(0, _dataSource.ticketNum.length)];
    _totalVoteLab.attributedText = mutableText;
    
    //编号
    _numberLab.top = _totalVoteLab.top;
    _numberLab.text = [NSString stringWithFormat:@"编号: %@",_dataSource.number];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _numberLab.bottom + 40);
    
    //已投票数，如果是0，显示投票按钮
    if ([_dataSource.joinedTicketNum isEqualToString:@"0"]) {
        [_voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    } else {
        [_voteBtn setTitle:[NSString stringWithFormat:@"已投%@票",_dataSource.joinedTicketNum ] forState:UIControlStateNormal];
    }
}

- (void)startVote {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    NSDictionary *dict = @{@"token":User_Token,
                           @"mainId":_voteID,
                           @"applicationId":_joinerID,
                           @"from":@"app_ios"
                           };
    DDWeakSelf;
    [ClassTool postRequest:URL_Vote_Start Params:[dict mutableCopy] Success:^(id json) {
        //               NSLog(@"-----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [weakself requestData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_refresh" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_home_add" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_header_add" object:nil];
        } else {
            [CddHUD showTextOnlyDelay:json[@"msg"] view:[[UIApplication sharedApplication].windows lastObject]];
        }
    } Failure:^(NSError *error) {
        
    }];
}




- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_Vote_Joiner_Detail,User_Token,_voteID, _joinerID];
    DDWeakSelf;
//    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [VoteUserModel mj_objectWithKeyValues:json[@"data"]];
            [weakself setData];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}


@end
