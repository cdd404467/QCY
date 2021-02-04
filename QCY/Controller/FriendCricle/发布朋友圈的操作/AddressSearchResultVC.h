//
//  AddressSearchResultVC.h
//  QCY
//
//  Created by i7colors on 2019/4/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class POIAnnotationModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedAddressBlock)(POIAnnotationModel *model, NSString *city, NSIndexPath *indexPath, double lon, double lat);
@interface AddressSearchResultVC : BaseViewController

@property (nonatomic, copy)NSString *limitCity;
@property (nonatomic, copy)SelectedAddressBlock selectedAddressBlock;
@end

NS_ASSUME_NONNULL_END
