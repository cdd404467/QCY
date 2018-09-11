//
//  HomePageSectionHeader.h
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMoreBlock)(void);
@interface HomePageSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, copy)ClickMoreBlock clickMoreBlock;
+ (instancetype)headerWithTableView:(UITableView *)tableView leftTitle:(NSString *)leftTitle;

@end
