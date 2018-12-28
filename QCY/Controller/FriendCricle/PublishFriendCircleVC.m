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

@interface PublishFriendCircleVC ()<UITextViewDelegate, HXPhotoViewDelegate>
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *bottomView;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *videoArray;
@property (nonatomic, strong)HXPhotoManager *manager;
@property (nonatomic, strong)HXPhotoView *photoView;
@property (nonatomic, strong)HXDatePhotoToolManager *toolManager;
@property (nonatomic, assign)BOOL needDeleteItem;
@end

@implementation PublishFriendCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UINavigationBar appearance].translucent = NO;
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

- (UIButton *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        [_bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView setBackgroundColor:[UIColor redColor]];
//        _bottomView.frame = CGRectMake(0, self.view.hx_h - 50, self.view.hx_w, 50);
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
        _manager.configuration.videoMaxDuration = 15.f;
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

#pragma mark - 发布朋友圈
- (void)publishFriendCircle {
    [_textView resignFirstResponder];
    NSString *type = [NSString string];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if (_photoArray.count > 0) {
        for (int i = 0; i < _photoArray.count; i++) {
            FormData *formData = [[FormData alloc] init];
            formData.fileData = UIImageJPEGRepresentation(_photoArray[i],0.1);
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
                           @"content":_textView.text
                           };
    
    [CddHUD show:self.view];
    DDWeakSelf;
    _publishBtn.userInteractionEnabled = NO;
    [ClassTool uploadWithMutilFile:URL_Publish_FriendCircle Params:[dict mutableCopy] ImgsArray:imageArray Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if (weakself.refreshFCBlock) {
                weakself.refreshFCBlock();
            }
            [weakself exit];
        }
        weakself.publishBtn.userInteractionEnabled = YES;
    } Failure:^(NSError *error) {
        weakself.publishBtn.userInteractionEnabled = YES;
    } Progress:nil];
}

#pragma mark - 照片代理方法

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    DDWeakSelf;
//    if (allList.count > 0) {
//        _publishBtn.enabled = YES;
//    } else {
//        _publishBtn.enabled = NO;
//    }
    
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

- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
//    [UIView animateWithDuration:0.25 animations:^{
//        self.bottomView.alpha = 0.5;
//    }];
    
    [UIView animateWithDuration:AnimationTime animations:^{
        self.bottomView.bottom = SCREEN_HEIGHT;
    }];
//    NSSLog(@"长按手势开始了 - %ld",indexPath.item);
}

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
//    NSSLog(@"长按手势改变了 %@ - %ld",NSStringFromCGPoint(point), indexPath.item);
}

- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    CGPoint point = [longPgr locationInView:self.view];
    if (point.y >= self.bottomView.hx_y) {
        self.needDeleteItem = YES;
        [self.photoView deleteModelWithIndex:indexPath.item];
    }else {
        self.needDeleteItem = NO;
    }
//    NSSLog(@"长按手势结束了 - %ld",indexPath.item);
//    [UIView animateWithDuration:0.25 animations:^{
//        self.bottomView.alpha = 0;
//    }];
    DDWeakSelf;
    [UIView animateWithDuration:AnimationTime animations:^{
         self.bottomView.bottom = SCREEN_HEIGHT + self.bottomView.height;
         weakself.bottomView.alpha = 0.5;
    }];
}

- (void)setupUI {
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(NAV_HEIGHT - 44);
        make.width.mas_equalTo(50);
    }];
    _cancelBtn = cancelBtn;
    
    //发布按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [publishBtn setTitle:@"发表" forState:UIControlStateNormal];
    publishBtn.enabled = NO;
    [publishBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishFriendCircle) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:HEXColor(@"#ef3673", 0.5) forState:UIControlStateDisabled];
    [self.view addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.width.top.mas_equalTo(cancelBtn);
    }];
    _publishBtn = publishBtn;
    
    //输入框
    UITextView *textView = [[UITextView alloc] init];
    textView.placeholder = @"写点什么...";
    textView.enablesReturnKeyAutomatically = YES;
    textView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    textView.textColor = [UIColor blackColor];
    textView.delegate = self;
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(cancelBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-30);
    }];
    _textView = textView;
    
    //照片背景view
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.spacing = 5.f;
    photoView.delegate = self;
    photoView.outerCamera = YES;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.previewShowDeleteButton = YES;
    photoView.hideDeleteButton = YES;
    photoView.showAddCell = YES;
    //    photoView.disableaInteractiveTransition = YES;
    [photoView.collectionView reloadData];
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(40);
        make.left.mas_equalTo(LeftGap);
        make.right.mas_equalTo(-LeftGap);
        make.height.mas_equalTo(0);
    }];
    _photoView = photoView;
    
    [self.view addSubview:self.bottomView];
    
}


- (void)exit {
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
