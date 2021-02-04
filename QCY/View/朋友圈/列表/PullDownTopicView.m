//
//  PullDownTopicView.m
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PullDownTopicView.h"
#import "TopicSelectCollectionCell.h"
#import "HelperTool.h"

@interface PullDownTopicView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation PullDownTopicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    self.hidden = YES;
    [self addSubview:self.collectionView];
}

//懒加载collectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        _collectionView.scrollEnabled = YES; //禁止滚动
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TopicSelectCollectionCell class] forCellWithReuseIdentifier:@"titleCell"];
        
    }
    return _collectionView;
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    self.collectionView.height = 0;
    [HelperTool addTapGesture:self withTarget:self andSEL:@selector(pullAction)];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self.collectionView reloadData];
}

#pragma mark - collectionView代理方法
//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //重用cell
    TopicSelectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"titleCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.selecteIndex = _selectIndex;
    cell.model = self.dataSource[indexPath.row];
    DDWeakSelf;
    cell.selectedIndexBlock = ^(NSInteger index) {
        if (weakself.selectedIndexBlock) {
            weakself.selectedIndexBlock(index);
        }
    };
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREEN_WIDTH - 50) / 4;
    return CGSizeMake(width, 30);
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
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)pullAction {
    DDWeakSelf;
    if (self.closeBlock) {
        self.closeBlock();
    }
    if (self.collectionView.height == 0)
        self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.backgroundColor = weakself.collectionView.height == 0 ? RGBA(0, 0, 0, 0.2) : RGBA(0, 0, 0, 0.0);
        weakself.collectionView.height = weakself.collectionView.height == 0 ? weakself.height : 0;
    } completion:^(BOOL finished) {
        if (weakself.collectionView.height == 0)
            weakself.hidden = YES;
    }];
}

- (void)pullClose {
    DDWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.0);
        weakself.collectionView.height = 0;
    } completion:^(BOOL finished) {
            weakself.hidden = YES;
    }];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

@end
