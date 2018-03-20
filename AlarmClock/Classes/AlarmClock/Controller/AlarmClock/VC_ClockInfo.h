//
//  VC_ClockInfo.h
//  JKHousekeeper
//
//  Created by Michael on 2017/7/30.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "WorkbenchBaseVC.h"

#import "ClockDataModel.h"

typedef void(^UpdateViewWithDataBlock)(NSArray *datas);

@interface VC_ClockInfo : WorkbenchBaseVC


/**
 vc_tag == 0,表示增加
 vc_tag == 1,表示修改 修改的时候需要用到index的值
 */
@property (nonatomic, assign) int vc_tag;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ClockDataModel *clockmodel;

@property (nonatomic, copy) UpdateViewWithDataBlock updateViewBlock;

@end
