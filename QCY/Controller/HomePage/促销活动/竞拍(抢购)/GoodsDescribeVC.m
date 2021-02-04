//
//  GoodsDescribeVC.m
//  QCY
//
//  Created by i7colors on 2019/3/6.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GoodsDescribeVC.h"
#import <YNPageTableView.h>
#import "GoodsDescribeCell.h"
#import "ProductDetailSectionHeader.h"
#import "AuctionModel.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import <YBImageBrowser.h>
#import <YBIBVideoData.h>

@interface GoodsDescribeVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation GoodsDescribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = Cell_BGColor;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    }
    return _tableView;
}


#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataSource.attributeList.count > 0) {
        if (section == 0) {
            
            return 51;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}
//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_dataSource.attributeList.count > 0) {
        if (section == 0) {
            ProductDetailSectionHeader *header = [ProductDetailSectionHeader headerWithTableView:tableView];
            return header;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataSource.attributeList.count;
    } else if (section == 1) {
        return _dataSource.detailList.count;
    } else {
        return _dataSource.videoList.count;
    }
}

//估算高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_dataSource.attributeList.count > 0) {
            return UITableViewAutomaticDimension;
        } else {
            return 0;
        }
    } else if (indexPath.section == 1) {
        if (_dataSource.detailList.count > 0) {
            return 200;
        } else {
            return 0;
        }
    } else {
        if (_dataSource.videoList.count > 0) {
            return 200;
        } else {
            return 0;
        }
    }
    
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsDescribeCell *cell = [GoodsDescribeCell cellWithTableView:tableView];
        cell.model = _dataSource.attributeList[indexPath.row];
        return cell;
    } else if (indexPath.section == 1) {
        JPIMageViewCell *cell = [JPIMageViewCell cellWithTableView:tableView];
        cell.model = _dataSource.detailList[indexPath.row];
        return cell;
    } else {
        JPVideoCell *cell = [JPVideoCell cellWithTableView:tableView];
        cell.model = _dataSource.videoList[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 圆角弧度半径
        CGFloat cornerRadius = 10.f;
        // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
        cell.backgroundColor = UIColor.clearColor;
        
        // 创建一个shapeLayer
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
        // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
        CGMutablePathRef pathRef = CGPathCreateMutable();
        // 获取cell的size
        // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
        CGRect bounds = CGRectInset(cell.bounds, KFit_W(13), 0);
        
        // CGRectGetMinY：返回对象顶点坐标
        // CGRectGetMaxY：返回对象底点坐标
        // CGRectGetMinX：返回对象左边缘坐标
        // CGRectGetMaxX：返回对象右边缘坐标
        // CGRectGetMidX: 返回对象中心点的X坐标
        // CGRectGetMidY: 返回对象中心点的Y坐标
        
        // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
        
        // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        //    if (indexPath.row == 0) {
        //        // 初始起点为cell的左下角坐标
        //        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        //        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        //        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        //        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        //        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        //        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        //        CGPathCloseSubpath(pathRef);
        //
        //    } else
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            // 初始起点为cell的左上角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            // 添加cell的rectangle信息到path中（不包括圆角）
            CGPathAddRect(pathRef, nil, bounds);
        }
        // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
        layer.path = pathRef;
        backgroundLayer.path = pathRef;
        // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
        CFRelease(pathRef);
        // 按照shape layer的path填充颜色，类似于渲染render
        //     layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        layer.fillColor = [UIColor whiteColor].CGColor;
        //    layer.strokeColor = [UIColor lightGrayColor].CGColor;
        
        // view大小与cell一致
        UIView *roundView = [[UIView alloc] initWithFrame:bounds];
        // 添加自定义圆角后的图层到roundView中
        [roundView.layer insertSublayer:layer atIndex:0];
        roundView.backgroundColor = UIColor.clearColor;
        // cell的背景view
        cell.backgroundView = roundView;
        
        // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
        // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
        backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
        [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
        selectedBackgroundView.backgroundColor = UIColor.clearColor;
        cell.selectedBackgroundView = selectedBackgroundView;
    }
}

@end


@interface JPIMageViewCell()
@property (nonatomic, strong)UIImageView *dImageView;;
@property (nonatomic, copy)NSArray *urlArray;
@end

@implementation JPIMageViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI {
    _dImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 190)];
    [HelperTool addTapGesture:_dImageView withTarget:self andSEL:@selector(tap:)];
    [self.contentView addSubview:_dImageView];
}

- (void)setModel:(DetailPcPicModel *)model {
    _model = model;
    
    [_dImageView sd_setImageWithURL:ImgUrl(model.detailPcPic) placeholderImage:PlaceHolderImg];
    _urlArray = @[[NSString stringWithFormat:@"%@%@",Photo_URL,model.detailPcPic]];
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableArray *browserDataArr = [NSMutableArray array];
    DDWeakSelf;
    [self.urlArray enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([self.type isEqualToString:@"photo"]) {
            YBIBImageData *data = [[YBIBImageData alloc] init];
            data.imageURL = [NSURL URLWithString:urlStr];
            data.projectiveView = weakself.dImageView;
            [browserDataArr addObject:data];
//        } else {
//            YBVideoBrowseCellData *data = [[YBVideoBrowseCellData alloc] init];
//            data.url = [NSURL URLWithString:weakself.videoURL];
//            data.sourceObject = weakself.imageViewsArray[idx];
//            [browserDataArr addObject:data];
//        }
        
    }];
    YBImageBrowser *browser = [[YBImageBrowser alloc] init];
    browser.dataSourceArray = browserDataArr;
    browser.currentPage = (int)imageView.tag;
    [browser show];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"JPIMageViewCell";
    JPIMageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JPIMageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

/**********  视频  ***********/
@interface JPVideoCell()
@property (nonatomic, strong)UIImageView *dImageView;;
@property (nonatomic, copy)NSArray *urlArray;
@end

@implementation JPVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI {
    CGFloat width = 60;
    _dImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 190)];
    [HelperTool addTapGesture:_dImageView withTarget:self andSEL:@selector(tap:)];
    _dImageView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_dImageView];
    
    UIImageView *play = [[UIImageView alloc] init];
//    [playBtn setImage:[UIImage imageNamed:@"bofang"] forState: UIControlStateNormal];
    play.image = [UIImage imageNamed:@"bofang"];
    play.frame = CGRectMake((SCREEN_WIDTH - width) / 2, (190 - 60) / 2, width, width);
    [_dImageView addSubview:play];
}

- (void)setModel:(VideoListModel *)model {
    _model = model;

    _urlArray = @[[NSString stringWithFormat:@"%@%@",Photo_URL,model.videoUrl]];
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableArray *browserDataArr = [NSMutableArray array];
    DDWeakSelf;
    [self.urlArray enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        YBIBVideoData *data = [[YBIBVideoData alloc] init];
        data.videoURL = [NSURL URLWithString:urlStr];
        data.projectiveView = weakself.dImageView;
        [browserDataArr addObject:data];
    }];
    YBImageBrowser *browser = [[YBImageBrowser alloc] init];
    browser.dataSourceArray = browserDataArr;
    browser.currentPage = (int)imageView.tag;
    [browser show];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"JPVideoCell";
    JPVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JPVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
