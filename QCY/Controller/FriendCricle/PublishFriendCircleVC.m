//
//  PublishFriendCircleVC.m
//  QCY
//
//  Created by i7colors on 2018/12/3.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PublishFriendCircleVC.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <TZImagePickerController.h>
#import "ClassTool.h"
#import "CddHUD.h"
#import "NetWorkingPort.h"
#import <HXPhotoPicker.h>
#import "HelperTool.h"
#import "UIView+Geometry.h"
#import "UITextView+Placeholder.h"


#define LeftGap 35
#define PhotoViewWidth SCREEN_WIDTH - LeftGap * 2
#define ImageWidth (PhotoViewWidth - 10) / 3
#define MaxCount 9
#define DeleteBtnHeight 70
#define AnimationTime 0.4

@interface PublishFriendCircleVC ()<UITextViewDelegate, HXPhotoViewDelegate ,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *bottomView;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *videoArray;
@property (nonatomic, strong)HXPhotoManager *manager;
@property (nonatomic, strong)HXPhotoView *photoView;
@property (nonatomic, strong)HXDatePhotoToolManager *toolManager;
@property (nonatomic, assign)BOOL needDeleteItem;
@property (nonatomic, strong)NSMutableArray *infoArray;
@end

@implementation PublishFriendCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.navTitle = @"发表动态";
    [self.navBar.leftBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self setupUI];
}


- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0 && _photoArray.count == 0 && _videoArray.count == 0) {
        _publishBtn.enabled = NO;
    } else {
        _publishBtn.enabled = YES;
    }
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

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        NSMutableArray<NSString *> *textArr = [NSMutableArray arrayWithObjects:@"#话题名称#",@"你的位置",@"关联咨询",@"谁可以看",@"提醒谁看", nil];
        NSMutableArray<NSString *> *subTextArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"公开",@"", nil];
        NSMutableArray<NSMutableArray *> *array = [NSMutableArray arrayWithObjects:textArr,subTextArr, nil];
        _infoArray = array;
    }
    return _infoArray;
}


- (UIButton *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        [_bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView setBackgroundColor:[UIColor redColor]];
        _bottomView.alpha = 0.5;
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, DeleteBtnHeight);
    }
    return _bottomView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.videoMaxDuration = 16.f;
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

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGBA(204, 204, 204, 1);
//        _tableView.separatorColor = UIColor.redColor;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 150, 0, 0);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];

    }
    return _tableView;
}

#pragma mark - 发布朋友圈
- (void)publishFriendCircle {
    [_textView resignFirstResponder];
    NSString *type = [NSString string];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if (_photoArray.count > 0) {
        for (int i = 0; i < _photoArray.count; i++) {
            FormData *formData = [[FormData alloc] init];
            formData.fileData = UIImageJPEGRepresentation(_photoArray[i],0.2);
            formData.name = @"files";
            formData.fileName = @"1.png";
            formData.fileType = @"image/png";
            [imageArray addObject:formData];
        }
    }
    
    if (_videoArray.count > 0) {
        FormData *formData = [[FormData alloc] init];
//        NSURL *mp4URL = [HelperTool convertToMp4:_videoArray[0]];
        NSData *videoData = [NSData dataWithContentsOfURL:_videoArray[0]];
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
                           @"content":_textView.text,
                           @"from":@"app_ios"
                           };
    
    [CddHUD show:self.view];
    DDWeakSelf;
    _publishBtn.userInteractionEnabled = NO;
    [ClassTool uploadWithMutilFile:URL_Publish_FriendCircle Params:[dict mutableCopy] ImgsArray:imageArray Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if (weakself.publishComoletedBlock) {
                weakself.publishComoletedBlock();
            }
            [weakself exit];
        }
        weakself.publishBtn.userInteractionEnabled = YES;
    } Failure:^(NSError *error) {
        weakself.publishBtn.userInteractionEnabled = YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSelector:@selector(delectCellColor:) withObject:nil afterDelay:0.0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *imageArr = @[@"pf_icon_1",@"pf_icon_2",@"pf_icon_3",@"pf_icon_4",@"pf_icon_5"];
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    };
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.infoArray[0][indexPath.row];
    cell.detailTextLabel.text = self.infoArray[1][indexPath.row];

    return cell;
}



