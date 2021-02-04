//
//  SelectedAddressVC.h
//  QCY
//
//  Created by i7colors on 2019/4/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseSystemPresentVC.h"
@class POIAnnotationModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedAddressBlock)(POIAnnotationModel *model, NSString *city, NSIndexPath *indexPath, double lon, double lat);
@interface SelectedAddressVC : BaseSystemPresentVC
@property (nonatomic, copy)SelectedAddressBlock selectedAddressBlock;
@property (nonatomic, strong)POIAnnotationModel *selectedModel;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, strong)NSIndexPath *lastPath;
@end

NS_ASSUME_NONNULL_END
