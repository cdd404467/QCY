//
//  PublishFriendCircleVC.m
//  QCY
//
//  Created by i7colors on 2018/12/3.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PublishFriendCircleVC.h"
#import <TZImagePickerController.h>
#import "ClassTool.h"
#import "CddHUD.h"
#import "NetWorkingPort.h"
#import <HXPhotoPicker.h>
#import "HelperTool.h"
#import "UITextView+Placeholder.h"
#import "IndustryInformationVC.h"
#import "BaseNavigationController.h"
#import "InfomationModel.h"
#import <UIImageView+WebCache.h>
#import "SelectedAddressVC.h"
#import "POIAnnotationModel.h"
#import "SelectedTopicVC.h"
#import "FriendCricleModel.h"
#import "WhoCanSeeVC.h"
#import "FriendContactBookVC.h"

#define LeftGap 35
#define ViewGap 25
#define PhotoViewWidth SCREEN_WIDTH - LeftGap * 2
#define ImageWidth (PhotoViewWidth - 10) / 3
#define MaxCount 9
#define DeleteBtnHeight 70 + Bottom_Height_Dif
#define DeleteAnimationTime 0.4
#define TVOriginHeight 60.f
#define AnimaTime 0.3f

@interface PublishFriendCircleVC ()<UITextViewDelegate, HXPhotoViewDelegate ,UITableViewDelegate, UITableViewDataSource,FriendCircleDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL needDeleteItem;
@property (nonatomic, strong)NSMutableArray *infoArray;
@property (nonatomic, strong)PublishHeaderView *tbHeader;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, strong)NSIndexPath *selectedAddressIndexPath; //本次选择的是那个indexPath
@property (nonatomic, strong)POIAnnotationModel *selectedModel;

/*** 判断发布时是否选择了一些附加信息的字段  ***/
@property (nonatomic, assign)BOOL isHasTopic;               //是否选择话题
@property (nonatomic, assign)BOOL isHasLocation;            //是否选择位置
@property (nonatomic, assign)BOOL isHasZixun;               //是否选择咨询
@property (nonatomic, assign)BOOL isHasPermission;          //是否设置让谁看
@property (nonatomic, assign)BOOL isHasTiXing;              //是否提醒谁

@property (nonatomic, copy)NSString *topicID;
@property (nonatomic, copy)NSString *topicParentID;
@property (nonatomic, strong)POIAnnotationModel *locModel;
@property (nonatomic, copy)NSString *lon;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *locTitle;
@property (nonatomic, copy)NSString *locAddress;
@property (nonatomic, copy)NSString *zixunID;
@property (nonatomic, assign)NSInteger permission;    //权限 - 0:t公开 1:好友 2:指定好友
@property (nonatomic, strong)NSMutableArray<FriendCricleInfoModel *> *selectArray;
@property (nonatomic, strong)NSMutableArray<FriendCricleInfoModel *> *remindSelectArray;
@property (nonatomic, copy)NSString *userIDs;
@property (nonatomic, copy)NSString *userNames;

@property (nonatomic, copy)NSString *remindUserIDs;
@property (nonatomic, copy)NSString *remindUserNames;
@end

@implementation PublishFriendCircleVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isHasTopic = NO;
        self.isHasLocation = NO;
        self.isHasZixun = NO;
        self.isHasPermission = NO;
        self.isHasTiXing = NO;
        self.permission = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化当前选中的indexPath
    self.selectedAddressIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    self.selectedModel = nil;
    self.navBar.navTitle = @"发表动态";
    self.navBar.bottomLine.hidden = YES;
    [self.navBar.leftBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightBtn addTarget:self action:@selector(publishFriendCircle) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightBtn setTitle:@"发表" forState:UIControlStateNormal];
    self.navBar.rightBtn.enabled = NO;
    [self.view addSubview:self.tableView];
    if (_shareZinXunModel)
        [self selectZiXunWithModel:_shareZinXunModel];
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}

