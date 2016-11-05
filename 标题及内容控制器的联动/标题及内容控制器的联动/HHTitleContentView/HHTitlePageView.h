//
//  HHTitlePageView.h
//  标题及内容控制器的联动
//
//  Created by HCL黄 on 16/11/5.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTitlePageView : UIView

/** 构造函数，数组装着所有标题 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
