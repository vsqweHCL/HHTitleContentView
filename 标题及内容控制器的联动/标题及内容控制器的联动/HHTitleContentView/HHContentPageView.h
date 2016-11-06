//
//  HHContentPageView.h
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHContentPageView;

@protocol HHContentPageViewDelegate <NSObject>

/** 代理通知控制器滚动的比例、源index、目标index */
- (void)contentView:(HHContentPageView *)contentView scale:(CGFloat)scale sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

@interface HHContentPageView : UIView

/** 构造函数，数组存放所有的子控制器 */
- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray *)childVcs parentViewController:(UIViewController *)parentViewController;

/** 代理通知控制器滚动的比例、源index、目标index */
@property (nonatomic, assign) id<HHContentPageViewDelegate> delegate;


/** 设置内容滚动到指定的index */
- (void)setCurrentIndex:(NSInteger)currentIndex;
@end
