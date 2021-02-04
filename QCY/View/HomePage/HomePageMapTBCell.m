//
//  HomePageMapTBCell.m
//  QCY
//
//  Created by i7colors on 2019/6/26.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageMapTBCell.h"
#import <UIImageView+WebCache.h>

@implementation HomePageMapTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = UIColor.whiteColor;
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(75));
        imageView.image = [UIImage imageNamed:@"homepage_map_img"];
        [self.contentView addSubview:imageView];
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HomePageMapTBCell";
    HomePageMapTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HomePageMapTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
