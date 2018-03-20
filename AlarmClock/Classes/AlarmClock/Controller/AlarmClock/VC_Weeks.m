
//
//  VC_Weeks.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/30.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "VC_Weeks.h"

#import "Cell_Week.h"

@interface VC_Weeks ()<UITableViewDataSource,
UITableViewDelegate>{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *stateArray;

@end

static NSString * const cell_identity = @"Cell_Week";

@implementation VC_Weeks

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

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell_Week *cell = [tableView dequeueReusableCellWithIdentifier:cell_identity];
    cell.lblName.text = _dataArray[indexPath.row];
    if ([self.stateArray[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Cell_Week *cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL state = [self.stateArray[indexPath.row] boolValue];
    if (state) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [self.stateArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!state]];
}

#pragma mark -
- (IBAction)bntClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (_selectWeekInfoBlock) {
        _selectWeekInfoBlock(self.stateArray);
    }
}

#pragma mark - private methods
- (void)initData{
    _dataArray = @[@"每周日", @"每周一", @"每周二", @"每周三", @"每周四", @"每周五", @"每周六"];
    if (self.stateArray.count != 0) {
        return;
    }
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.stateArray addObject:[NSNumber numberWithBool:NO]];
    }];
}

- (void)configUI{
    //table 背景
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor viewBGColor]];
    self.tableView.backgroundView = view;
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:cell_identity bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cell_identity];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - getter and setter
- (NSMutableArray *)stateArray{
    if (!_stateArray) {
        NSArray *datas = _states;
        if (!datas) {//去空
            datas = [[NSArray alloc] init];
        }
        _stateArray = [[NSMutableArray alloc] initWithArray:datas];
    }
    return _stateArray;
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
