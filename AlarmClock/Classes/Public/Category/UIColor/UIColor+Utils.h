//
//  UIColor+Utils.h
//  Test
//
//  Created by Day Ling on 16/6/23.
//  Copyright © 2016年 Lingday. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Utils)

// 红色提示文本
+ (UIColor *)redTextColor;

// 系统主题色 tabBar 选中文本颜色
+ (UIColor *)tintColor;

//tabBar未选中颜色
+ (UIColor *)tabNormalColor;

//首页橘黄色
+ (UIColor *)homeOrangeColor;

//nav title 灰黑
+ (UIColor *)textTitleColor;

// 文本颜色 深灰
+ (UIColor *)textContentColor;

//首页文本灰色
+ (UIColor *)homeTextGrayColor;

// 页面背景灰
+ (UIColor *)viewBGColor;

// 线条灰
+ (UIColor *)lineColor;

// 文本框输入钱的灰色
+ (UIColor *)placeHolderColor;

// 灰色按钮颜色
+ (UIColor *)grayBntColor;

// 文本展示灰
+ (UIColor *)displayTextColor;

//状态页面颜色
+ (UIColor *)stateColor;

//六个颜色随机选一个
+ (UIColor *)randomColor;

//分割线的颜色
+ (UIColor *)seperateColor;

/**
 *  根据颜色的到图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
