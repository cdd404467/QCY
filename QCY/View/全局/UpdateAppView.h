//
//  UpdateAppView.h
//  DSXS
//
//  Created by 李明哲 on 2018/7/16.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAppView : UIView
@property (nonatomic, copy)NSString *version;
@property (nonatomic, copy)NSString *updateUrl;
- (void)setupUIWithText:(NSString *)text isMustUpdate:(NSString *)updateType;
@end
