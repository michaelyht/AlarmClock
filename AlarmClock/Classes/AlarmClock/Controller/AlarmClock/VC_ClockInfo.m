//
//  VC_ClockInfo.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/30.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "VC_ClockInfo.h"
#import "VC_Weeks.h"

#import "Cell_ClockInfo.h"

#import "AlarmTool.h"
#import "ClockDataTool.h"
#import "ClockDeployInfo.h"


@interface VC_ClockInfo ()<UITableViewDataSource,
UITableViewDelegate>{
    UITextField *_temTxt;//备注信息
    
    ClockDataModel *_clockModel;
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//选中时间
@property(strong,nonatomic)NSDate *selectedDate;

@end

static NSString * const cell_identity = @"Cell_ClockInfo";

@implementation VC_ClockInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell_ClockInfo *cell = [tableView dequeueReusableCellWithIdentifier:cell_identity];
    if (indexPath.row == 1) {
        _temTxt = cell.txtMark;
    }
    [cell updateViewWithRow:indexPath.row andValue:indexPath.row == 0 ? [[ClockDataTool sharedSingleton] getWeekStringWithStates:_clockModel.weeksStatus] : _temTxt.text];
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        VC_Weeks *vcWeek = [[VC_Weeks alloc] initWithNibName:@"VC_Weeks" bundle:nil];
        vcWeek.states = _clockModel.weeksStatus;
        __weak typeof(self) weakSelf = self;
        vcWeek.selectWeekInfoBlock = ^(NSArray *stateArray) {
            if (!stateArray || stateArray.count == 0) {
                return ;
            }
            _clockModel.weeksStatus = stateArray;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vcWeek animated:YES];
    }
}

#pragma mark - button click
- (IBAction)bntClick:(id)sender {
    UIButton *bnt = (UIButton *)sender;
    if (bnt.tag == 0) {//返回
        [self.navigationController popViewControllerAnimated:YES];
    }else{//存储
        if (self.clockmodel) {//如果之前的存在就将其移除
            [[AlarmTool sharedSingleton] cancelNotification:self.clockmodel];
        }
        _clockModel.markString = _temTxt.text;
        _clockModel.isOpen = YES;
        //添加通知
        [[AlarmTool sharedSingleton] setRemindTimeWithData:_clockModel];
        //缓存
        NSArray *array = [[TMCache sharedCache] objectForKey:LOCK_CLOCK_TIME];
        NSMutableArray *clockArray = [[NSMutableArray alloc] initWithArray:array];
        if (_vc_tag == 0) {
            [clockArray addObject:_clockModel];
        }else{
            [clockArray replaceObjectAtIndex:_index withObject:_clockModel];
        }
        [[TMCache sharedCache] setObject:clockArray forKey:LOCK_CLOCK_TIME];
        if (_updateViewBlock) {
            _updateViewBlock(clockArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private mehtods
- (void)initData{
    _clockModel = self.clockmodel;
    if (!_clockModel) {
        _clockModel = [ClockDataModel new];
    }
}

- (void)configUI{
    //table 背景
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor viewBGColor]];
    self.tableView.backgroundView = view;
    
    [self.tableView setTableHeaderView:self.datePicker];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:cell_identity bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cell_identity];
}

#pragma mark - setter and getter
- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220.f)];
        _datePicker.backgroundColor = [UIColor viewBGColor];
        [_datePicker setValue:[UIColor textTitleColor] forKey:@"textColor"];
        // 设置线条颜色
//        for (UIView *view in _datePicker.subviews) {
//            if ([view isKindOfClass:[UIView class]]) {
//                for (UIView *subView in view.subviews) {
//                    if (subView.frame.size.height < 5) {
//                        subView.backgroundColor = [UIColor whiteColor];
//                    }
//                }
//            }
//        }
        if (_clockModel.timeValue == nil) {
            self.selectedDate = [NSDate date];
        }else{
            self.selectedDate = _clockModel.timeValue;
        }
        _datePicker.date = self.selectedDate;
        _clockModel.timeValue = self.selectedDate;
        
        _datePicker.datePickerMode = UIDatePickerModeTime;
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    }
    return _datePicker;
}

-(void)datePickerValueChanged:(id)sender{
    self.selectedDate = [self.datePicker date];
    NSLog(@"date: %@", self.selectedDate);
//    [self.tableView reloadData];
    _clockModel.timeValue = self.selectedDate;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
