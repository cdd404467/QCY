//
//  HomePageHeaderView.h
//  QCY
//
//  Created by zz on 2018/9/5.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerModel;

typedef void(^TapIconsBlock)(NSString *code);
typedef void(^ClickBanerBlock)(BannerModel *model);
@interface HomePageHeaderView : UIView

@property (nonatomic, copy)NSArray *bannerArray;
@property (nonatomic, copy)NSArray *iconArray;
@property (nonatomic, copy)TapIconsBlock tapIconsBlock;
@property (nonatomic, copy)ClickBanerBlock clickBanerBlock;
@end