- (NSMutableArray *)remindSelectArray {
    if (!_remindSelectArray) {
        _remindSelectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _remindSelectArray;
}

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        NSMutableArray<NSString *> *textArr = [NSMutableArray arrayWithObjects:@"选择话题",@"你的位置",@"关联资讯",@"提醒谁看",@"谁可以看", nil];
        NSMutableArray<NSString *> *subTextArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"公开", nil];
        NSMutableArray<NSString *> *imageArr = [NSMutableArray arrayWithObjects:@"pf_icon_1",@"pf_icon_2",@"pf_icon_3",@"pf_icon_4",@"pf_icon_5", nil];
        UIColor *color = UIColor.blackColor;
        UIColor *subColor = UIColor.grayColor;
        NSMutableArray<UIColor *> *fontColorArr = [NSMutableArray arrayWithObjects:color,color,color,color,color, nil];
        NSMutableArray<UIColor *> *subFontColorArr = [NSMutableArray arrayWithObjects:subColor,subColor,subColor,subColor,subColor, nil];
        NSMutableArray<NSMutableArray *> *array = [NSMutableArray arrayWithObjects:textArr,subTextArr, imageArr, fontColorArr, subFontColorArr, nil];
        _infoArray = array;
    }
    return _infoArray;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGBA(204, 204, 204, 1);

        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
        PublishHeaderView *tbHeader = [[PublishHeaderView alloc] initWithFrame:frame];
        DDWeakSelf;
        tbHeader.deleteZXViewBlock = ^{
            [weakself.infoArray[0] replaceObjectAtIndex:2 withObject:@"关联咨询"];
            [weakself.infoArray[2] replaceObjectAtIndex:2 withObject:@"pf_icon_3"];
            [weakself.infoArray[3] replaceObjectAtIndex:2 withObject:UIColor.blackColor];
            weakself.isHasZixun = NO;
        };
        self.delegate = tbHeader;
        tbHeader.headerChangeDelegate = self;
        _tableView.tableHeaderView = tbHeader;
        
        _tbHeader = tbHeader;
    }
    return _tableView;
}

#pragma mark - 发布朋友圈
- (void)publishFriendCircle {
    [_tbHeader.textView resignFirstResponder];
    
    NSString *type = [NSString string];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if (_tbHeader.photoArray.count > 0) {
        for (int i = 0; i < _tbHeader.photoArray.count; i++) {
            FormData *formData = [[FormData alloc] init];
            formData.fileData = UIImageJPEGRepresentation(_tbHeader.photoArray[i],0.2);
            formData.name = @"files";
            formData.fileName = @"1.png";
            formData.fileType = @"image/png";
            [imageArray addObject:formData];
        }
    }

    if (_tbHeader.videoArray.count > 0) {
        FormData *formData = [[FormData alloc] init];
        NSData *videoData = [NSData dataWithContentsOfURL:_tbHeader.videoArray[0]];
        formData.fileData = videoData;
        formData.name = @"file";
        formData.fileName = @"1.mp4";
        formData.fileType = @"video/mp4";
        [imageArray addObject:formData];
        type = @"video";
    } else {
        type = @"photo";
    }
    
    NSDictionary *dict = @{@"token":User_Token,
                           @"type":type,
                           @"content":[_tbHeader.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                           @"from":@"app_ios",
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
    /*** 二期新加可选 ***/
    //话题
    if (_isHasTopic == YES)
        [mDict setObject:_topicID forKey:@"level2TopicId"];
    //定位
    if (_isHasLocation == YES) {
        [mDict setObject:_lon forKey:@"longitude"];
        [mDict setObject:_lat forKey:@"latitude"];
        [mDict setObject:_locTitle forKey:@"locationTitle"];
        [mDict setObject:_locAddress forKey:@"locationAddress"];
    }
    //选择咨询
    if (_isHasZixun == YES) {
        [mDict setObject:_zixunID forKey:@"shareId"];
        [mDict setObject:@"info" forKey:@"shareType"];
    }
    //指定可见权限
    if (_isHasPermission == YES) {
        [mDict setObject:_permission == 1 ? @"all" : @"notAll" forKey:@"appointType"];
        if (_permission == 3) {
            [mDict setObject:self.userIDs forKey:@"appointUserId"];
        }
    }
    //提醒谁看
    if (_isHasTiXing == YES)
        [mDict setObject:self.remindUserIDs forKey:@"noticeUserId"];
    
    
    [CddHUD show:self.view];
    DDWeakSelf;
    self.navBar.rightBtn.userInteractionEnabled = NO;
    [ClassTool uploadWithMutilFile:URL_Publish_FriendCircle Params:mDict ImgsArray:imageArray Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //全部，必须刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAllDataWithThisno" object:nil];
            if (weakself.isHasTopic == YES) {
                NSString *postName = [NSString stringWithFormat:@"refreshAllDataWithThis%@",weakself.topicParentID];
                [[NSNotificationCenter defaultCenter] postNotificationName:postName object:nil];
            }
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }
        weakself.navBar.rightBtn.userInteractionEnabled = YES;
    } Failure:^(NSError *error) {
        weakself.navBar.rightBtn.userInteractionEnabled = YES;
    } Progress:^(float percent) {
    }];
}

