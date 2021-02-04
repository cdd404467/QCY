//
//  BigVCertVC.m
//  QCY
//
//  Created by i7colors on 2018/12/9.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BigVCertVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "HXPhotoPicker.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HelperTool.h"
#import <YYText.h>
#import "CddHUD.h"
#import "NavControllerSet.h"


@interface BigVCertVC ()<HXPhotoViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *nameTF;
@property (nonatomic, strong)UITextField *companyNameTF;
@property (nonatomic, strong)UITextField *jobNameTF;
@property (nonatomic, strong)HXPhotoManager *manager;
@property (nonatomic, strong)UIImageView *selectedImage;
@property (nonatomic, assign)BOOL isSelPhoto;
@end

@implementation BigVCertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大V认证";
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundColor:Like_Color];
    _isSelPhoto = NO;
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.singleSelected = YES;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.requestImageAfterFinishingSelection = YES;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    }
    
    return _manager;
}

#pragma mark - 提交
- (void)submitApply {
    if ([self judgeData] == NO) {
        return ;
    };
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    FormData *formData = [[FormData alloc] init];
    formData.fileData = UIImageJPEGRepresentation(_selectedImage.image,0.1);
    formData.name = @"file";
    formData.fileName = @"1.png";
    formData.fileType = @"image/png";
    [imageArray addObject:formData];
    NSDictionary *dict = @{@"token":User_Token,
                           @"name":_nameTF.text,
                           @"companyName":_companyNameTF.text,
                           @"job":_jobNameTF.text,
                           @"from":@"app_ios"
                           };
    
    [CddHUD show:self.view];
    DDWeakSelf;
    [ClassTool uploadWithMutilFile:URL_BigV_Cert Params:[dict mutableCopy] ImgsArray:imageArray Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        [CddHUD showTextOnlyDelay:@"提交成功,请耐心等待审核" view:weakself.view];
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.refreshMyInfoBlock) {
                    weakself.refreshMyInfoBlock();
                }
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        
    } Progress:nil];
    
}


- (void)selectedPhoto:(UIButton *)sender {
    DDWeakSelf;
    if (self.manager.configuration.requestImageAfterFinishingSelection) {
        [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        
            if (photoList.count > 0) {
                HXPhotoModel *model = allList.firstObject;
                [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
                    weakself.selectedImage.image = image;
                    weakself.isSelPhoto = YES;
                } failed:^(NSDictionary *info, HXPhotoModel *model) {
                    
                }];
            } else {
                weakself.isSelPhoto = NO;
            }
        } cancel:nil];
    }
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    //姓名
    //for循环创建
    CGFloat rightViewHeight = 32;
    CGFloat gap = 20;
    NSArray *titleArr = @[@"姓名:",@"公司名称:",@"个人职务:", @"上传凭证"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo((i + 1) * gap + i * rightViewHeight);
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(rightViewHeight);
        }];
        
        UIImageView *tabIcon = [[UIImageView alloc] init];
        tabIcon.image = [UIImage imageNamed:@"tab_icon"];
        [_scrollView addSubview:tabIcon];
        [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel);
            make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
            make.width.height.mas_equalTo(4);
        }];
    }
    
    UITextField *nameTF = [[UITextField alloc] init];
    nameTF.frame = CGRectMake(KFit_W(100), gap, SCREEN_WIDTH - KFit_W(100) - 10, rightViewHeight);
    [_scrollView addSubview:nameTF];
    _nameTF = nameTF;
    [self setTextField:_nameTF];
    
    //公司名字
    UITextField *companyNameTF = [[UITextField alloc] init];
    companyNameTF.frame = CGRectMake(nameTF.left, nameTF.bottom + gap, nameTF.width, nameTF.height);
    [_scrollView addSubview:companyNameTF];
    _companyNameTF = companyNameTF;
    [self setTextField:_companyNameTF];
    
    //个人职务
    UITextField *jobNameTF = [[UITextField alloc] init];
    jobNameTF.frame = CGRectMake(nameTF.left, companyNameTF.bottom + gap, nameTF.width, nameTF.height);
    [_scrollView addSubview:jobNameTF];
    _jobNameTF = jobNameTF;
    [self setTextField:_jobNameTF];
    
    //上传照片
    UIImageView *selectedImage = [[UIImageView alloc] init];
    [HelperTool addTapGesture:selectedImage withTarget:self andSEL:@selector(selectedPhoto:)];
    selectedImage.image = [UIImage imageNamed:@"bigV_Selecte_Img"];
    selectedImage.contentMode = UIViewContentModeScaleAspectFit;
    selectedImage.backgroundColor = HEXColor(@"#F5F5F5", 1);
    selectedImage.layer.cornerRadius = 10;
    selectedImage.clipsToBounds = YES;
    selectedImage.frame = CGRectMake(KFit_W(17), jobNameTF.bottom + gap + rightViewHeight, SCREEN_WIDTH - KFit_W(17) * 2, KFit_W(152));
    [_scrollView addSubview:selectedImage];
    _selectedImage = selectedImage;
    
    YYLabel *tipLabel = [[YYLabel alloc] init];
    tipLabel.numberOfLines = 0;
    tipLabel.frame = CGRectMake(selectedImage.left, selectedImage.bottom + 20, selectedImage.width, 0);
    [_scrollView addSubview:tipLabel];
    
    NSString *text = @"1.上传您的职业身份证、名片、工牌等任一材料。\n2.请确保照片的内容完整并清晰可见。\n3.请上传彩色图像。";
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    mText.yy_color = HEXColor(@"#3C3C3C", 1);
    mText.yy_font = [UIFont systemFontOfSize:12];
    mText.yy_lineSpacing = 5;
    tipLabel.attributedText = mText;
    CGSize introSize = CGSizeMake(selectedImage.width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mText];
    tipLabel.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    tipLabel.height = introHeight;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, tipLabel.bottom + TABBAR_HEIGHT);
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitApply) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:submitBtn];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_nameTF]) {
        tf.placeholder = @"请输入姓名";
    } else if ([tf isEqual:_companyNameTF]) {
        tf.placeholder = @"请输入公司名称";
    } else {
        tf.placeholder = @"请输入个人职务名称";
    }
    tf.backgroundColor = HEXColor(@"#E8E8E8", 1);
    tf.font = [UIFont systemFontOfSize:12];
    tf.textColor = HEXColor(@"#1E2226", 1);
    tf.layer.borderWidth = 1.f;
    tf.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    //添加leftView
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 30)];
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
}

- (BOOL)judgeData {
    if (_nameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入姓名" view:self.view];
        return NO;
    } else if (_companyNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入公司名称" view:self.view];
        return NO;
    } else if (_jobNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入个人职务名称" view:self.view];
        return NO;
    } else if (_isSelPhoto == NO) {
        [CddHUD showTextOnlyDelay:@"请上传凭证" view:self.view];
        return NO;
    }
    
    return YES;
}

@end
