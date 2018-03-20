//
//  AlarmTool.m
//  JKHousekeeper
//
//  Created by Michael on 2017/8/1.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "AlarmTool.h"
#import "ClockDataModel.h"


#define LOCAL_NOTIFY_SCHEDULE_ID @"LOCAL_NOTIFY_SCHEDULE_ID"
#define LOCAL_INFO               @"该起床咯！小懒猪"

@implementation AlarmTool

//全局变量
static AlarmTool * _instance = nil;
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

- (void)setRemindTimeWithData:(ClockDataModel *)model{
    if (!model) {
        return;
    }
    //通知的id
    __block NSString *keyString = @"";
    //哪些天需要重复发 1 周日 2周一 3周二 以此类推。。。
    NSArray *cfArray = [self getCFArrayWithStateArray:model.weeksStatus];
    //提示文本
    NSString *tsString = [self dealNILWithString:model.markString];
    
    if ([self isYBWithStatee:cfArray]) {//是不是永不状态
        NSDate *pTime = model.timeValue;
        keyString = model.keyNotification;
        int timeV = [pTime timeIntervalSince1970];
        int timeCurrent = [[NSDate date] timeIntervalSince1970];
        if (timeCurrent > timeV) {//第二天提醒
            timeV = timeV + 36000*24;
            pTime = [NSDate dateWithTimeIntervalSince1970:timeV];
        }else{//当天提醒
        }
        //只播放一次的需要进行关闭
        //注册通知
        [self scheduleNotificationWithItem:tsString fireDate:pTime isRpeat:NO keyInfo:keyString];
    }else{
        //时间 发起提醒的时间
        __block NSDateComponents *comp = nil;
        [cfArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int weedDay = [obj intValue];
            keyString  = [NSString stringWithFormat:@"%@_%d",model.keyNotification,weedDay];
            comp = [self getDateXJWith:model.timeValue];
            NSDate *pTime = [self getNextWeekDay:weedDay hour:(int)comp.hour minute:(int)comp.minute];
            [self scheduleNotificationWithItem:tsString fireDate:pTime isRpeat:YES keyInfo:keyString];
        }];
    }
    
}


- (void)cancelNotification:(ClockDataModel *)model{
    //取消通知
    //获取当前所有的本地通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notificaitons || notificaitons.count <= 0){
        return;
    }
    //取消一个特定的通知
    for (UILocalNotification *notify in notificaitons){
        __block NSString *keyString = @"";
        //哪些天需要重复发 1 周日 2周一 3周二 以此类推。。。
        NSArray *cfArray = [self getCFArrayWithStateArray:model.weeksStatus];
        if ([self isYBWithStatee:cfArray]) {//是不是永不状态
            keyString = model.keyNotification;
            if ([[notify.userInfo objectForKey:@"id"] isEqualToString:keyString]){
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
            }
        }else{
            [cfArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                int weedDay = [obj intValue];
                keyString  = [NSString stringWithFormat:@"%@_%d",model.keyNotification,weedDay];
                if ([[notify.userInfo objectForKey:@"id"] isEqualToString:keyString]){
                    [[UIApplication sharedApplication] cancelLocalNotification:notify];
                }
            }];
        }
    }
}

#pragma mark - private methods
/**
 *  获取下一个新的星期日期
 *
 *  @param newWeekDay 星期数值从周日算起,星期日1/星期一2/星期二3...星期六7
 *  @param hour       设定的小时值
 *  @param minute     设定的分钟值
 *
 *  @return返回新的日期(NSDate对象)
 */

- (NSDate *)getNextWeekDay:(int)newWeekDay hour:(int)hour minute:(int)minute{
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|
                                     NSCalendarUnitDay|
                                     NSCalendarUnitHour|
                                     NSCalendarUnitMinute|
                                     NSCalendarUnitSecond   fromDate:[NSDate date]];
    NSLog(@"设置的components = %@", components);
    
    NSLog(@"设置的weekday = %d", newWeekDay);
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitYear |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter;
    
    comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:0];
    
    NSLog(@"设置的comps = %@", comps);
    int temp = 0;
    int days = 0;
    
    temp = newWeekDay - (int)components.weekday;
    days = (temp >= 0 ? temp : temp + 7);
    NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
    return newFireDate;
}



/**
 判断是否为永不重复

 @param stateArray 重复的星期
 @return  判断是否为永不重复 yes是  no不是
 */
- (BOOL)isYBWithStatee:(NSArray *)stateArray{
    if (!stateArray || stateArray.count == 0) {
        return YES;
    }
    return NO;
}

//需要提醒的天
- (NSArray *)getCFArrayWithStateArray:(NSArray *)states{
    if (!states || states.count == 0) {
        return nil;
    }
    NSMutableArray *cfArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [states enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isOpen = [obj boolValue];
        
        if (isOpen) {
            int weeedDay = (int)idx + 1;
            [cfArray addObject:[NSNumber numberWithInt:weeedDay]];
        }
    }];
    return cfArray;
}

//处理空的字符串
- (NSString *)dealNILWithString:(NSString *)string{
    if (!string || [string isEqualToString:@""]) {
        return LOCAL_INFO;
    }
    return string;
}

//获取指定时间的具体年、月、日、天。。。。
- (NSDateComponents *)getDateXJWith:(NSDate *)date{
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitYear |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter;
    
    comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    
    return comps;
}

- (void)scheduleNotificationWithItem:(NSString *)alertItem
                            fireDate:(NSDate*)date
                             isRpeat:(BOOL)isRpeat
                             keyInfo:(NSString *)keyInfo{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    //初始化
    UILocalNotification *locationNotification = [[UILocalNotification alloc] init];
    locationNotification.fireDate = date;
    NSLog(@"***********time**********%@",locationNotification.fireDate);
    locationNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置重复周期
    locationNotification.repeatInterval = isRpeat ? NSCalendarUnitWeekday : 0;
    //设置通知的音乐
    locationNotification.soundName = @"jiancha.m4a";//UILocalNotificationDefaultSoundName;
    //设置通知内容
    locationNotification.alertBody = alertItem;
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:keyInfo,@"id",nil];
    locationNotification.userInfo = infoDic;
    //执行本地推送
    [[UIApplication sharedApplication] scheduleLocalNotification:locationNotification];
}

@end
