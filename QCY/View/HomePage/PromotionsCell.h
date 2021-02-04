//
//  PromotionsCell.h
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class BannerModel;

typedef void(^PromotionsBlock)(NSInteger type);

@interface PromotionsCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
//@property (nonatomic, strong)BannerModel *model;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, copy)PromotionsBlock promotionsBlock;
@end

@interface ImagesViewDisPlay : UIView
@property (nonatomic, copy)PromotionsBlock promotionsBlock;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end
