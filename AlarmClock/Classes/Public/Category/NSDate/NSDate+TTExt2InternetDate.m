//
//  NSDate+TTExt2InternetDate.m
//  TQKit
//
//  Created by 天智慧启 on 2017/7/3.
//  Copyright © 2017年 guojie. All rights reserved.
//

#import "NSDate+TTExt2InternetDate.h"
#import "NSDate+TTExt2Format.h"

static NSDateFormatter *_internetDateTimeFormatter = nil;

@implementation NSDate (TTExt2InternetDate)

/**
 获取网络时间
 2s超时
 @return 如果超时，返回本地时间
 */
+ (NSDate *)tt_getNetworkDate {
    return [self tt_getNetworkDateByTimeout:2];
}

/**
 获取网络时间

 @param timeout 超时时间
 @return 如果超时，返回本地时间
 */
+ (NSDate *)tt_getNetworkDateByTimeout:(NSInteger)timeout {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: timeout];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    NSDate* inputDate = [NSDate tt_dateFromInternetDateTimeString:date formatHint:TTDateFormatHintRFC822];
    //设置源日期时区
    //    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //    //设置转换后的目标日期时区
    //    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //    //得到源日期与世界标准时间的偏移量
    //    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:inputDate];
    //    //目标日期与本地时区的偏移量
    //    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:inputDate];
    //    //得到时间偏移量的差值
    //    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //    //转为现在时间
    //    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:inputDate];
    
    
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
    //    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
    return inputDate;
#pragma clang diagnostic pop
}


+ (NSDate *)tt_dateFromInternetDateTimeString:(NSString *)dateString
                                   formatHint:(TTDateFormatHint)hint {
    NSDate *date = nil;
    if (dateString) {
        if (hint != TTDateFormatHintRFC3339) {
            // Try RFC822 first
            date = [NSDate tt_dateFromRFC822String:dateString];
            if (!date) date = [NSDate tt_dateFromRFC3339String:dateString];
        } else {
            // Try RFC3339 first
            date = [NSDate tt_dateFromRFC3339String:dateString];
            if (!date) date = [NSDate tt_dateFromRFC822String:dateString];
        }
    }
    // Finished with date string
    return date;
}

+ (NSDate *)tt_dateFromRFC3339String:(NSString *)dateString {
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [NSDate tt_internetDateTimeFormatter];
        @synchronized(dateFormatter) {
            
            // Process date
            NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
            RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
            // Remove colon in timezone as it breaks NSDateFormatter in iOS 4+.
            // - see https://devforums.apple.com/thread/45837
            if (RFC3339String.length > 20) {
                RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":"
                                                                         withString:@""
                                                                            options:0
                                                                              range:NSMakeRange(20, RFC3339String.length-20)];
            }
            if (!date) { // 1996-12-19T16:39:57-0800
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27.87+0020
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possible invalid format.", dateString);
            
        }
    }
    // Finished with date string
    return date;
}
+ (NSDate *)tt_dateFromRFC822String:(NSString *)dateString {
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [NSDate tt_internetDateTimeFormatter];
        @synchronized(dateFormatter) {
            
            // Process
            NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
            if ([RFC822String rangeOfString:@","].location != NSNotFound) {
                if (!date) { // Sun, 19 May 2002 15:21:36 GMT
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21 GMT
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21:36
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
            } else {
                if (!date) { // 19 May 2002 15:21:36 GMT
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21 GMT
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21:36
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
            }
            if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possible invalid format.", dateString);
            
        }
    }
    // Finished with date string
    return date;
}

#pragma mark - private
+ (NSDateFormatter *)tt_internetDateTimeFormatter {
    @synchronized(self) {
        if (!_internetDateTimeFormatter) {
            NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            _internetDateTimeFormatter = [[NSDateFormatter alloc] init];
            [_internetDateTimeFormatter setLocale:en_US_POSIX];
            [_internetDateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
    }
    return _internetDateTimeFormatter;
}

@end
