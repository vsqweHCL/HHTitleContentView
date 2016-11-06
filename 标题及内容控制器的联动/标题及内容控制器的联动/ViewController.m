//
//  ViewController.m
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "ViewController.h"
#import "HHTitlePageView.h"
#import "HHContentPageView.h"

#define kNavigationBarH 64
#define kTitlePageViewH 40
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGBA(r, g, b) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0]

@interface ViewController () <HHTitlePageViewDelegate,HHContentPageViewDelegate>

/** 所有的控制器数组 */
@property (nonatomic, strong) NSMutableArray *childVcs;


@property (nonatomic, weak) HHTitlePageView *titlePageView;
@property (nonatomic, weak) HHContentPageView *contentView;
@end

@implementation ViewController
/** 懒加载 */
- (NSMutableArray *)childVcs
{
    if (_childVcs == nil) {
        _childVcs = [NSMutableArray array];
    }
    return _childVcs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网易新闻";
    // 不要调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    // 1.创建标题
    CGRect titleF = CGRectMake(0, kNavigationBarH, self.view.frame.size.width, kTitlePageViewH);
    NSArray *titles = [NSArray arrayWithObjects:@"标题1",@"标题2",@"标题3",@"标题4", nil];
    HHTitlePageView *titlePageView = [[HHTitlePageView alloc] initWithFrame:titleF titles:titles];
    titlePageView.delegate = self;
    [self.view addSubview:titlePageView];
    self.titlePageView = titlePageView;
    
    
    // 2.创建内容
    CGFloat contentH = kScreenH - kNavigationBarH;
    CGRect contentF = CGRectMake(0, kNavigationBarH + kTitlePageViewH, kScreenW, contentH);
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = RGBA(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        [self.childVcs addObject:vc];
    }
    HHContentPageView *contentView = [[HHContentPageView alloc] initWithFrame:contentF childVcs:self.childVcs parentViewController:self];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

#pragma mark - 标题被点击的代理,通知contentView滚动
- (void)titleView:(HHTitlePageView *)titleView didSelectedIndex:(NSInteger)index
{
    [self.contentView setCurrentIndex:index];
}
#pragma mark - 内容滚动了的代理,通知titleView选中标题
- (void)contentView:(HHContentPageView *)contentView scale:(CGFloat)scale sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    [self.titlePageView setTitleWithScale:scale sourceIndex:sourceIndex targetIndex:targetIndex];
}
@end
