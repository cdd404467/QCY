//
//  CompanyApproveVC.m
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CompanyApproveVC.h"
#import "ClassTool.h"
#import "HomePageSectionHeader.h"
#import <YYText.h>
#import "HelperTool.h"
#import <HXPhotoPicker.h>
#import "CddHUD.h"
#import "NetWorkingPort.h"
#import "AES128.h"
#import <UIImageView+WebCache.h>


@interface CompanyApproveVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *companyTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UITextField *passwdAgainTF;
@property (nonatomic, strong)UIImageView *selectedImage;
@property (nonatomic, strong)HXPhotoManager *manager;
@property (nonatomic, assign)BOOL isSelPhoto;
@end

@implementation CompanyApproveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSelPhoto = NO;
    [self setNavBar];
    if ([_status isEqualToString:@"empty"]) {
        [self setupUI];
    } else if ([_status isEqualToString:@"wait_audit"]) {
        [self requestData];
    } else if ([_status isEqualToString:@"audit_fail"]) {
        [self requestData];
    }
    
}

- (void)setNavBar {
    self.title = @"企业认证";
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    [ClassTool addLayer:nav frame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundView:nav];
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    self.backBtnTintColor = UIColor.whiteColor;
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavBar];
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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = HEXColor(@"#f3f3f3", 1);
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

#pragma mark - 获取认证状态
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_CompanyCert_Detail,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [self setupUI];
            if ([json[@"data"] objectForKey:@"companyName"]) {
                self.companyTF.text = json[@"data"][@"companyName"];
            }
            if ([self.status isEqualToString:@"wait_audit"]) {
                [self.selectedImage sd_setImageWithURL:ImgUrl(json[@"data"][@"busLicenceUrl"])];
                self.passwdTF.text = @"000000";
                self.passwdAgainTF.text = @"000000";
            }
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];

    self.companyTF = [[UITextField alloc] init];
    self.companyTF.placeholder = @"请输入企业名称";
    [self.scrollView addSubview:self.companyTF];
    [self setTextField:self.companyTF];
    [_companyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(38);
        make.right.mas_equalTo(self.view.mas_right).offset(-38);
        make.height.mas_equalTo(47);
        make.top.mas_equalTo(20);
    }];
    
    self.passwdTF = [[UITextField alloc] init];
    self.passwdTF.placeholder = @"用于企业账号登陆的密码";
    self.passwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwdTF.secureTextEntry = YES;
    [self.scrollView addSubview:self.passwdTF];
    [self setTextField:self.passwdTF];
    [_passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.companyTF);
        make.top.mas_equalTo(self.companyTF.mas_bottom).offset(20);
    }];
    
    self.passwdAgainTF = [[UITextField alloc] init];
    self.passwdAgainTF.placeholder = @"请再次输入密码";
    self.passwdAgainTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwdAgainTF.secureTextEntry = YES;
    [self.scrollView addSubview:self.passwdAgainTF];
    [self setTextField:self.passwdAgainTF];
    [_passwdAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.passwdTF);
        make.top.mas_equalTo(self.passwdTF.mas_bottom).offset(20);
    }];
    
    //三合一
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"企业三证合一";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = HEXColor(@"#3C3C3C", 1);
    [self.scrollView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwdAgainTF.mas_bottom).offset(15);
        make.left.right.height.mas_equalTo(self.companyTF);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 8.f;
    bgView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.companyTF);
        make.top.mas_equalTo(lab.mas_bottom).offset(15);
        make.height.mas_equalTo(150);
    }];
    
    //上传照片
    UIImageView *selectedImage = [[UIImageView alloc] init];
    [HelperTool addTapGesture:selectedImage withTarget:self andSEL:@selector(selectedPhoto:)];
    selectedImage.image = [UIImage imageNamed:@"bigV_Selecte_Img"];
    selectedImage.contentMode = UIViewContentModeScaleAspectFit;
    selectedImage.backgroundColor = UIColor.whiteColor;
    selectedImage.layer.cornerRadius = 10;
    selectedImage.clipsToBounds = YES;
    [bgView addSubview:selectedImage];
    [selectedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.bottom.right.mas_equalTo(-20);
    }];
    _selectedImage = selectedImage;
    
    
    UIImageView *tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"danger_icon"]];
    [self.scrollView addSubview:tipImg];
    [tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView);
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(bgView.mas_bottom).offset(20);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"说明:申请的企业账户将会自动生产一个全新的账户，此账户的登录名为企业名称，在电脑端您也可以使用企业认证账户登录!";
    tipLab.textColor = HEXColor(@"#3C3C3C", 1);
    tipLab.numberOfLines = 0;
    tipLab.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipImg.mas_right).offset(20);
        make.right.mas_equalTo(bgView);
        make.top.mas_equalTo(tipImg);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.cornerRadius = 5.f;
    submitBtn.clipsToBounds = YES;
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = MainColor;
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bgView);
        make.top.mas_equalTo(tipLab.mas_bottom).offset(30);
        make.height.mas_equalTo(49);
    }];
    [submitBtn.superview layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, submitBtn.bottom + TABBAR_HEIGHT);
    
    
    if ([_status isEqualToString:@"wait_audit"]) {
        self.companyTF.textColor = HEXColor(@"#333333", 0.3);
        self.passwdTF.textColor = HEXColor(@"#333333", 0.3);
        self.passwdAgainTF.textColor = HEXColor(@"#333333", 0.3);
        submitBtn.backgroundColor = HEXColor(@"#cccccc", 1);
        
        self.companyTF.userInteractionEnabled = NO;
        self.passwdTF.userInteractionEnabled = NO;
        self.passwdAgainTF.userInteractionEnabled = NO;
        self.selectedImage.userInteractionEnabled = NO;
        submitBtn.userInteractionEnabled = NO;
    } else if ([_status isEqualToString:@"audit_fail"]) {
        self.companyTF.textColor = HEXColor(@"#333333", 0.3);
        self.companyTF.userInteractionEnabled = NO;
        [submitBtn addTarget:self action:@selector(reSubmitApply) forControlEvents:UIControlEventTouchUpInside];
    } else if ([_status isEqualToString:@"empty"]) {
        [submitBtn addTarget:self action:@selector(submitApply) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
                           @"companyName":_companyTF.text,
                           @"password":[AES128 AES128Encrypt:_passwdTF.text],
                           @"from":@"app_ios"
                           };
    
    [CddHUD show:self.view];
    [ClassTool uploadWithMutilFile:URLPost_Company_Cert Params:[dict mutableCopy] ImgsArray:imageArray Success:^(id json) {
        [CddHUD hideHUD:self.view];
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"提交成功,请耐心等待审核" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.refreshMyInfoBlock) {
                    self.refreshMyInfoBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        
    } Progress:nil];
    
}

