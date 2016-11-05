//
//  HHContentPageView.h
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHContentPageView : UIView

/** 构造函数，数组存放所有的子控制器 */
- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray *)childVcs parentViewController:(UIViewController *)parentViewController;
@end
