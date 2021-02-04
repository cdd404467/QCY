//
//  AskToBuyBottomView.h
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
@class SelectedView;

NS_ASSUME_NONNULL_BEGIN

@interface AskToBuyBottomView : UIView<BEMCheckBoxDelegate>

@property (nonatomic, strong)UITextField *companyNameTF;
@property (nonatomic, strong)UITextField *productNameTF;
@property (nonatomic, strong)UITextField *specificationTF;
@property (nonatomic, strong)UITextField *buyCountTF;
@property (nonatomic, strong)UITextField *billTF;
@property (nonatomic, strong)SelectedView *productClassifyOne;
@property (nonatomic, strong)SelectedView *productClassifyTwo;
@property (nonatomic, strong)SelectedView *unit;
@property (nonatomic, strong)SelectedView *payType;
@property (nonatomic, strong)SelectedView *placeArea;
@property (nonatomic, strong)SelectedView *endTime;
@property (nonatomic, strong)SelectedView *deliveryDate;
@property (nonatomic, strong)SelectedView *billDate;
@property (nonatomic, strong)BEMCheckBox  *dateCheckBox;
@property (nonatomic, strong)BEMCheckBox  *agreeZTC;
@property (nonatomic, strong)BEMCheckBox  *disAgreeZTC;
@property (nonatomic, strong)UILabel *unitDisplay;
@property (nonatomic, strong)UILabel *explainLabel;
@property (nonatomic, strong)UITextView *textView;
@end

NS_ASSUME_NONNULL_END
