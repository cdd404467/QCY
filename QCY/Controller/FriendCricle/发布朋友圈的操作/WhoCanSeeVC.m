//
//  WhoCanSeeVC.m
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "WhoCanSeeVC.h"
#import "NavControllerSet.h"
#import "BEMCheckBox.h"
#import "HelperTool.h"
#import "FriendContactBookVC.h"
#import "FriendCricleModel.h"

@interface WhoCanSeeVC ()<BEMCheckBoxDelegate>
@property (nonatomic, strong)BEMCheckBox *publicBox;
@property (nonatomic, strong)BEMCheckBox *friendBox;
@property (nonatomic, strong)BEMCheckBox *orderBox;
@property (nonatomic, strong)UIView *friendDisplayView;
@property (nonatomic, strong)UILabel *friendDisplayLab;
@property (nonatomic, strong)UIView *friendDisplayLine;
@property (nonatomic, strong)BEMCheckBoxGroup *boxGroup;
@property (nonatomic, copy)NSString *userIDs;
@end

@implementation WhoCanSeeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"谁可以看";
    [self.rightNavBtn addTarget:self action:@selector(selectComplete) forControlEvents:UIControlEventTouchUpInside];
    [self setupUI];
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}

- (void)setupUI {
    CGFloat height = 65;
    self.boxGroup = [[BEMCheckBoxGroup alloc] init];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height * i + NAV_HEIGHT, SCREEN_WIDTH, height)];
        view.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:view];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.7, view.width, 0.7)];
        line.backgroundColor = LineColor;
        [view addSubview:line];
        
        if (i != 2) {
            BEMCheckBox *box = [[BEMCheckBox alloc] initWithFrame:CGRectMake(25, 20, 25, 25)];
            box.tag = 100 + i;
            [self setCheckBox:box];
            [view addSubview:box];
            [self.boxGroup addCheckBoxToGroup:box];
            if (i == 0)
                self.publicBox = box;
            if (i == 1)
                self.friendBox = box;
            if (i == 3)
                self.orderBox = box;

        }
        
        if (i != 3) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, SCREEN_WIDTH - 75,15)];
            title.font = [UIFont systemFontOfSize:15];
            [view addSubview:title];
            UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(75, title.bottom + 5, title.width,15)];
            subTitle.font = [UIFont systemFontOfSize:12];
            subTitle.textColor = HEXColor(@"#868686", 1);
            [view addSubview:subTitle];
            
            if (i == 2) {
                title.left = 25;
                subTitle.left = 25;
            }
            
            if (i == 0) {
                title.text = @"公开";
                subTitle.text = @"所有人可见";
            }
            
            if (i == 1) {
                title.text = @"好友";
                subTitle.text = @"好友可见,指相互关注的人";
            }
            
            if (i == 2) {
                title.text = @"指定部分好友可见";
                subTitle.text = @"选择好友";
            }
        }
        
        if (i == 2) {
            _friendDisplayLine = line;
            UIImageView *rightImg = [[UIImageView alloc] init];
            rightImg.image = [UIImage imageNamed:@"arrow_right"];
            [view addSubview:rightImg];
            [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-24);
                make.width.mas_equalTo(7);
                make.height.mas_equalTo(12);
                make.centerY.mas_equalTo(view);
            }];
            [HelperTool addTapGesture:view withTarget:self andSEL:@selector(jumpToSelect)];
        }
        
        if (i == 3) {
            self.friendDisplayView = view;
            _friendDisplayLab = [[UILabel alloc] init];
            _friendDisplayLab.numberOfLines = 2;
            _friendDisplayLab.font = [UIFont systemFontOfSize:12];
            _friendDisplayLab.textColor = HEXColor(@"#868686", 1);
            [view addSubview:_friendDisplayLab];
            [_friendDisplayLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(75);
                make.right.mas_equalTo(-20);
                make.height.mas_equalTo(60);
                make.centerY.mas_equalTo(view);
            }];
            
            view.hidden = self.selectArray.count == 0 ? YES : NO;
            _friendDisplayLine.left = self.selectArray.count == 0 ? 0 : 75;
            _friendDisplayLab.text = self.userNames;
        }
        
    }
    self.boxGroup.selectedCheckBox = (BEMCheckBox *)[self.view viewWithTag:(self.permission + 100)];
    self.boxGroup.mustHaveSelection = YES;
}

- (void)jumpToSelect {
    FriendContactBookVC *vc = [[FriendContactBookVC alloc] init];
    vc.selectArray = self.selectArray;
    DDWeakSelf;
    vc.selectedCompleteBlock = ^(NSMutableArray * _Nonnull selectArray) {
        weakself.selectArray = selectArray;
        if (selectArray.count > 0) {
            NSMutableArray *tempNameArr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *tempIDArr = [NSMutableArray arrayWithCapacity:0];
            for (FriendCricleInfoModel *model in selectArray) {
                [tempNameArr addObject:model.userNickName];
                [tempIDArr addObject:model.userId];
            }
            weakself.userNames = [tempNameArr componentsJoinedByString:@","];
            weakself.userIDs = [tempIDArr componentsJoinedByString:@","];
            //显示view
            weakself.friendDisplayView.hidden = NO;
            weakself.friendDisplayLab.text = weakself.userNames;
            weakself.boxGroup.selectedCheckBox = weakself.orderBox;
            weakself.friendDisplayLine.left = 75;
        } else {
            weakself.friendDisplayView.hidden = YES;
            weakself.friendDisplayLab.text = @"";
            weakself.friendDisplayLine.left = 0;
            weakself.boxGroup.selectedCheckBox = self.publicBox;
        }
        
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)selectComplete {
    if (self.selectePermissionBlock) {
        self.selectePermissionBlock(self.boxGroup.selectedCheckBox.tag - 100, self.selectArray);
    }
}

- (BEMCheckBox *)setCheckBox:(BEMCheckBox *)box {
    box.boxType = BEMBoxTypeSquare;
    box.onAnimationType = BEMAnimationTypeBounce;
    box.offAnimationType = BEMAnimationTypeBounce;
    box.onCheckColor = [UIColor whiteColor];
    box.onTintColor = HEXColor(@"#F10215", 1);
    box.onFillColor = HEXColor(@"#F10215", 1);
    box.lineWidth = 1.f;
    
    return box;
}

@end


