//
//  HHTitlePageView.m
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHTitlePageView.h"

#define kBottomLineH 2

@interface HHTitlePageView ()

/** 保存标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 存放label的数组 */
@property (nonatomic, strong) NSMutableArray *labels;

/** UIScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 拥有底部滚动条，方便移动 */
@property (nonatomic, weak) UIView *scrollLine;

/** 记录当前label的index */
@property (nonatomic, assign) NSInteger currentIndex;


/** 标题默认颜色R */
@property (nonatomic, assign) CGFloat defaultColorR;
/** 标题默认颜色G */
@property (nonatomic, assign) CGFloat defaultColorG;
/** 标题默认颜色B */
@property (nonatomic, assign) CGFloat defaultColorB;

/** 标题选中颜色R */
@property (nonatomic, assign) CGFloat selectedColorR;
/** 标题选中颜色G */
@property (nonatomic, assign) CGFloat selectedColorG;
/** 标题选中颜色B */
@property (nonatomic, assign) CGFloat selectedColorB;
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
        
        // 默认当前label的下标为0
        self.currentIndex = 0;
        
//        // 标题颜色 默认黑色
        self.defaultColorR = 0;
        self.defaultColorG = 0;
        self.defaultColorB = 0;
        // 选中蓝色
        self.selectedColorR = 41;
        self.selectedColorG = 52;
        self.selectedColorB = 212;
        
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
    firstLabel.textColor = [UIColor colorWithRed:self.selectedColorR / 255.0 green:self.selectedColorG / 255.0 blue:self.selectedColorB / 255.0 alpha:1.0];;
    
    
    UIView *scrollLine = [[UIView alloc] init];
    scrollLine.backgroundColor = [UIColor blueColor];
    scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height - kBottomLineH, firstLabel.frame.size.width, kBottomLineH);
    [self.scrollView addSubview:scrollLine];
    self.scrollLine = scrollLine;
    
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
        label.textColor = [UIColor colorWithRed:self.defaultColorR / 255.0 green:self.defaultColorG / 255.0 blue:self.defaultColorB / 255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelX = labelW * i;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        [self.scrollView addSubview:label];
        [self.labels addObject:label];
        
        label.userInteractionEnabled = YES;
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
        
    }
}
#pragma mark - 标题点击事件
- (void)tap:(UITapGestureRecognizer *)tap
{
    // 获取当前的label
    UILabel *currentLabel = (UILabel *)tap.view;
    
    if (self.currentIndex == currentLabel.tag) {
        return;
    }
    
    // 获取之前的label
    UILabel *oldLabel = self.labels[self.currentIndex];
    
    // 切换文字的颜色
    currentLabel.textColor = [UIColor colorWithRed:self.selectedColorR / 255.0 green:self.selectedColorG / 255.0 blue:self.selectedColorB / 255.0 alpha:1.0];;
    oldLabel.textColor = [UIColor colorWithRed:self.defaultColorR / 255.0 green:self.defaultColorG / 255.0 blue:self.defaultColorB / 255.0 alpha:1.0];;
    
    // 保存最新label的下标值
    self.currentIndex = currentLabel.tag;
    
    // 移动滚动条
    CGFloat scrollLineX = self.currentIndex * self.scrollLine.frame.size.width;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollLine.frame = CGRectMake(scrollLineX, self.scrollLine.frame.origin.y, self.scrollLine.frame.size.width, self.scrollLine.frame.size.height);
    }];
    
    /** 代理通知控制器选中标题的下标 */
    if ([self.delegate respondsToSelector:@selector(titleView:didSelectedIndex:)]) {
        [self.delegate titleView:self didSelectedIndex:self.currentIndex];
    }
    
}


#pragma mark - 公共方法
- (void)setTitleWithScale:(CGFloat)scale sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    // 取出对应的label
    UILabel *sourceLabel = self.labels[sourceIndex];
    UILabel *targetLabel = self.labels[targetIndex];
    
    // 处理滑块
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveX = moveTotalX * scale;
    CGFloat scrollLineX = moveX + sourceLabel.frame.origin.x;
    self.scrollLine.frame = CGRectMake(scrollLineX, self.scrollLine.frame.origin.y, self.scrollLine.frame.size.width, self.scrollLine.frame.size.height);
    
    // 处理标题颜色
    CGFloat rDelta = self.selectedColorR - self.defaultColorR;
    CGFloat gDelta = self.selectedColorG - self.defaultColorG;
    CGFloat bDelta = self.selectedColorB - self.defaultColorB;
    
    CGFloat sourceR = (self.selectedColorR - rDelta * scale) / 255.0;
    CGFloat sourceG = (self.selectedColorG - gDelta * scale) / 255.0;
    CGFloat sourceB = (self.selectedColorB - bDelta * scale) / 255.0;
    
    CGFloat targetR = (self.defaultColorR + rDelta * scale) / 255.0;
    CGFloat targetG = (self.defaultColorG + gDelta * scale) / 255.0;
    CGFloat targetB = (self.defaultColorB + bDelta * scale) / 255.0;
    
    sourceLabel.textColor = [UIColor colorWithRed:sourceR green:sourceG blue:sourceB alpha:1.0];;
    targetLabel.textColor = [UIColor colorWithRed:targetR green:targetG blue:targetB alpha:1.0];;
    
    // 记录最新的index
    self.currentIndex = targetIndex;
}


@end
