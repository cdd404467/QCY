//
//  WeiChatPhotoView.m
//  QCY
//
//  Created by i7colors on 2018/11/27.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "WeiChatPhotoView.h"
#import "Friend.h"
#import "Utility.h"
#import "UIView+Geometry.h"
#import <UIImageView+WebCache.h>
#import <YBImageBrowser.h>

@interface WeiChatPhotoView()

// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;

@end

@implementation WeiChatPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    // 小图(九宫格)
    _imageViewsArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImageView *playImg = [[UIImageView alloc] init];
        playImg.image = [UIImage imageNamed:@"YBImageBrowser.bundle/ybib_bigPlay"];
        playImg.frame = CGRectMake(0, 0, 80, 80);
        playImg.hidden = YES;
        [imageView addSubview:playImg];
        [_imageViewsArray addObject:imageView];
        [self addSubview:imageView];
    }
}

- (void)setUrlArray:(NSArray<NSString *> *)urlArray {
    _urlArray = urlArray;
    for (UIImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    NSInteger count = urlArray.count;
    UIImageView *imageView = nil;
    for (NSInteger i = 0; i < count; i ++) {
        if (i > 8) break;
        //每行个数
        NSInteger colNum = i % 3;
        //行数
        NSInteger rowNum = i / 3;
        if (count == 4) {
            colNum = i % 2;
            rowNum = i / 2;
        }
        
        CGFloat imageX = colNum * (kImageWidth + kImagePadding);
        CGFloat imageY = rowNum * (kImageWidth + kImagePadding);
        CGRect frame = CGRectMake(imageX, imageY, kImageWidth, kImageWidth);
        //单张图片需计算实际显示size
        if (count == 1) {
            if ([self.type isEqualToString:@"photo"]) {
                CGSize singleSize = [Utility getSingleSize:CGSizeMake(_pic1Width, _pic1Hight)];
                frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
            } else {
                CGSize singleSize = [Utility getSingleSize:CGSizeMake(_videoPicWidth, _videoPicHight)];
                frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
            }
        }
        imageView = _imageViewsArray[i];
        imageView.hidden = NO;
        imageView.frame = frame;
        //九宫格展示
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlArray[i]] placeholderImage:PlaceHolderImg];
                
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        
        if (count == 1) {
            UIView *view = imageView.subviews.firstObject;
            if ([self.type isEqualToString:@"photo"]) {
                view.hidden = YES;
                view.center = imageView.center;
            } else {
                view.hidden = NO;
                view.center = imageView.center;
            }
        } else {
            UIView *view = imageView.subviews.firstObject;
            view.hidden = YES;
        }
        
    }
    
    self.width = kTextWidth;
    self.height = imageView.bottom;
}



- (void)tap:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableArray *browserDataArr = [NSMutableArray array];
    DDWeakSelf;
    [self.urlArray enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.type isEqualToString:@"photo"]) {
            YBImageBrowseCellData *data = [[YBImageBrowseCellData alloc] init];
            data.url = [NSURL URLWithString:urlStr];
            data.sourceObject = weakself.imageViewsArray[idx];
            [browserDataArr addObject:data];
        } else {
            YBVideoBrowseCellData *data = [[YBVideoBrowseCellData alloc] init];
            data.url = [NSURL URLWithString:weakself.videoURL];
            data.sourceObject = weakself.imageViewsArray[idx];
            [browserDataArr addObject:data];
        }
        
    }];
    YBImageBrowser *browser = [[YBImageBrowser alloc] init];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = (int)imageView.tag;
    [browser show];
}

@end
