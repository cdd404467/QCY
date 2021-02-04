//
//  AreaSelectView.h
//  QCY
//
//  Created by i7colors on 2019/7/5.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AreaModel;


NS_ASSUME_NONNULL_BEGIN
typedef void(^AllAreaClickBlock)(NSString *area, NSInteger type);

@interface AreaSelectView : UIView
//- (instancetype)initWithHistory:(NSArray *)histroyArr;
- (void)show;
- (void)hide;
@property (nonatomic, copy) AllAreaClickBlock allAreaClickBlock;
@end

@interface AreaSelectTBLeftCell : UITableViewCell
@property (nonatomic, strong) AreaModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@interface AreaSelectTBMidCell : UITableViewCell
@property (nonatomic, strong) AreaModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@interface AreaSelectTBRightCell : UITableViewCell
@property (nonatomic, strong) AreaModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
NS_ASSUME_NONNULL_END

