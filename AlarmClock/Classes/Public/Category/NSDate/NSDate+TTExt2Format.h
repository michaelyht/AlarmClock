//
//  NSDate+TTExt2Format.h
//  TTLightKit
//
//  Created by 天智慧启 on 2017/5/15.
//  Copyright © 2017年 天智慧启. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface NSDate (TTExt2Format)

/**
 * 根据日期返回字符串 format源字符串格式
 */
+ (NSString *)tt_stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)tt_stringWithFormat:(NSString *)format;
+ (NSDate *)tt_dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串
 */
- (NSString *)tt_ymdFormat;
+ (NSString *)tt_ymdFormat;
- (NSString *)tt_hmsFormat;
+ (NSString *)tt_hmsFormat;
- (NSString *)tt_ymdHmsFormat;
+ (NSString *)tt_ymdHmsFormat;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)tt_stringWithTimeInfo;
+ (NSString *)tt_stringWithTimeInfoByDate:(NSDate *)date;
+ (NSString *)tt_stringWithTimeInfoByDateString:(NSString *)dateString;


/**
 days 之前显示 x分钟前/x小时前/昨天/x天前, 之后显示成日期
 
 @param days 几天的时间
 @return days 之前显示 x分钟前/x小时前/昨天/x天前, 之后显示成日期
 */
- (NSString *)tt_stringWithTimeInfoByAfterDaysOfInteger:(NSInteger)days;

@end

NS_ASSUME_NONNULL_END


