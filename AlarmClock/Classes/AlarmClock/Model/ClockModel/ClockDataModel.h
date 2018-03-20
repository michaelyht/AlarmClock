//
//  ClockDataModel.h
//  JKHousekeeper
//
//  Created by Michael on 2017/7/31.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "HTBaseModel.h"

@interface ClockDataModel : HTBaseModel
//0 上午 1下午
@property (nonatomic, assign) int isSORX;
//格式
@property (nonatomic, strong) NSDate *timeValue;
//周几
@property (nonatomic, strong) NSArray *weeksStatus;
//是否开启 yes开启 no关闭
@property (nonatomic, assign) BOOL isOpen;
//备注信息
@property (nonatomic, strong) NSString *markString;
//本地通知标记
@property (nonatomic, strong) NSString *keyNotification;


@end
