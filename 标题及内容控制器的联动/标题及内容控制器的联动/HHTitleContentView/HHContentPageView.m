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

/** 记录collectionView开始滑动的offsetX */
@property (nonatomic, assign) CGFloat startOffsetX;
/** 如果是标题点击，就禁止scrollView滚动 */
@property (nonatomic, assign) BOOL isForbidScrollDelegate;
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
        
        // 默认startOffsetX为0
        self.startOffsetX = 0;
        self.isForbidScrollDelegate = NO;
        
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
    // 自己要滚的
    self.isForbidScrollDelegate = NO;
    
    // 记录开始滑动的startOffsetX
    self.startOffsetX = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 标题点击的，就禁止scrollView滚动
    if (self.isForbidScrollDelegate) return;
    
    // 需要获取的值
    CGFloat scale = 0;
    NSInteger sourceIndex = 0;
    NSInteger tagertIndex = 0;
    
    CGFloat scrollViewW = scrollView.bounds.size.width;
    // 获取当前滑动的offsetX，判断左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    if (currentOffsetX > self.startOffsetX) { // 左滑
        scale = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        sourceIndex = (int)(currentOffsetX / scrollViewW);
        tagertIndex = sourceIndex + 1;
        
        // 越界处理
        if (tagertIndex >= self.childVcs.count) {
            tagertIndex = self.childVcs.count - 1;
        }
        
        // 完全滑动完毕
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            scale = 1;
            tagertIndex = sourceIndex;
        }
    }
    else { // 右滑
        scale = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        tagertIndex = (int)(currentOffsetX / scrollViewW);
        sourceIndex = tagertIndex + 1;
        
        // 越界处理
        if (sourceIndex >= self.childVcs.count) {
            sourceIndex = self.childVcs.count - 1;
        }
        
    }
    /** 代理通知控制器滚动的比例、源index、目标index */
    if ([self.delegate respondsToSelector:@selector(contentView:scale:sourceIndex:targetIndex:)]) {
        [self.delegate contentView:self scale:scale sourceIndex:sourceIndex targetIndex:tagertIndex];
    }
}

#pragma mark - 公共方法
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    // 标题点击的，就禁止scrollView滚动
    self.isForbidScrollDelegate = YES;
    
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
@end