#pragma mark - tableView代理方法
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, LeftGap, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, LeftGap, 0, 0)];
    }
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self withTopic];
            break;
        case 1:
            [self withCurrentAddress];
            break;
        case 2:
            [self withZixun];
            break;
        case 3:
            [self withRemindWhoSee];
            break;
        case 4:
            [self withWhoCanSee];
            break;
        default:
            break;
    }
}

#pragma mark - 添加话题、位置、关联咨询、谁可以看、提醒谁看的操作
#pragma mark 选择话题
- (void)withTopic {
    SelectedTopicVC *vc = [[SelectedTopicVC alloc] init];
    DDWeakSelf;
    vc.selectTopicBlock = ^(FriendTopicModel * _Nonnull topicModel) {
        [weakself.infoArray[0] replaceObjectAtIndex:0 withObject:topicModel.title];
        [weakself.infoArray[2] replaceObjectAtIndex:0 withObject:@"pf_icon_11"];
        [weakself.infoArray[3] replaceObjectAtIndex:0 withObject:MainColor];
        weakself.isHasTopic = YES;
        weakself.topicID = topicModel.secondTopicID;
        weakself.topicParentID = topicModel.parentId;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark 显示位置
- (void)withCurrentAddress {
    SelectedAddressVC *vc = [[SelectedAddressVC alloc] init];
    vc.city = _city;
    vc.lastPath = self.selectedAddressIndexPath;
    vc.selectedModel = self.selectedModel;
    DDWeakSelf;
    vc.selectedAddressBlock = ^(POIAnnotationModel * _Nonnull model, NSString * _Nonnull city, NSIndexPath * _Nonnull indexPath, double lon, double lat) {
        weakself.city = city;
        if ([[city substringFromIndex:city.length - 1] isEqualToString:@"市"])
            city = [city substringToIndex:city.length - 1];
        weakself.selectedAddressIndexPath = indexPath;
        weakself.selectedModel = model;
        if (model) {
            [weakself.infoArray[0] replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ · %@",city,model.title]];
            [weakself.infoArray[2] replaceObjectAtIndex:1 withObject:@"pf_icon_22"];
            [weakself.infoArray[3] replaceObjectAtIndex:1 withObject:MainColor];
            weakself.isHasLocation = YES;
            weakself.lon = @(model.coordinate.longitude).stringValue;
            weakself.lat = @(model.coordinate.latitude).stringValue;
            weakself.locTitle = [NSString stringWithFormat:@"%@ · %@",city,model.title];
            weakself.locAddress = model.subtitle;
        } else {
            //不显示位置
            if (indexPath.row == 0) {
                [weakself.infoArray[0] replaceObjectAtIndex:1 withObject:@"你的位置"];
                [weakself.infoArray[2] replaceObjectAtIndex:1 withObject:@"pf_icon_2"];
                [weakself.infoArray[3] replaceObjectAtIndex:1 withObject:UIColor.blackColor];
                weakself.isHasLocation = NO;
                //就显示城市
            } else {
                [weakself.infoArray[0] replaceObjectAtIndex:1 withObject:city];
                [weakself.infoArray[2] replaceObjectAtIndex:1 withObject:@"pf_icon_22"];
                [weakself.infoArray[3] replaceObjectAtIndex:1 withObject:MainColor];
                weakself.isHasLocation = YES;
                weakself.lon = @(lon).stringValue;
                weakself.lat = @(lat).stringValue;
                weakself.locTitle = city;
                weakself.locAddress = city;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark 关联咨询
- (void)withZixun {
    IndustryInformationVC *vc = [[IndustryInformationVC alloc] init];
    vc.fromPage = @"pfPage";
    DDWeakSelf;
    vc.selectedZXBlock = ^(InfomationModel * _Nonnull model) {
        [weakself selectZiXunWithModel:model];
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)selectZiXunWithModel:(InfomationModel *)model {
    if ([self.delegate respondsToSelector:@selector(getZiXundata:)]) {
        [self.delegate getZiXundata:model];
    }
    [self.infoArray[0] replaceObjectAtIndex:2 withObject:model.title];
    [self.infoArray[2] replaceObjectAtIndex:2 withObject:@"pf_icon_33"];
    [self.infoArray[3] replaceObjectAtIndex:2 withObject:MainColor];
    self.isHasZixun = YES;
    self.zixunID = model.infoID;
}

#pragma mark 谁可以看
- (void)withWhoCanSee {
    WhoCanSeeVC *vc = [[WhoCanSeeVC alloc] init];
    vc.permission = self.permission;
    vc.selectArray = self.selectArray;
    vc.userNames = self.userNames;
    DDWeakSelf;
    vc.selectePermissionBlock = ^(NSInteger permissionCode, NSMutableArray<FriendCricleInfoModel *> * _Nonnull selectArray) {
        weakself.selectArray = selectArray;
        weakself.permission = permissionCode;
        if (permissionCode == 0) {
            [weakself.infoArray[1] replaceObjectAtIndex:4 withObject:@"公开"];
            [weakself.infoArray[2] replaceObjectAtIndex:4 withObject:@"pf_icon_5"];
            [weakself.infoArray[3] replaceObjectAtIndex:4 withObject:UIColor.blackColor];
            [weakself.infoArray[4] replaceObjectAtIndex:4 withObject:UIColor.grayColor];
            weakself.isHasPermission = NO;
        } else {
            weakself.isHasPermission = YES;
            [weakself.infoArray[2] replaceObjectAtIndex:4 withObject:@"pf_icon_55"];
            [weakself.infoArray[3] replaceObjectAtIndex:4 withObject:MainColor];
            [weakself.infoArray[4] replaceObjectAtIndex:4 withObject:MainColor];
            if (permissionCode == 1) {
                [weakself.infoArray[1] replaceObjectAtIndex:4 withObject:@"全部好友可见"];
            }  else {
                NSMutableArray *tempNameArr = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *tempIDArr = [NSMutableArray arrayWithCapacity:0];
                for (FriendCricleInfoModel *model in selectArray) {
                    [tempNameArr addObject:model.userNickName];
                    [tempIDArr addObject:model.userId];
                }
                NSString *tempStr = [tempNameArr componentsJoinedByString:@","];
                [weakself.infoArray[1] replaceObjectAtIndex:4 withObject:tempStr];
                
                weakself.userIDs = [tempIDArr componentsJoinedByString:@","];
                weakself.userNames = tempStr;
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark 提醒谁看
- (void)withRemindWhoSee {
    FriendContactBookVC *vc = [[FriendContactBookVC alloc] init];
    vc.selectArray = self.remindSelectArray;
    DDWeakSelf;
    vc.selectedCompleteBlock = ^(NSMutableArray<FriendCricleInfoModel *> * _Nonnull selectArray) {
        weakself.remindSelectArray = selectArray;
        weakself.isHasTiXing = selectArray.count == 0 ? NO : YES;
        if (selectArray.count > 0) {
            NSMutableArray *tempNameArr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *tempIDArr = [NSMutableArray arrayWithCapacity:0];
            for (FriendCricleInfoModel *model in selectArray) {
                [tempNameArr addObject:model.userNickName];
                [tempIDArr addObject:model.userId];
            }
            NSString *tempStr = [tempNameArr componentsJoinedByString:@","];
            weakself.remindUserIDs = [tempIDArr componentsJoinedByString:@","];
            weakself.remindUserNames = tempStr;
            [weakself.infoArray[1] replaceObjectAtIndex:3 withObject:tempStr];
            [weakself.infoArray[2] replaceObjectAtIndex:3 withObject:@"pf_icon_44"];
            [weakself.infoArray[3] replaceObjectAtIndex:3 withObject:MainColor];
            [weakself.infoArray[4] replaceObjectAtIndex:3 withObject:MainColor];
        } else {
            [weakself.infoArray[1] replaceObjectAtIndex:3 withObject:@""];
            [weakself.infoArray[2] replaceObjectAtIndex:3 withObject:@"pf_icon_4"];
            [weakself.infoArray[3] replaceObjectAtIndex:3 withObject:UIColor.blackColor];
            [weakself.infoArray[4] replaceObjectAtIndex:3 withObject:UIColor.grayColor];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    };
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.infoArray[0][indexPath.row];
    cell.detailTextLabel.text = self.infoArray[1][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.infoArray[2][indexPath.row]];
    cell.textLabel.textColor = self.infoArray[3][indexPath.row];
    cell.detailTextLabel.textColor = self.infoArray[4][indexPath.row];
    
    return cell;
}


//tableView的headerView高度变化时调用
- (void)tableViewHeaderHasChanged:(CGFloat)height {
//    _tbHeader.height = height;
    DDWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView reloadData];
    });
}

//按钮状态
- (void)fcPublishBtnState:(BOOL)state {
    self.navBar.rightBtn.enabled = state;
}

- (void)exit {
    [_tbHeader.textView resignFirstResponder];
}

@end



/***  发布朋友圈的tableView头部 ***/
@interface PublishHeaderView()<UITextViewDelegate, HXPhotoViewDelegate,FriendCircleDelegate>
@property (nonatomic, strong)HXPhotoManager *manager;
@property (nonatomic, strong)HXPhotoView *photoView;
@property (nonatomic, strong)ZiXunView *zixunView;
@property (nonatomic, strong)HXDatePhotoToolManager *toolManager;
@property (nonatomic, strong)UIButton *bottomView;
@property (nonatomic, assign)BOOL needDeleteItem;
@end

@implementation PublishHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        _photoArray = array;
    }
    return _photoArray;
}

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        _videoArray = array;
    }
    return _videoArray;
}

//底部删除View
- (UIButton *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        [_bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView setBackgroundColor:HEXColor(@"#B22222", 1)];
        _bottomView.titleLabel.font = [UIFont systemFontOfSize:18];
        _bottomView.alpha = 0.75;
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, DeleteBtnHeight);
        
    }
    return _bottomView;
}

//咨询view
- (ZiXunView *)zixunView {
    if (!_zixunView) {
        _zixunView = [[ZiXunView alloc] init];
        DDWeakSelf;
        _zixunView.deleteZXViewBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.zixunView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [weakself.zixunView removeFromSuperview];
                weakself.height = weakself.photoView.bottom + ViewGap;
                if (weakself.height < 300) {
                    weakself.height = 300;
                }
                weakself.zixunView = nil;
                //判断发布按钮是否可点击
                NSString *text = [weakself.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (text.length == 0 && weakself.photoArray.count == 0 && weakself.videoArray.count == 0 ) {
                    if ([weakself.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
                        [weakself.headerChangeDelegate fcPublishBtnState:NO];
                    }
                } else {
                    if ([weakself.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
                        [weakself.headerChangeDelegate fcPublishBtnState:YES];
                    }
                }
            });
            //改变头部高度
            if ([weakself.headerChangeDelegate respondsToSelector:@selector(tableViewHeaderHasChanged:)]) {
                [weakself.headerChangeDelegate tableViewHeaderHasChanged:weakself.height];
            }
            //点击删除咨询
            if (weakself.deleteZXViewBlock) {
                weakself.deleteZXViewBlock();
            }
        };
        _zixunView.layer.shadowColor = RGBA(0, 0, 0, 0.5).CGColor;
        _zixunView.layer.shadowOffset = CGSizeMake(0, 3);
        _zixunView.layer.shadowOpacity = .5f;
        _zixunView.frame = CGRectMake(LeftGap, _photoView.bottom + ViewGap, _photoView.width, 100);
    }
    
    return _zixunView;
}


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.videoMaximumSelectDuration = 16.f;
        _manager.configuration.videoMaximumDuration = 14.f;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showDateSectionHeader = NO;
        //视频和照片不能同时选择
        _manager.configuration.selectTogether = NO;
        _manager.configuration.requestImageAfterFinishingSelection = YES;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    }
    
    return _manager;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (void)setupUI {
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(LeftGap - 5, 20, SCREEN_WIDTH - LeftGap * 2 + 10, TVOriginHeight);
    textView.placeholder = @"这一刻的想法...";
    textView.enablesReturnKeyAutomatically = YES;
    textView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    textView.textColor = [UIColor blackColor];
    textView.delegate = self;
    textView.tintColor = MainColor;
    textView.scrollEnabled = NO;
//    textView.backgroundColor = UIColor.grayColor;
    [textView becomeFirstResponder];
    [self addSubview:textView];
    _textView = textView;
    
    //照片背景view
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(LeftGap, textView.bottom + ViewGap, textView.width - 10, (textView.width - 10) / 3);
    photoView.spacing = 5.f;
    photoView.delegate = self;
    photoView.outerCamera = YES;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.previewShowDeleteButton = YES;
    photoView.hideDeleteButton = YES;
    photoView.showAddCell = YES;
    [photoView.collectionView reloadData];
    photoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:photoView];
    _photoView = photoView;
}

#pragma mark - 照片代理方法

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    DDWeakSelf;
    if (_textView.text.length == 0 && allList.count == 0 && !_zixunView) {
        if ([weakself.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
            [weakself.headerChangeDelegate fcPublishBtnState:NO];
        }
    } else {
        if ([weakself.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
            [weakself.headerChangeDelegate fcPublishBtnState:YES];
        }
    }
    
    [weakself.photoArray removeAllObjects];
    [weakself.videoArray removeAllObjects];
    if (photos.count > 0) {
        [weakself.toolManager getSelectedImageList:photos success:^(NSArray<UIImage *> *imageList) {
            for (UIImage *image in imageList) {
                [weakself.photoArray addObject:image];
            }
        } failed:nil];
    }
    if (videos.count > 0) {
        [weakself.toolManager writeSelectModelListToTempPathWithList:videos success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            //            [HelperTool yasuoVideoNewUrl:videoURL[0]];
            [weakself.videoArray addObject:[HelperTool yasuoVideoNewUrl:videoURL.firstObject]];
        } failed:^{
            NSSLog(@"写入失败");
        }];
    }
}

#pragma mark - 手势删除
- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView gestureRecognizer:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    return self.needDeleteItem;
}
//长按手势开始了
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    [UIApplication.sharedApplication.keyWindow addSubview:self.bottomView];
    [UIView animateWithDuration:DeleteAnimationTime animations:^{
        self.bottomView.bottom = SCREEN_HEIGHT;
    }];
}
//长按手势改变了
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
//    CGPoint point = [longPgr locationInView:self.view];
    CGPoint point = [longPgr locationInView:UIApplication.sharedApplication.keyWindow];
    DDWeakSelf;
    if (point.y >= self.bottomView.hx_y) {
        [UIView animateWithDuration:DeleteAnimationTime animations:^{
            weakself.bottomView.alpha = 0.85;
            [weakself.bottomView setTitle:@"松手即可删除" forState:UIControlStateNormal];
            weakself.bottomView.titleLabel.font = [UIFont systemFontOfSize:22];
        }];
    }else {
        [UIView animateWithDuration:DeleteAnimationTime animations:^{
            self.bottomView.alpha = 0.75;
            [weakself.bottomView setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
            weakself.bottomView.titleLabel.font = [UIFont systemFontOfSize:18];
        }];
    }
}
//长按手势结束了
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:UIApplication.sharedApplication.keyWindow];
    if (point.y >= self.bottomView.hx_y) {
        self.needDeleteItem = YES;
        [self.photoView deleteModelWithIndex:indexPath.item];
    }else {
        self.needDeleteItem = NO;
    }
    
    DDWeakSelf;
    [UIView animateWithDuration:DeleteAnimationTime animations:^{
        weakself.bottomView.bottom = SCREEN_HEIGHT + self.bottomView.height;
        weakself.bottomView.alpha = 0.75;
    } completion:^(BOOL finished) {
        [weakself.bottomView removeFromSuperview];
        weakself.bottomView = nil;
    }];
}

