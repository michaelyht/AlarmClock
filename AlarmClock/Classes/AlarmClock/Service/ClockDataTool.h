//
//  ClockDataTool.h
//  JKHousekeeper
//
//  Created by Michael on 2017/7/31.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockDataTool : NSObject

+ (instancetype)sharedSingleton;

- (NSString *)getWeekStringWithStates:(NSArray *)state;

@end
