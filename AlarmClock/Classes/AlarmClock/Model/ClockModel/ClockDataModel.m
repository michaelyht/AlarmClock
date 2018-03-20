//
//  ClockDataModel.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/31.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "ClockDataModel.h"
#import "NSDate+TTExt2Format.h"

@implementation ClockDataModel
//设置通知标签
- (void)setTimeValue:(NSDate *)timeValue{
    if (!timeValue) {
        return;
    }
    _timeValue = timeValue;
    _keyNotification = [NSDate tt_stringWithDate:_timeValue format:@"yyyyMMddHHmmss"];
}

- (NSString *)keyNotification{
    return _keyNotification;
}




@end
