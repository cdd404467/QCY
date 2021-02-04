//
//  CheckForBusinessVC.m
//  QCY
//
//  Created by i7colors on 2019/4/4.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CheckForBusinessVC.h"
#import "SMSCodeView.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "UIDevice+UUID.h"
#import "CddHUD.h"
#import <YYWebImage.h>
#import "NavControllerSet.h"
#import "HelperTool.h"
#import "Alert.h"
#import <IQKeyboardManager.h>

#define MaxSCale 2.0  //最大缩放比例
#define MinScale 1.0  //最小缩放比例

@interface CheckForBusinessVC ()
@property (nonatomic, strong)UIImageView *codeImageView;
@property (nonatomic, strong)SMSCodeView *codeView;
@property (nonatomic, strong)UIView *bgTwo;
@property (nonatomic,assign) CGFloat totalScale;
@property (nonatomic, assign)CGRect oldframe;
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation CheckForBusinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网店经营者营业执照信息";
    self.totalScale = 1.0;
    [self requestImageCode];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

// 添加所有的手势
- (void)addGestureRecognizerToView:(UIView *)view
{
    [view setUserInteractionEnabled:YES];
    [view setMultipleTouchEnabled:YES];
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
    
    //点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverImageView)];
    [view addGestureRecognizer:tap];
}


// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CGFloat scale = pinchGestureRecognizer.scale;
    //放大情况
    if(scale > 1.0){
        if(self.totalScale > MaxSCale) return;
    }
    //缩小情况
    if (scale < 1.0) {
        if (self.totalScale < MinScale) return;
    }
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        self.totalScale *= scale;
    }
}

 - (void)recoverImageView{
    //恢复
     DDWeakSelf;
    [UIView animateWithDuration:0.4 animations:^{
        [weakself.imageView setFrame:weakself.oldframe];
    } completion:^(BOOL finished) {
        weakself.totalScale = 1.0;
    }];
}


- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgOne = [[UIView alloc] init];
    bgOne.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    [self.view addSubview:bgOne];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat height = SCREEN_HEIGHT - NAV_HEIGHT - Bottom_Height_Dif;
    imageView.frame = CGRectMake(0, 0, height / 3.422, height);
    [bgOne addSubview:imageView];
    imageView.centerX = bgOne.centerX;
    [imageView yy_setImageWithURL:ImgUrl(_imgUrl) placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        image = [image yy_imageByRotateRight90];
        return image;
    } completion:nil];
    [self addGestureRecognizerToView:imageView];
    _imageView = imageView;
    self.oldframe = imageView.frame;
    
    UIView *bgTwo = [[UIView alloc] init];
    bgTwo.backgroundColor = UIColor.whiteColor;
    bgTwo.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    [self.view addSubview:bgTwo];
    _bgTwo = bgTwo;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"七彩云网店\n经营者营业执照信息";
    titleLab.numberOfLines = 2;
    titleLab.frame = CGRectMake(0, 30, SCREEN_WIDTH, 60);
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgTwo addSubview: titleLab];
    
    
    UILabel *tipLab = [[UILabel alloc] init];
    NSString *text = @"根据国家工商总局《网络交易管理办法》要求对网站营业执照信息公示如下:";
    CGFloat maxHeight = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                       context:nil].size.height;
    tipLab.text = text;
    tipLab.numberOfLines = 0;
    tipLab.font = [UIFont systemFontOfSize:15];
    tipLab.frame = CGRectMake(25, titleLab.bottom + 20, SCREEN_WIDTH - 50, maxHeight);
    tipLab.textColor = HEXColor(@"#333333", 1);
    [bgTwo addSubview:tipLab];
    
    
    UILabel *bigTitle = [[UILabel alloc] init];
    bigTitle.text = @"填写验证码";
    bigTitle.font = [UIFont systemFontOfSize:20];
    [bgTwo addSubview:bigTitle];
    [bigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipLab.left);
        make.top.mas_equalTo(tipLab.bottom + 60);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *smallTitle = [[UILabel alloc] init];
    smallTitle.text = @"请输入右图中的验证码";
    smallTitle.textColor = tipLab.textColor;
    smallTitle.font = [UIFont systemFontOfSize:14];
    [bgTwo addSubview:smallTitle];
    [smallTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bigTitle.mas_left);
        make.top.mas_equalTo(bigTitle.mas_bottom).offset(5);
        make.height.mas_equalTo(14);
    }];
    
    //换一张按钮
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"换一张" forState:UIControlStateNormal];
    [changeBtn setTitleColor:HEXColor(@"#ED3851", 1) forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [changeBtn addTarget:self action:@selector(requestImageCode) forControlEvents:UIControlEventTouchUpInside];
    [bgTwo addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(55);
        make.top.mas_equalTo(bigTitle.mas_top).offset(5);
    }];
    
    //图片
    UIImageView *codeImageView = [[UIImageView alloc] init];
    [HelperTool addTapGesture:codeImageView withTarget:self andSEL:@selector(requestImageCode)];
    codeImageView.backgroundColor = HEXColor(@"#f3f3f3", 1);
    [bgTwo addSubview:codeImageView];
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(changeBtn.mas_left).offset(0);
        make.centerY.mas_equalTo(changeBtn);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(31);
    }];
    _codeImageView = codeImageView;
    
    //验证码
    SMSCodeView *codeView = [[SMSCodeView alloc] initWithCount:4 margin:(SCREEN_WIDTH - 55 * 2 -  50 * 4) / 3];
    [bgTwo addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(55);
        make.right.mas_equalTo(-55);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(smallTitle.mas_bottom).offset(25);
    }];
    _codeView = codeView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ClassTool addLayer:submitBtn frame:CGRectMake(0, 0, SCREEN_WIDTH - 40 * 2, 49)];
    [submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(checkImgCode) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgTwo addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(codeView.mas_bottom).offset(25);
    }];
}

//图形验证码
- (void)requestImageCode {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_IMG_CODE,[UIDevice getDeviceID]];
    [ClassTool getRequestWithStream:urlString Params:nil Success:^(id json) {
        weakself.codeImageView.image = [UIImage imageWithData:json];
    } Failure:^(NSError *error) {
        NSLog(@"error");
    }];
}

//校验图形验证码
- (void)checkImgCode {
//    self.bgOne.hidden = YES;
//    return;
    if (_codeView.code.length < 4) {
        if(_codeView.code.length == 0){
            [CddHUD showTextOnlyDelay:@"请输入验证码" view:self.view];
            return;
        }
        [CddHUD showTextOnlyDelay:@"请输入正确的验证码" view:self.view];
        return ;
    };
    
    NSDictionary *dict = @{@"deviceNo":[UIDevice getDeviceID],
                           @"captcha":_codeView.code
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Check_ImageCode Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                                NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if (isRightData(weakself.imgUrl)) {
                weakself.bgTwo.hidden = YES;
            } else {
                [Alert alertTwo:@"查询有误,请联系平台处理,联系电话:400-920-8599" cancelBtn:@"返回" okBtn:@"拨打" cancelCallBack:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself.navigationController popViewControllerAnimated:YES];
                    });
                } OKCallBack:^{
                    NSString *tel = [NSString stringWithFormat:@"tel://400-920-8599"];
                    //开线程，解决ios10调用慢的问题
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIApplication.sharedApplication openURL:[NSURL URLWithString:tel]];
                        });
                    });
                }];
            }
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)tap
{
    [self.codeView endEditing:YES];
}

@end
