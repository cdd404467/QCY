//
//  FCMapCustomAnnotationView.m
//  QCY
//
//  Created by i7colors on 2019/7/9.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCMapCustomAnnotationView.h"

@interface FCMapCustomAnnotationView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation FCMapCustomAnnotationView

- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.bounds = CGRectMake(0, 0, 110, 50);
        self.backgroundColor = UIColor.clearColor;
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImageView.image = [UIImage imageNamed:@"fcmap_customBg_normal"];
        [self addSubview:self.bgImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7 , self.bounds.size.width, 16)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = HEXColor(@"#F10215", 1);
        self.nameLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:self.nameLabel];
    }
    
    return self;
}

#pragma mark - Override

- (NSString *)name {
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected)
        return;
    
    self.bgImageView.image = selected ? [UIImage imageNamed:@"fcmap_customBg_select"] : [UIImage imageNamed:@"fcmap_customBg_normal"];
    self.nameLabel.textColor = selected ? UIColor.whiteColor : HEXColor(@"#F10215", 1);
    [super setSelected:selected animated:animated];
}

@end
