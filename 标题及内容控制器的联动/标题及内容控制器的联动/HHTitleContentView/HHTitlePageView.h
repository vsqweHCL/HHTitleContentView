//
//  HHTitlePageView.h
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHTitlePageView;

@protocol HHTitlePageViewDelegate <NSObject>
/** 代理通知控制器选中标题的下标 */
- (void)titleView:(HHTitlePageView *)titleView didSelectedIndex:(NSInteger)index;

@end

@interface HHTitlePageView : UIView

/** 代理通知控制器选中标题的下标 */
@property (nonatomic, weak) id<HHTitlePageViewDelegate> delegate;


/** 构造函数，数组装着所有标题 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

/** 设置标题选中，改变颜色，滚动滑块 */
- (void)setTitleWithScale:(CGFloat)scale sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
@end
