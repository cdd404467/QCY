//
//  WeiChatPhotoView.h
//  QCY
//
//  Created by i7colors on 2018/11/27.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeiChatPhotoView : UIView

@property (nonatomic, strong) NSArray<NSString *> *urlArray;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *videoURL;
@property (nonatomic, assign)CGFloat videoPicWidth;
@property (nonatomic, assign)CGFloat videoPicHight;
@property (nonatomic, assign)CGFloat pic1Width;
@property (nonatomic, assign)CGFloat pic1Hight;


@end

NS_ASSUME_NONNULL_END
