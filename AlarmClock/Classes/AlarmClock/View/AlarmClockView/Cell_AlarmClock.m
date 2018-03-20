//
//  Cell_AlarmClock.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/28.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "Cell_AlarmClock.h"
#import "ClockDataModel.h"
#import "ClockDataTool.h"


#import "NSDate+TTExt2Format.h"

@interface Cell_AlarmClock(){

    __weak IBOutlet UILabel *_lblWeek;
    __weak IBOutlet UILabel *_lblTime;
    __weak IBOutlet UILabel *lblSXW;
    __weak IBOutlet UISwitch *bntSwitch;
}

@end

@implementation Cell_AlarmClock

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - swichClick
- (IBAction)switchClick:(id)sender {
    UISwitch *swich = (UISwitch *)sender;
    if (swich.isOn) {
        _lblTime.textColor = [UIColor textTitleColor];
    }else{
        _lblTime.textColor = [UIColor grayBntColor];
    }
    
    if (_clickBlock) {
        _clickBlock(self.tag, swich.isOn);
    }
}

#pragma mark - instance methods

- (void)updateViewWithData:(ClockDataModel *)model{
    if (!model) {
        return;
    }
    _lblWeek.text = [[ClockDataTool sharedSingleton] getWeekStringWithStates:model.weeksStatus];
    NSDate *timeDate = model.timeValue;
    
    int hours = [[timeDate tt_stringWithFormat:@"HH"] intValue];
    if (hours >= 12) {
        lblSXW.text = @"下午";
    }else{
        lblSXW.text = @"上午";
    }
    
    _lblTime.text = [timeDate tt_stringWithFormat:@"hh:mm"];
    
    [bntSwitch setOn:model.isOpen animated:YES];
    if (bntSwitch.isOn) {
        _lblTime.textColor = [UIColor textTitleColor];
    }else{
        _lblTime.textColor = [UIColor grayBntColor];
    }
}


#pragma mark - private methods

@end
