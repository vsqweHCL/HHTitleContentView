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

@interface ViewController ()

/** 所有的控制器数组 */
@property (nonatomic, strong) NSMutableArray *childVcs;
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
    [self.view addSubview:titlePageView];
    
    // 2.创建内容
    CGFloat contentH = kScreenH - kNavigationBarH;
    CGRect contentF = CGRectMake(0, kNavigationBarH + kTitlePageViewH, kScreenW, contentH);
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = RGBA(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        [self.childVcs addObject:vc];
    }
    HHContentPageView *contentView = [[HHContentPageView alloc] initWithFrame:contentF childVcs:self.childVcs parentViewController:self];
    [self.view addSubview:contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
