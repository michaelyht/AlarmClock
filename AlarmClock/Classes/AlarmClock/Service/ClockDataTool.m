//
//  ClockDataTool.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/31.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "ClockDataTool.h"

@implementation ClockDataTool

//全局变量
static ClockDataTool * _instance = nil;
//单例方法
+ (instancetype)sharedSingleton{
    //系统的大多数类方法都有做autorelease，所以我们也需要做一下
    return [[self alloc] init];
}
//alloc会调用allocWithZone:
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}

#pragma mark - instance methods
- (NSString *)getWeekStringWithStates:(NSArray *)state{
    if (!state || state.count == 0) {
        return @"永不";
    }
    
    NSMutableArray *stringDate = [[NSMutableArray alloc] initWithCapacity:0];
    [state enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *temString = nil;
        switch (idx) {
            case 0:
                if ([obj boolValue]) {
                    temString  = @"周日";
                }
                break;
            case 1:
                if ([obj boolValue]) {
                    temString  = @"周一";
                }
                break;
            case 2:
                if ([obj boolValue]) {
                    temString  = @"周二";
                }
                break;
            case 3:
                if ([obj boolValue]) {
                    temString  = @"周三";
                }
                break;
            case 4:
                if ([obj boolValue]) {
                    temString  = @"周四";
                }
                break;
            case 5:
                if ([obj boolValue]) {
                    temString  = @"周五";
                }
                break;
            case 6:
                if ([obj boolValue]) {
                    temString  = @"周六";
                }
                break;
            default:
                break;
        }
        if (temString) {
            [stringDate addObject:temString];
        }
    }];
    
    if (!stringDate || stringDate.count == 0) {
        return @"永不";
    }
    
    NSInteger dateCount = stringDate.count;
    NSMutableString *weeksStr = [[NSMutableString alloc] initWithString:@""];
    
    switch (dateCount) {
        case 0:
        {
            [weeksStr setString:@"永不"];
            break;
        }
        case 2:
        {
            int weeksDayCount = 0;
            for (NSString *str in stringDate) {
                if ([str isEqualToString:@"周六"] || [str isEqualToString:@"周日"]) {
                    weeksDayCount ++;
                }
                [weeksStr appendFormat:@" %@",str];
            }
            if (weeksDayCount == 2) {
                [weeksStr setString:@"周末"];
            }
            break;
        }
        case 5:
        {
            int weeksDayCount = 0;
            for (NSString *str in stringDate) {
                if (![str isEqualToString:@"周六"] && ![str isEqualToString:@"周日"]) {
                    weeksDayCount ++;
                }
                [weeksStr appendFormat:@" %@",str];
            }
            if (weeksDayCount == 5) {
                [weeksStr setString:@"工作日"];
            }
            break;
        }
        case 7:
        {
            [weeksStr setString:@"每天"];
            break;
        }
        default:
        {
            for (NSString *str in stringDate) {
                [weeksStr appendFormat:@" %@",str];
            }
            break;
        }
    }

    return weeksStr;
}

@end
