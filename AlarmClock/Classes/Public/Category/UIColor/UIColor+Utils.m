//
//  UIColor+Utils.m
//  Test
//
//  Created by Day Ling on 16/6/23.
//  Copyright © 2016年 Lingday. All rights reserved.
//

#import "UIColor+Utils.h"
#import "UIColor+TTExt.h"

@implementation UIColor (Utils)

+ (UIColor *)redTextColor {
    return [UIColor tt_colorWithHexString:@"fd0e0e"];
}

+ (UIColor *)tintColor {
    return [UIColor tt_colorWithHexString:@"38adff"];
}

//tabBar未选中颜色
+ (UIColor *)tabNormalColor{
    return [UIColor tt_colorWithHexString:@"777777"];
}

+ (UIColor *)homeOrangeColor{
    return [UIColor tt_colorWithHexString:@"FF6959"];
}

//文本title颜色
+ (UIColor *)textTitleColor{
    return [UIColor tt_colorWithHexString:@"333333"];
}

// 文本颜色
+ (UIColor *)textContentColor{
    return [UIColor tt_colorWithHexString:@"414141"];
}

+ (UIColor *)homeTextGrayColor{
    return [UIColor tt_colorWithHexString:@"4C4C4C"];
}

+ (UIColor *)viewBGColor{
    return [UIColor tt_colorWithHexString:@"f5f5f7"];
}

+ (UIColor *)lineColor{
    return [UIColor tt_colorWithHexString:@"EAEAEA"];
}

// 文本框输入钱的灰色
//[_userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
+ (UIColor *)placeHolderColor{
    return [UIColor tt_colorWithHexString:@"c5c5c5"];
}

+ (UIColor *)grayBntColor{
    return  [UIColor tt_colorWithHexString:@"999999"];
}

+ (UIColor *)displayTextColor{
    return  [UIColor tt_colorWithHexString:@"bfbfbf"];
}

//状态页面颜色
+ (UIColor *)stateColor{
    return [UIColor tt_colorWithHexString:@"73828E"];
}

//六个颜色随机选一个
+ (UIColor *)randomColor{
    NSArray *colors = @[[UIColor tt_colorWithHexString:@"FDC261"],
                        [UIColor tt_colorWithHexString:@"035CFF"],
                        [UIColor tt_colorWithHexString:@"FD745F"],
                        [UIColor tt_colorWithHexString:@"B88874"],
                        [UIColor tt_colorWithHexString:@"4FB1FB"]
                        ];
    int x = arc4random() % 5;
    return colors[x];
}

/**
 *  根据颜色的到图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)seperateColor {
    return [UIColor tt_colorWithHexString:@"e1e1e3"];
}

@end
