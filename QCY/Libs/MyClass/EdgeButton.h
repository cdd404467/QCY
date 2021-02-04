//
//  EdgeButton.h
//  QCY
//
//  Created by i7colors on 2019/6/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 图片和文字的相对位置
typedef NS_ENUM(NSInteger, SCCustomButtonImagePosition) {
    SCCustomButtonImagePositionTop,     // 图片在文字顶部
    SCCustomButtonImagePositionLeft,    // 图片在文字左侧
    SCCustomButtonImagePositionBottom,  // 图片在文字底部
    SCCustomButtonImagePositionRight    // 图片在文字右侧
};
@interface EdgeButton : UIButton
@property (assign, nonatomic) CGFloat interTitleImageSpacing;  ///< 图片文字间距
@property (assign, nonatomic) SCCustomButtonImagePosition imagePosition;     ///< 图片和文字的相对位置
@property (assign, nonatomic) CGFloat imageCornerRadius;                     ///< 图片圆角半径
@end

NS_ASSUME_NONNULL_END
