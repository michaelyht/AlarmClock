//
//  VC_Weeks.h
//  JKHousekeeper
//
//  Created by Michael on 2017/7/30.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "WorkbenchBaseVC.h"

typedef void(^SelectWeekInfoBlock)(NSArray *stateArray);

@interface VC_Weeks : WorkbenchBaseVC

@property (nonatomic, copy) SelectWeekInfoBlock selectWeekInfoBlock;

@property (nonatomic, strong) NSArray *states;

@end
