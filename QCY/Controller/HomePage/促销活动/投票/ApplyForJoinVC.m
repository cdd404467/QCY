//
//  ApplyForJoinVC.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ApplyForJoinVC.h"
#import <YNPageTableView.h>
#import "MacroHeader.h"
#import <Masonry.h>
#import "UIView+Geometry.h"
#import "ClassTool.h"
#import "UITextField+Limit.h"
#import "SelectedView.h"
#import <BRPickerView.h>
#import "HelperTool.h"
#import "UITextView+Placeholder.h"
#import "VoteModel.h"
#import "CddHUD.h"
#import "MobilePhone.h"
#import "NetWorkingPort.h"
#import "YYImageClipViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "Alert.h"

@interface ApplyForJoinVC ()<UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YYImageClipDelegate>
@property (nonatomic, strong)ApplyJoinModel *dataSource;
@property (nonatomic, strong)UIButton *submitBtn;
@end

@implementation ApplyForJoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[ApplyJoinModel alloc] init];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49 + Bottom_Height_Dif)];
        //提交按钮
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(applyJoin) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateDisabled];
        
        [bottomView addSubview:submitBtn];
        if ([_endCode isEqualToString:@"2"]) {
            submitBtn.enabled = NO;
            submitBtn.backgroundColor = HEXColor(@"#CCCCCC", 1);
        } else {
            submitBtn.enabled = YES;
            [ClassTool addLayer:submitBtn];
        }
        _submitBtn = submitBtn;
        _tableView.tableFooterView = bottomView;
    }
    return _tableView;
}

//判断联系人的数据有没有填写
- (BOOL)judgeRight {
    if (_dataSource.joinerTF_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入参与者全称" view:self.view];
        return NO;
    } else if (_dataSource.phoneTF_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return NO;
    } else if (![MobilePhone isValidMobile:_dataSource.phoneTF_data]) {
        [CddHUD showTextOnlyDelay:@"请输入正确的手机号" view:self.view];
        return NO;
    } else if (_dataSource.areaSelect_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请选择所在城市" view:self.view];
        return NO;
    } else if (_dataSource.isSelectPhoto == NO) {
        [CddHUD showTextOnlyDelay:@"请上传照片" view:self.view];
        return NO;
    } else if (_dataSource.detail_data.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入描述简介" view:self.view];
        return NO;
    }
    
    return YES;
}

- (void)applyJoin {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    if ([self judgeRight] == NO) {
        return;
    }
    _submitBtn.enabled = NO;
    FormData *data = [[FormData alloc]init];
    data.fileData = UIImageJPEGRepresentation(_dataSource.headerImage, 0.1);
    data.name = @"file";
    data.fileName = @"1.jpg";
    data.fileType = @"image/jpeg";
    NSArray *areaArray = [_dataSource.areaSelect_data componentsSeparatedByString:@"-"];
   
    NSDictionary *dict = @{@"token":User_Token,
                           @"mainId":_voteID,
                           @"phone":_dataSource.phoneTF_data,
                           @"name":_dataSource.joinerTF_data,
                           @"province":areaArray[0],
                           @"city":areaArray[1],
                           @"description":_dataSource.detail_data,
                           @"from":@"app_ios"
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool uploadFile:URL_Apply_JoinVote Params:[dict mutableCopy] DataSource:data Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"-------p  %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSString *str = [NSString stringWithFormat:@"参与成功,你的编号为:%@",json[@"data"]];
            [CddHUD showTextOnlyDelay:str view:weakself.view delay:2.5f];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_refresh" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_home_refresh" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_header_refresh" object:nil];
            weakself.dataSource = [[ApplyJoinModel alloc] init];
            [weakself.tableView reloadData];
            weakself.submitBtn.enabled = YES;
        }
        
    } Failure:^(NSError *error) {
        NSLog(@"Error:  %@",error);
    } Progress:nil];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 415;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyForJoinCell *cell = [ApplyForJoinCell cellWithTableView:tableView];
    cell.model = _dataSource;
    DDWeakSelf;
    cell.addImageBlock = ^{
        [weakself selectedPhoto];
    };
    
    return cell;
    
}


- (void)selectedPhoto {
    //    DDWeakSelf;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            //            if(![self authorWithType:0]) return;
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    [alertVc addAction:takePhotoAction];
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self isPhotoLibraryAvailable]) {
            //            if(![self authorWithType:1]) return;
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:nil];
        }
        
    }];
    [alertVc addAction:imagePickerAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    _headerImage.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    _dataSource.isSelectPhoto = YES;
    _dataSource.headerImage = editedImage;
    [_tableView reloadData];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

/**
 权限是否开启
 
 @param type 0相机,1相册
 @return 权限开启YES,否则NO
 */
-(BOOL)authorWithType:(NSInteger)type
{
    //权限
    if ([PHPhotoLibrary authorizationStatus] == 0 || [PHPhotoLibrary authorizationStatus] == 2) {
        NSString *photoType = type==0?@"相机":@"相册";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        
        [Alert alertOne:title okBtn:cancelTitle msg:msg OKCallBack:^{
            
        }];
        
        return NO;
    }
    return YES;
}

/*** 检测是否可以访问相机相册 ***/

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


@end

@interface ApplyForJoinCell()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong)UITextField *joinerTF;
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)SelectedView *areaSelect;
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UITextView *textView;
@end

