//
//  CompanytypeSelectView.h
//  QCY
//
//  Created by i7colors on 2019/7/11.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TypeSelectBlock)(NSString *type);
@interface CompanytypeSelectView : UIView
- (void)show;
- (void)hide;
@property (nonatomic, copy) TypeSelectBlock typeSelectBlock;
@end


@interface CompanyTypeCell : UITableViewCell
@property (nonatomic, copy) NSString *typeName;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