//当view高度改变时调用
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    CGFloat height = self.textView.bottom + ViewGap + frame.size.height + ViewGap;
    if (_zixunView) {
        DDWeakSelf;
        [UIView animateWithDuration:AnimaTime animations:^{
            weakself.zixunView.top = height;
        }];
        height = height + self.zixunView.height + 20;
    }
    
    self.height = height;
    if (self.height < 300) {
        self.height = 300;
    }
    //改变头部高度
    if ([self.headerChangeDelegate respondsToSelector:@selector(tableViewHeaderHasChanged:)]) {
        [self.headerChangeDelegate tableViewHeaderHasChanged:height];
    }
}

//选择关联咨询时会调用
- (void)getZiXundata:(InfomationModel *)model {
    self.height = self.photoView.bottom + ViewGap + 100 + ViewGap;
    if (self.height < 300) {
        self.height = 300;
    }
    
    //创建关联咨询的view
    [self addSubview:self.zixunView];
    
    self.zixunView.model = model;
    
    //选择关联咨询后，改变头部高度
    if ([self.headerChangeDelegate respondsToSelector:@selector(tableViewHeaderHasChanged:)]) {
        [self.headerChangeDelegate tableViewHeaderHasChanged:self.height];
    }
    
    //判断发布按钮是否可点击
    NSString *text = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0 && _photoArray.count == 0 && _videoArray.count == 0 && !_zixunView) {
        if ([self.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
            [self.headerChangeDelegate fcPublishBtnState:NO];
        }
    } else {
        if ([self.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
            [self.headerChangeDelegate fcPublishBtnState:YES];
        }
    }
}

//textView监听，高度改变====
- (void)textViewDidChange:(UITextView *)textView {
    static CGFloat maxHeight = 150.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (size.height > maxHeight) {
        size.height = maxHeight;
        textView.scrollEnabled = YES;  // 允许滚动
    } else if (size.height < TVOriginHeight) {
        size.height = TVOriginHeight;
        textView.scrollEnabled = NO;    // 不允许滚动
    }
    //textView位置改变
    [UIView animateWithDuration:AnimaTime animations:^{
        textView.height = size.height;
    }];
    
    DDWeakSelf;
    //photo位置改变
    [UIView animateWithDuration:AnimaTime animations:^{
        weakself.photoView.top = weakself.textView.bottom + ViewGap;
    }];
    
    //如果有咨询的view。位置改变
    CGFloat headerHeight;
    CGFloat zixunTop = weakself.textView.bottom + ViewGap + weakself.photoView.height + ViewGap;
    if (_zixunView) {
        [UIView animateWithDuration:AnimaTime animations:^{
            weakself.zixunView.top = zixunTop;
        }];
        headerHeight = zixunTop + self.zixunView.height + 20;
    } else {
        headerHeight = zixunTop;
    }
    
    self.height = headerHeight;
    if (self.height < 300) {
        self.height = 300;
    }
    //改变头部高度
    if ([self.headerChangeDelegate respondsToSelector:@selector(tableViewHeaderHasChanged:)]) {
        [self.headerChangeDelegate tableViewHeaderHasChanged:self.height];
    }
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0 && _photoArray.count == 0 && _videoArray.count == 0 && !_zixunView) {
        if ([weakself.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
            [weakself.headerChangeDelegate fcPublishBtnState:NO];
        }
    } else {
        if ([weakself.headerChangeDelegate respondsToSelector:@selector(fcPublishBtnState:)]) {
            [weakself.headerChangeDelegate fcPublishBtnState:YES];
        }
    }
}



@end

@interface ZiXunView()

@end

@implementation ZiXunView {
    UIImageView *_headerImageView;
    UILabel *_bigTitle;
    UILabel *_someText;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.backgroundColor = HEXColor(@"#f3f3f3", 1);
    [self addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    _headerImageView = headerImageView;
    
    UILabel *bigTitle = [[UILabel alloc] init];
    bigTitle.font = [UIFont boldSystemFontOfSize:15];
    bigTitle.numberOfLines = 2;
    [self addSubview:bigTitle];
    [bigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(8);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    _bigTitle = bigTitle;
    
    //部分文本
    UILabel *someText = [[UILabel alloc] init];
    someText.numberOfLines = 2;
    someText.font = [UIFont systemFontOfSize:12];
    someText.textColor = HEXColor(@"#868686", 1);
    [self addSubview:someText];
    [someText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bigTitle);
        make.top.mas_equalTo(bigTitle.mas_bottom).offset(5);
    }];
    _someText = someText;
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteZX) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(50);
    }];
}

- (void)setModel:(InfomationModel *)model {
    _model = model;
    [_headerImageView sd_setImageWithURL:ImgUrl(model.img_url) placeholderImage:PlaceHolderImg];
    _bigTitle.text = model.title;
    _someText.text = model.content_summary;
}

- (void)deleteZX {
    if (self.deleteZXViewBlock) {
        self.deleteZXViewBlock();
    }
}
@end
