//
//  Cell_ClockInfo.h
//  JKHousekeeper
//
//  Created by Michael on 2017/7/30.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_ClockInfo : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *txtMark;

- (void)updateViewWithRow:(NSInteger)row andValue:(NSString *)value;

@end
