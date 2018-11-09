//
//  HomePageHeaderView.h
//  QCY
//
//  Created by zz on 2018/9/5.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapIconsBlock)(NSInteger tag);
@interface HomePageHeaderView : UIView

@property (nonatomic, copy)NSArray *bannerArray;
@property (nonatomic, copy)TapIconsBlock tapIconsBlock;
@end
