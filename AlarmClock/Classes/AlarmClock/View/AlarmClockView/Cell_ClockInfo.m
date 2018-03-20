//
//  Cell_ClockInfo.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/30.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "Cell_ClockInfo.h"

@interface Cell_ClockInfo(){
    
    __weak IBOutlet UIImageView *jiantouImage;
//    __weak IBOutlet UITextField *txtMark;
    __weak IBOutlet UIView *lineView;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblValue;
}
@end

@implementation Cell_ClockInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleGray;
//    [_txtMark setPlaceholder:[UIColor grayBntColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewWithRow:(NSInteger)row andValue:(NSString *)value{
    if (row == 0) {
        [lineView setHidden:YES];
        [_txtMark setHidden:YES];
        [lblName setText:@"重复"];
        if (!value || [value isEqualToString:@""]) {
            [lblValue setText:@"永不"];
            return;
        }
        [lblValue setText:value];
    }else{
        [lblValue setHidden:YES];
        [jiantouImage setHidden:YES];
        
        [lblValue setText:@"备注"];
        [_txtMark setText:value];
    }
}



@end
