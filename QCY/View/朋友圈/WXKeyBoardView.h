//
//  WXKeyBoardView.h
//  QCY
//
//  Created by i7colors on 2018/11/30.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Placeholder.h"

@protocol TVDelegate <NSObject>

@optional
- (void)clickReturn;

@end


NS_ASSUME_NONNULL_BEGIN

@interface WXKeyBoardView : UIView
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *submitBtn;
//textView return点击事件
@property (nonatomic, weak) id<TVDelegate> tvDelegate;
@end

NS_ASSUME_NONNULL_END
