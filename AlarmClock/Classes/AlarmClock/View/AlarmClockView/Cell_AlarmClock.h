//
//  Cell_AlarmClock.h
//  JKHousekeeper
//
//  Created by Michael on 2017/7/28.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClockDataModel;

typedef void(^SwicthClickBlock)(NSInteger index, BOOL isOpen);

@interface Cell_AlarmClock : UITableViewCell

@property (nonatomic, copy) SwicthClickBlock clickBlock;

- (void)updateViewWithData:(ClockDataModel *)model;

@end
