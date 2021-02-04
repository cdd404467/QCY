//
//  HistoryRecordView.h
//  QCY
//
//  Created by i7colors on 2019/7/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HistoryBtnClickBlock)(NSString *title, NSInteger type);
@interface HistoryRecordView : UIView
@property (nonatomic, copy)NSArray<NSString *> *histroyArr;
@property (nonatomic, copy)HistoryBtnClickBlock historyBtnClickBlock;
@end


@interface HistoryButton : UIButton
@property (nonatomic, assign)NSInteger type;
@end
NS_ASSUME_NONNULL_END
