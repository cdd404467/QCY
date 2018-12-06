//
//  ChangeHeaderVC.m
//  QCY
//
//  Created by i7colors on 2018/11/12.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ChangeHeaderVC.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import <UIImageView+WebCache.h>
#import "YYImageClipViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Alert.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import <Photos/Photos.h>

@interface ChangeHeaderVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,YYImageClipDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong)UIImageView *headerImage;
@end

@implementation ChangeHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXColor(@"#333333", 1);
    [self setNavBar];
    [self setupUI];
}

- (void)setNavBar {
    self.nav.titleLabel.text = @"用户头像";
    self.nav.titleLabel.textColor = [UIColor whiteColor];
    [self.nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self.nav.rightBtn addTarget:self action:@selector(selectedPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.nav.rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    self.nav.bottomLine.hidden = YES;
    [ClassTool addLayer:self.nav frame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
}

- (void)setupUI {
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.backgroundColor = [UIColor whiteColor];
    headerImage.frame = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.view addSubview:headerImage];
    _headerImage = headerImage;
    
    if (Get_Header) {
        NSURL *url = [NSURL URLWithString:Get_Header];
        [headerImage sd_setImageWithURL:url placeholderImage:nil];
    } else {
        headerImage.image = [UIImage imageNamed:@"default_750"];
    }
}

#pragma mark - 上传图片

//上传图片
- (void)uploadHeaderImage {
    
    FormData *data = [[FormData alloc]init];
    data.fileData = UIImageJPEGRepresentation(_headerImage.image, 0.1);
    data.name = @"file";
    data.fileName = @"1.jpg";
    data.fileType = @"image/jpeg";

    NSDictionary *dict = @{@"token":User_Token
                        };
    
    DDWeakSelf;
    [CddHUD showTextOnly:@"正在上传头像..." view:self.view];
    [ClassTool uploadFile:URL_Upload_Header Params:[dict mutableCopy] DataSource:data Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"-------  %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            
            //取出用户信息的字典
            NSMutableDictionary *userDict = [[UserDefault objectForKey:@"userInfo"] mutableCopy];
            //改变头像信息
            [userDict setObject:json[@"data"] forKey:@"userHeaderImage"];
            //改变后再次存入UserDefault
            [UserDefault setObject:userDict forKey:@"userInfo"];
            NSString *notiName1 = @"changeHeader";
            [[NSNotificationCenter defaultCenter]postNotificationName:notiName1 object:nil userInfo:@{@"cHeader":json[@"data"]}];
            
            [CddHUD showTextOnlyDelay:@"头像上传成功" view:weakself.view];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@"Error:  %@",error);
    } Progress:nil];
    
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
    _headerImage.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    [self uploadHeaderImage];
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

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
