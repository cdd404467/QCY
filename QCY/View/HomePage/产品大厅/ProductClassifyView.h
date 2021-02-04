//
//  ProductClassifyView.h
//  QCY
//
//  Created by i7colors on 2019/6/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductClassifyModel;


NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedBlock)(ProductClassifyModel *model, NSIndexPath *selectIP);


@interface ProductClassifyView : UIView
- (void)show;
@property (nonatomic, copy)NSArray<ProductClassifyModel *> *dataSource;
@property (nonatomic, copy)SelectedBlock selectedBlock;
@property (nonatomic, strong)ProductClassifyModel *selectModel;
@property (nonatomic, strong)NSIndexPath *selectIP;
@end



@interface ProductCollectionCell : UICollectionViewCell
@property (nonatomic, strong)ProductClassifyModel *model;
@end

@interface PCSectionHeader : UICollectionReusableView
@property (nonatomic, strong)ProductClassifyModel *model;
@end


typedef void(^ClearSelectBlock)(void);
@interface PCHeader : UIView
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)ClearSelectBlock clearSelectBlock;
@end

NS_ASSUME_NONNULL_END
