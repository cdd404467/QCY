//
//  ProductClassifyView.m
//  QCY
//
//  Created by i7colors on 2019/6/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductClassifyView.h"
#import "HelperTool.h"
#import "OpenMallModel.h"
#import "ClassTool.h"
#import <YYText.h>


#define AniTime 0.3
#define LeftGap SCREEN_WIDTH / 8
#define BtnWidth (SCREEN_WIDTH / 8 * 7 - 60) / 3

@interface ProductClassifyView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)PCHeader *headerView;
@property (nonatomic, strong)UIButton *resetBtn;
@end

@implementation ProductClassifyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = SCREEN_BOUNDS;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAllSubviews)];
        backTap.delegate = self;
        [self addGestureRecognizer:backTap];
    }
    
    return self;
}


- (void)show {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    DDWeakSelf;
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = UIColor.whiteColor;
    _backgroundView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - LeftGap, SCREEN_HEIGHT);
    [self addSubview:_backgroundView];
    
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [_backgroundView addSubview:self.collectionView];
    [_backgroundView addSubview:self.headerView];
    
    //重置按钮
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.backgroundColor = HEXColor(@"#F5F5F5", 1);
    resetBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, _backgroundView.width / 2, 49);
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
    [resetBtn setTitleColor:HEXColor(@"#C0C0C0", 1) forState:UIControlStateDisabled];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [resetBtn addTarget:self action:@selector(resetSelect) forControlEvents:UIControlEventTouchUpInside];
    resetBtn.enabled = NO;
    [_backgroundView addSubview:resetBtn];
    _resetBtn = resetBtn;
    //完成按钮
    UIButton *compBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    compBtn.frame = CGRectMake(resetBtn.width, resetBtn.top, resetBtn.width, resetBtn.height);
    [compBtn setTitle:@"完成" forState:UIControlStateNormal];
    [compBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    compBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [compBtn addTarget:self action:@selector(complectSelect) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:compBtn];
    [ClassTool addLayer:compBtn frame:CGRectMake(0, 0, compBtn.width, compBtn.height)];
    
    if (_selectIP) {
        [self.collectionView selectItemAtIndexPath:_selectIP animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        self.collectionView.contentInset = UIEdgeInsetsMake(75, 0, 20, 0);
        ProductClassifyModel *secondModel = _selectModel.propList[_selectIP.row];
        self.headerView.title = [NSString stringWithFormat:@"%@-#%@",_selectModel.typeText,secondModel.value];
        self.headerView.hidden = NO;
        resetBtn.enabled = YES;
    }
    
    [UIView animateWithDuration:AniTime animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.5);
        weakself.backgroundView.left = LeftGap;
    }];
}

- (void)setDataSource:(NSArray<ProductClassifyModel *> *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)removeAllSubviews {
    DDWeakSelf;
    [UIView animateWithDuration:AniTime animations:^{
        weakself.backgroundView.left = SCREEN_WIDTH;
        weakself.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [weakself.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [weakself removeFromSuperview];
    }];
}



//完成选择
- (void)complectSelect {
    [self removeAllSubviews];
}

//重置
- (void)resetSelect {
    _selectModel = nil;
    _selectIP = nil;
    _headerView.hidden = YES;
    _resetBtn.enabled = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.collectionView selectItemAtIndexPath:_selectIP animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if (self.selectedBlock) {
        self.selectedBlock(self.selectModel, _selectIP);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, STATEBAR_HEIGHT, SCREEN_WIDTH - LeftGap, self.frame.size.height - STATEBAR_HEIGHT - TABBAR_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        //        _collectionView.scrollEnabled = NO; //禁止滚动
        //        _collectionView.showsHorizontalScrollIndicator = NO;
        //        _collectionView.showsVerticalScrollIndicator = NO;//垂直
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //设置内容范围偏移200
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [_collectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductItem"];
        [_collectionView registerClass:[PCSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PCSectionHeader"];
    }
    
    return _collectionView;
}

//创建自定义的tableView headerView
- (PCHeader *)headerView {
    if (!_headerView) {
        CGFloat height = 75;
        _headerView = [[PCHeader alloc] init];
        _headerView.backgroundColor = UIColor.whiteColor;
        _headerView.frame = CGRectMake(0, STATEBAR_HEIGHT, SCREEN_WIDTH - LeftGap, height);
        _headerView.hidden = YES;
        DDWeakSelf;
        _headerView.clearSelectBlock = ^{
            [weakself resetSelect];
        };
    }
    
    return _headerView;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
//    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
//        return NO;
//    }
    
    if (touch.view.width < SCREEN_WIDTH) {
        return NO;
    }
    
    return YES;
}

#pragma mark - collectionView代理
//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //重用cell
    ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductItem" forIndexPath:indexPath];
    ProductClassifyModel *model = _dataSource[indexPath.section];
    cell.model = model.propList[indexPath.row];
    
    return cell;
}


/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataSource[section] propList] count];
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(BtnWidth , 30);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 15, 10, 15);
}


- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //解决滚动条遮挡问题
    view.layer.zPosition = 0.0;
}


// 选中cell后操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductClassifyModel *model = self.dataSource[indexPath.section];
    self.selectModel = model;
     self.collectionView.contentInset = UIEdgeInsetsMake(75, 0, 20, 0);
    ProductClassifyModel *secondModel = model.propList[indexPath.row];
    
    self.headerView.title = [NSString stringWithFormat:@"%@-#%@",model.typeText,secondModel.value];
    
    CGPoint offset = self.collectionView.contentOffset;
    if (self.headerView.hidden && offset.y <= 0) {
        if (indexPath.section == 0 && indexPath.row < 6) {
            [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }
    }
    
    self.headerView.hidden = NO;
    _selectIP = indexPath;
    
    if (_resetBtn.enabled == NO) {
        _resetBtn.enabled = YES;
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(self.selectModel, _selectIP);
    }
}

//设置footer尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH - LeftGap, 40);
}

//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {  //header
        PCSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PCSectionHeader" forIndexPath:indexPath];
        
        header.model = self.dataSource[indexPath.section];
        reusableView = header;

        return reusableView;
    }

    return reusableView;
}

@end


//自定义cell
@implementation ProductCollectionCell {
    UILabel *_classifyLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _classifyLabel = [[UILabel alloc] init];
    _classifyLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _classifyLabel.textAlignment = NSTextAlignmentCenter;
    _classifyLabel.font = [UIFont systemFontOfSize:14];
    _classifyLabel.backgroundColor = Like_Color;
    _classifyLabel.textColor = HEXColor(@"#333333", .8);
    [self.contentView addSubview:_classifyLabel];
    [HelperTool setRound:_classifyLabel corner:UIRectCornerAllCorners radiu:5];
}

- (void)setModel:(ProductClassifyModel *)model {
    _model = model;
    
    _classifyLabel.text = model.value;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _classifyLabel.backgroundColor = selected ? HEXColor(@"#F10215", 1) : Like_Color;
    _classifyLabel.textColor = selected ? UIColor.whiteColor : HEXColor(@"#333333", .8);
}




@end

//section头部
@implementation PCSectionHeader {
    UILabel *_levelOneLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _levelOneLabel = [[UILabel alloc] init];
    _levelOneLabel.frame = CGRectMake(15, 10, 200, 30);
    _levelOneLabel.font = [UIFont systemFontOfSize:15];
    _levelOneLabel.textColor = HEXColor(@"#C0C0C0", 1);
    [self addSubview:_levelOneLabel];
}

- (void)setModel:(ProductClassifyModel *)model {
    _model = model;
    _levelOneLabel.text = model.typeText;
}

@end

//collection头部
@implementation PCHeader {
    UIButton *_alreadySelectBtn;
    YYLabel *_alreadySelectLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        _alreadySelectLabel = [[YYLabel alloc] init];
        _alreadySelectLabel.frame = CGRectMake(15, 5, 200, 20);
        _alreadySelectLabel.textColor = HEXColor(@"#808080", 1);
        _alreadySelectLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_alreadySelectLabel];
        
        //已选的按钮
        _alreadySelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _alreadySelectBtn.frame = CGRectMake(15, _alreadySelectLabel.bottom + 12, BtnWidth, 30);
        [_alreadySelectBtn setTitleColor:HEXColor(@"#F10215", 1) forState:UIControlStateNormal];
        _alreadySelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _alreadySelectBtn.layer.cornerRadius = 5;
        [_alreadySelectBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        _alreadySelectBtn.layer.borderColor = HEXColor(@"#F10215", 1).CGColor;
        _alreadySelectBtn.layer.borderWidth = 1.f;
        [self addSubview:_alreadySelectBtn];
        
        UIImageView *closeImg = [[UIImageView alloc] initWithFrame:CGRectMake(_alreadySelectBtn.right - 10, _alreadySelectBtn.top - 5, 14, 14)];
        closeImg.backgroundColor = UIColor.whiteColor;
        closeImg.image = [UIImage imageNamed:@"product_cancelSelecte"];
        [self addSubview:closeImg];
        
    }
    
    return self;
}

- (void)clear {
    if (self.clearSelectBlock) {
        self.clearSelectBlock();
    }
}



- (void)setTitle:(NSString *)title {
    _title = title;
    NSArray<NSString *> *arr = [title componentsSeparatedByString:@"-#"];
    NSString *text = [NSString stringWithFormat:@"已选: %@",arr[0]];
    NSMutableAttributedString *mtext = [[NSMutableAttributedString alloc] initWithString:text];
    mtext.yy_font = _alreadySelectLabel.font;
    mtext.yy_color = _alreadySelectLabel.textColor;
    [mtext yy_setColor:HEXColor(@"#F10215", 1) range:NSMakeRange(text.length - arr[0].length, arr[0].length)];
    _alreadySelectLabel.attributedText = mtext;
    [_alreadySelectBtn setTitle:arr[1] forState:UIControlStateNormal];
}

@end
