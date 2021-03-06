//
//  ChangeNickNameVC.m
//  QCY
//
//  Created by i7colors on 2018/12/13.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ChangeNickNameVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import "UITextField+Limit.h"

@interface ChangeNickNameVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *nameTF;
@end

@implementation ChangeNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Like_Color;
    self.navBar.navTitle = @"设置名字";
    self.navBar.rightBtn.enabled = NO;
    self.navBar.bottomLine.hidden = YES;
    self.navBar.backgroundColor = self.view.backgroundColor;
    [self setupUI];
}

- (void)fcChangeNickName {
    if (_nameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入昵称" view:self.view];
        return;
    }
    [self.view endEditing:YES];
    FormData *data = [[FormData alloc]init];
    data.fileData = UIImageJPEGRepresentation([UIImage imageWithColor:HEXColor(@"#000000", 1)], 0.1);
    data.name = @"666666";
    data.fileName = @"1.jpg";
    data.fileType = @"image/jpeg";
    NSDictionary *dict = @{@"token":User_Token,
                           @"nickName":_nameTF.text
                           };
    DDWeakSelf;
    [CddHUD showTextOnly:@"正在修改昵称..." view:self.view];
     [ClassTool uploadFile:URL_Change_FCInfo Params:[dict mutableCopy] DataSource:data Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"-------p  %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSString *notiName = @"changeFCInfo";
            [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:@"nickName" userInfo:@{@"fcDict":weakself.nameTF.text}];
            [CddHUD showTextOnlyDelay:@"修改成功" view:weakself.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself back];
            });
        }
        
     } Failure:^(NSError *error) {
         NSLog(@"Error:  %@",error);
     } Progress:nil];
}


- (void)setupUI {
    
    _nameTF = [[UITextField alloc]init];
    [_nameTF becomeFirstResponder];
    _nameTF.leftViewMode = UITextFieldViewModeAlways;
    _nameTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _nameTF.text = self.currentName;
    _nameTF.font = [UIFont systemFontOfSize:15];
    _nameTF.backgroundColor = [UIColor whiteColor];
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_nameTF addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    _nameTF.frame = CGRectMake(0, NAV_HEIGHT + 10, SCREEN_WIDTH, 40);
    [self.view addSubview:_nameTF];
    DDWeakSelf;
    [_nameTF lengthLimit:^{
        if (weakself.nameTF.text.length > 20) {
            [CddHUD showTextOnlyDelay:@"昵称最多不能超过20个字哦" view:weakself.view];
            weakself.nameTF.text = [weakself.nameTF.text substringToIndex:20];
        }
    }];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = RGBA(235, 235, 235, 1);
    topLine.frame = CGRectMake(0, _nameTF.frame.origin.y - 1, SCREEN_WIDTH, 1);
    [self.view addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = RGBA(235, 235, 235, 1);
    bottomLine.frame = CGRectMake(0, _nameTF.frame.origin.y + 40, SCREEN_WIDTH, 1);
    [self.view addSubview:bottomLine];

     [self.navBar.rightBtn addTarget:self action:@selector(fcChangeNickName) forControlEvents:UIControlEventTouchUpInside];
}


//监听passTF
- (void)changeTextField:(UITextField *)textField{
    if (![textField.text isEqualToString:self.currentName]) {
        self.navBar.rightBtn.enabled = YES;
    } else {
        self.navBar.rightBtn.enabled = NO;
    }
}

//返回上一页
- (void)back {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
