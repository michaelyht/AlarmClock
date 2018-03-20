//
//  NSDate+TTExt2InternetDate.h
//  TQKit
//
//  Created by 天智慧启 on 2017/7/3.
//  Copyright © 2017年 guojie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TTDateFormatHintNone,
    TTDateFormatHintRFC822,
    TTDateFormatHintRFC3339
} TTDateFormatHint;

@interface NSDate (TTExt2InternetDate)

+ (NSDate *)tt_dateFromInternetDateTimeString:(NSString *)dateString
                                formatHint:(TTDateFormatHint)hint;

+ (NSDate *)tt_dateFromRFC3339String:(NSString *)dateString;
+ (NSDate *)tt_dateFromRFC822String:(NSString *)dateString;

#pragma mark - 1.1.6新增

/**
 获取网络时间
 2s超时
 @return 如果超时，返回本地时间
 */
+ (NSDate *)tt_getNetworkDate;

/**
 获取网络时间
 
 @param timeout 超时时间
 @return 如果超时，返回本地时间
 */
+ (NSDate *)tt_getNetworkDateByTimeout:(NSInteger)timeout;

@end