@implementation ApplyForJoinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //for循环创建
    NSArray *titleArr = @[@"参与者:",@"联系方式:",@"地区:",@"图片:",@"描述简介:"];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            if (i == 4) {
                make.top.mas_equalTo(20 * (i + 1) + 32 * i + (90 - 32));
            } else {
                make.top.mas_equalTo(20 * (i + 1) + 32 * i);
            }
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(32);
        }];
        
        UIImageView *tabIcon = [[UIImageView alloc] init];
        tabIcon.image = [UIImage imageNamed:@"tab_icon"];
        [self.contentView  addSubview:tabIcon];
        [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel);
            make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
            make.width.height.mas_equalTo(4);
        }];
    }
    
    //参与者
    UITextField *joinerTF = [[UITextField alloc] init];
    joinerTF.frame = CGRectMake(100, 20, SCREEN_WIDTH - 100 - 10, 32);
    joinerTF.backgroundColor = HEXColor(@"#f5f5f5", 1);
    joinerTF.font = [UIFont systemFontOfSize:12];
    joinerTF.textColor = HEXColor(@"#1E2226", 1);
    joinerTF.leftViewMode = UITextFieldViewModeAlways;
    joinerTF.placeholder = @"请输入全称";
    joinerTF.layer.borderWidth = 1.f;
    joinerTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    joinerTF.delegate = self;
    [joinerTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    joinerTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self.contentView addSubview:joinerTF];
    //限制字数
    _joinerTF = joinerTF;
    
    //联系方式
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.frame = CGRectMake(joinerTF.left, joinerTF.bottom + 20, joinerTF.width, 32);
    phoneTF.backgroundColor = HEXColor(@"#f5f5f5", 1);
    phoneTF.font = [UIFont systemFontOfSize:12];
    phoneTF.textColor = HEXColor(@"#1E2226", 1);
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.placeholder = @"请输入联系人手机号";
    phoneTF.layer.borderWidth = 1.f;
    [phoneTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    phoneTF.delegate = self;
    phoneTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self.contentView addSubview:phoneTF];
    //限制字数
    [phoneTF lengthLimit:^{
        if (phoneTF.text.length > 11) {
            phoneTF.text = [phoneTF.text substringToIndex:11];
        }
    }];
    _phoneTF = phoneTF;
    
    //区域
    SelectedView *areaSelect = [[SelectedView alloc] initWithFrame:CGRectMake(phoneTF.left, phoneTF.bottom + 20, phoneTF.width,  32)];
    [HelperTool addTapGesture:areaSelect withTarget:self andSEL:@selector(showPickView_area)];
    areaSelect.layer.cornerRadius = 3.f;
    [self.contentView addSubview:areaSelect];
    _areaSelect = areaSelect;
    
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(areaSelect.left, areaSelect.bottom + 20, 90, 90);
    [HelperTool addTapGesture:headerImageView withTarget:self andSEL:@selector(addImageClick)];
    headerImageView.layer.borderWidth = .8f;
    headerImageView.layer.borderColor = HEXColor(@"#E8E8E8", 1).CGColor;
    [self.contentView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //描述
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(headerImageView.left, headerImageView.bottom + 20, joinerTF.width,  80)];
    textView.backgroundColor = HEXColor(@"#f5f5f5", 1);
    textView.placeholder = @"请输入简介";
    textView.delegate = self;
    textView.placeholderColor = HEXColor(@"#868686", 1);
    textView.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:textView];
    _textView = textView;
    
}

- (void)setModel:(ApplyJoinModel *)model {
    _model = model;
    
    _joinerTF.text = model.joinerTF_data;
    _phoneTF.text = model.phoneTF_data;
    if (model.areaSelect_data.length == 0) {
        _areaSelect.textLabel.text = @"请选择区域";
    } else {
        _areaSelect.textLabel.text = model.areaSelect_data;
    }
    _headerImageView.image = model.headerImage;
    _textView.text = model.detail_data;
}

- (void)addImageClick {
    if (self.addImageBlock) {
        self.addImageBlock();
    }
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    if (tf == _joinerTF) {
        _model.joinerTF_data = tf.text;
    } else if (tf == _phoneTF) {
        _model.phoneTF_data = tf.text;
    }
}

//地址选择
- (void)showPickView_area {
    [self endEditing:YES];
    DDWeakSelf;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        NSString *areaStr = [NSString stringWithFormat:@"%@-%@", province.name, city.name];
        weakself.areaSelect.textLabel.text = areaStr;
        weakself.model.areaSelect_data = areaStr;
    } cancelBlock:^{
        //        NSLog(@"点击了背景视图或取消按钮");
    }];
}

//textView输入监听
- (void)textViewDidChange:(UITextView *)textView
{
    _model.detail_data = textView.text;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ApplyForJoinCell";
    ApplyForJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ApplyForJoinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