#pragma mark - 照片代理方法

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    DDWeakSelf;
    if (_textView.text.length == 0 && allList.count == 0) {
        _publishBtn.enabled = NO;
    } else {
        _publishBtn.enabled = YES;
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
    [UIView animateWithDuration:AnimationTime animations:^{
        self.bottomView.bottom = SCREEN_HEIGHT;
    }];
}
//长按手势改变了
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self.view];
    DDWeakSelf;
    if (point.y >= self.bottomView.hx_y) {
        [UIView animateWithDuration:AnimationTime animations:^{
            weakself.bottomView.alpha = 0.8;
             [weakself.bottomView setTitle:@"松手即可删除" forState:UIControlStateNormal];
        }];
    }else {
        [UIView animateWithDuration:AnimationTime animations:^{
            self.bottomView.alpha = 0.5;
            [weakself.bottomView setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        }];
    }
}
//长按手势结束了
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self.view];
    if (point.y >= self.bottomView.hx_y) {
        self.needDeleteItem = YES;
        [self.photoView deleteModelWithIndex:indexPath.item];
    }else {
        self.needDeleteItem = NO;
    }

    DDWeakSelf;
    [UIView animateWithDuration:AnimationTime animations:^{
         self.bottomView.bottom = SCREEN_HEIGHT + self.bottomView.height;
         weakself.bottomView.alpha = 0.5;
    }];
}

- (void)setupUI {
//    //取消按钮
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//        make.top.mas_equalTo(NAV_HEIGHT - 44);
//        make.width.mas_equalTo(50);
//    }];
//    _cancelBtn = cancelBtn;
//
//    //发布按钮
//    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [publishBtn setTitle:@"发表" forState:UIControlStateNormal];
//    publishBtn.enabled = NO;
//    [publishBtn setTitleColor:MainColor forState:UIControlStateNormal];
//    [publishBtn addTarget:self action:@selector(publishFriendCircle) forControlEvents:UIControlEventTouchUpInside];
//    [publishBtn setTitleColor:HEXColor(@"#ef3673", 0.5) forState:UIControlStateDisabled];
//    [self.view addSubview:publishBtn];
//    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.height.width.top.mas_equalTo(cancelBtn);
//    }];
//    _publishBtn = publishBtn;
    
    //输入框
//    UITextView *textView = [[UITextView alloc] init];
//    textView.placeholder = @"这一刻的想法...";
//    textView.enablesReturnKeyAutomatically = YES;
//    textView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
//    textView.textColor = [UIColor blackColor];
//    textView.delegate = self;
//    [textView becomeFirstResponder];
//    [self.view addSubview:textView];
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(25);
//        make.top.mas_equalTo(NAV_HEIGHT + 20);
//        make.height.mas_equalTo(40);
//        make.right.mas_equalTo(-30);
//    }];
//    _textView = textView;
//
//    //照片背景view
//    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
//    photoView.spacing = 5.f;
//    photoView.delegate = self;
//    photoView.outerCamera = YES;
//    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
//    photoView.previewShowDeleteButton = YES;
//    photoView.hideDeleteButton = YES;
//    photoView.showAddCell = YES;
//    //    photoView.disableaInteractiveTransition = YES;
//    [photoView.collectionView reloadData];
//    photoView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:photoView];
//    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(textView.mas_bottom).offset(40);
//        make.left.mas_equalTo(LeftGap);
//        make.right.mas_equalTo(-LeftGap);
//        make.height.mas_equalTo(0);
//    }];
//    _photoView = photoView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}


- (void)exit {
    [_textView resignFirstResponder];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@interface PublishHeaderView()


@end

@implementation PublishHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    
    
}

@end