//重新提交审核
- (void)reSubmitApply {
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
                               @"id":_infoID,
                               @"companyName":_companyTF.text,
                               @"password":[AES128 AES128Encrypt:_passwdTF.text],
                               @"companyId": _companyId,
                               @"from":@"app_ios"
                               };
        
        [CddHUD show:self.view];
        [ClassTool uploadWithMutilFile:URLPost_Compan_ResetCert Params:[dict mutableCopy] ImgsArray:imageArray Success:^(id json) {
            [CddHUD hideHUD:self.view];
                    NSLog(@"---- %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                [CddHUD showTextOnlyDelay:@"提交成功,请耐心等待审核" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.refreshMyInfoBlock) {
                        self.refreshMyInfoBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } Failure:^(NSError *error) {
            
        } Progress:nil];
}


- (void)selectedPhoto:(UIButton *)sender {
    [self.view endEditing:YES];
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

//设置textfield
- (void)setTextField:(UITextField *)tf {
    tf.textColor = UIColor.blackColor;
    tf.backgroundColor = UIColor.whiteColor;
    tf.layer.cornerRadius = 5.f;
    //添加leftView
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    leftView.contentMode = UIViewContentModeCenter;
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.font = [UIFont systemFontOfSize:15];
}

- (BOOL)judgeData {
    if (_companyTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入企业名称" view:self.view];
        return NO;
    } else if (_passwdTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入密码" view:self.view];
        return NO;
    } else if (_passwdAgainTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请再次输入密码" view:self.view];
        return NO;
    } else if([self isEmpty:_passwdTF.text]) {
        [CddHUD showTextOnlyDelay:@"密码不能包含空格" view:self.view];
        return NO;
    } else if(_passwdTF.text.length < 6 || _passwdTF.text.length > 16) {
        [CddHUD showTextOnlyDelay:@"密码长度为6-16位" view:self.view];
        return NO;
    } else if (![_passwdTF.text isEqualToString:_passwdAgainTF.text]) {
        [CddHUD showTextOnlyDelay:@"两次输入的密码不一致" view:self.view];
        return NO;
    } else if (_isSelPhoto == NO) {
        [CddHUD showTextOnlyDelay:@"请上传凭证" view:self.view];
        return NO;
    }
    
    return YES;
}

//检测是否能包含空格
- (BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }
    return NO; //反之
}

//修改statesBar颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
