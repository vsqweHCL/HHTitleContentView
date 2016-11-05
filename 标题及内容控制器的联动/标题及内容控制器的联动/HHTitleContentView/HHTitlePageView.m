//
//  HHTitlePageView.m
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHTitlePageView.h"

#define RGBA(r, g, b) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0]
#define kBottomLineH 2

@interface HHTitlePageView ()

/** 保存标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 存放label的数组 */
@property (nonatomic, strong) NSMutableArray *labels;

/** UIScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HHTitlePageView
/** 懒加载 */
- (NSMutableArray *)labels
{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.titles = titles;
        // 设置UI界面
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 1.添加UIScrollView
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    
    // 2.添加对应得标题
    [self addTitleLabel];
    
    // 3.添加底部滑块
    [self addBottomLine];
}
- (void)addBottomLine
{
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    [self addSubview:bottomLine];
    
    // 获取第一个label
    UILabel *firstLabel = [self.labels firstObject];
    
    
    UIView *scrollLine = [[UIView alloc] init];
    scrollLine.backgroundColor = [UIColor blueColor];
    scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height - kBottomLineH, firstLabel.frame.size.width, kBottomLineH);
    [self.scrollView addSubview:scrollLine];
    
}
- (void)addTitleLabel
{
    CGFloat labelW = self.frame.size.width / (self.titles.count);
    CGFloat labelH = self.frame.size.height - kBottomLineH;
    CGFloat labelY = 0;
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = self.titles[i];
        label.tag = i;
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = RGBA(41, 52, 212);
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelX = labelW * i;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        [self.scrollView addSubview:label];
        [self.labels addObject:label];
        
    }
}
@end
