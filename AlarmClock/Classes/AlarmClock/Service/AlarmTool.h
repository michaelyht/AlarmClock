//
//  AlarmTool.h
//  JKHousekeeper
//
//  Created by Michael on 2017/8/1.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClockDataModel;

@interface AlarmTool : NSObject

+ (instancetype)sharedSingleton;

- (void)setRemindTimeWithData:(ClockDataModel *)model;
- (void)cancelNotification:(ClockDataModel *)model;

@end
