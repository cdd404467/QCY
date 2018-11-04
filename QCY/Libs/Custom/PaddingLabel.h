//
//  PaddingLabel.h
//  DSXS
//
//  Created by 李明哲 on 2018/6/2.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface PaddingLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end
