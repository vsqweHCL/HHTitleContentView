//
//  HHContentPageView.m
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHContentPageView.h"

static NSString *const ID = @"cellID";

@interface HHContentPageView () <UICollectionViewDelegate,UICollectionViewDataSource>
/** 保存所有的子控制器 */
@property (nonatomic, strong) NSArray *childVcs;
/** 保存父控制器 */
@property (nonatomic, weak) UIViewController *parentViewController;

/** UICollectionView用来循环利用控制器的view */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HHContentPageView

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray *)childVcs parentViewController:(UIViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.childVcs = childVcs;
        self.parentViewController = parentViewController;
        self.frame = frame;
        
        // 设置UI界面
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    // 1.将所有的子控制器添加到父控制器中
    for (NSInteger i = 0; i < self.childVcs.count; i++) {
        UIViewController *childVc = self.childVcs[i];
        [self.parentViewController addChildViewController:childVc];
     }
    
    // 2.创建UICollectionView
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
}

#pragma mark - 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childVcs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 防止循环利用
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController *childVc = self.childVcs[indexPath.item];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    
    return cell;
}
#pragma mark - 代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
@end
