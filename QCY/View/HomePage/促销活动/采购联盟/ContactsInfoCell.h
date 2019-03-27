//
//  ContactsInfoCell.h
//  QCY
//
//  Created by i7colors on 2019/2/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedView.h"

@class OrderOrSupplyModel;
NS_ASSUME_NONNULL_BEGIN

@interface ContactsInfoCell : UITableViewCell
@property (nonatomic, strong)OrderOrSupplyModel *model;
@property (nonatomic, strong)UITextField *companyTF;
@property (nonatomic, strong)UITextField *contactTF;
@property (nonatomic, strong)UITextField *workTF;
@property (nonatomic, strong)UITextField *phoneTF;

@property (nonatomic, strong)SelectedView *paySelect;
@property (nonatomic, strong)SelectedView *dateSelect;
@property (nonatomic, strong)SelectedView *areaSelect;
@property (nonatomic, strong)UITextView *textView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
