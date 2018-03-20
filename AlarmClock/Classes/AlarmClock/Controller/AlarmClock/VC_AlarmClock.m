//
//  VC_AlarmClock.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/28.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "VC_AlarmClock.h"
#import "VC_ClockInfo.h"

#import "Cell_AlarmClock.h"

#import "AlarmTool.h"
#import "ClockDeployInfo.h"


@interface VC_AlarmClock ()<UITableViewDelegate,
UITableViewDataSource>{
//    NSArray *_dataArray;
    
    //ui
    __weak IBOutlet UIButton *bntAdd;
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UIButton *bntAdd2;
    __weak IBOutlet UIButton *_bntEidt;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString * const cell_idnentity = @"Cell_AlarmClock";

@implementation VC_AlarmClock

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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell_AlarmClock *cell = [tableView dequeueReusableCellWithIdentifier:cell_idnentity];
    cell.clickBlock = ^(NSInteger index, BOOL isOpen) {
        [self dealOpenORClose:isOpen index:index];
    };
    cell.tag = indexPath.row;
    [cell updateViewWithData:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.editing) {
        [self jupeToClockInfoWith:1 index:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ClockDataModel *model = self.dataArray[indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [[AlarmTool sharedSingleton] cancelNotification:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[TMCache sharedCache] setObject:self.dataArray forKey:LOCK_CLOCK_TIME];
        [self.tableView reloadData];
        [self updateViewDisplay];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - button click
- (IBAction)bntClick:(id)sender {
    UIButton *bnt = (UIButton *)sender;
    if (bnt.tag == 0) {//返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (bnt.tag == 1){//编辑
        //刷新列表
        [self.tableView reloadData];
        //如果当前正在编辑
        if (self.tableView.editing) {
            [_bntEidt setTitle:@"编辑" forState:UIControlStateNormal];
            [self.tableView setEditing:NO animated:YES];
        }else{
            [_bntEidt setTitle:@"完成" forState:UIControlStateNormal];
            [self.tableView setEditing:YES animated:YES];
        }
    }else if (bnt.tag == 2){//添加 上
        [self jupeToClockInfoWith:0 index:0];
    }else{//添加下
        [self jupeToClockInfoWith:0 index:0];
    }
}

#pragma mark - private mehtods
- (void)initData{
    NSArray *arr = [[TMCache sharedCache] objectForKey:LOCK_CLOCK_TIME];
//    [self.dataArray addObjectsFromArray:arr];
    
    //处理数据同步问题
    [self dealDataTBWithData:arr];
}

- (void)configUI{
    //table 背景
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor viewBGColor]];
    self.tableView.backgroundView = view;
    //注册cell
    UINib *nib = [UINib nibWithNibName:cell_idnentity bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cell_idnentity];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsSelection = NO;
    
    //初始化view
    bntAdd.layer.borderColor = [UIColor textTitleColor].CGColor;
    bntAdd.layer.borderWidth = 1.f;
    bntAdd.layer.cornerRadius = 5.f;
    bntAdd.layer.masksToBounds = YES;

    //更具数据来确定是否要显示
    [self updateViewDisplay];
    
}

- (void)jupeToClockInfoWith:(int)tag index:(NSInteger)indx{
    [_bntEidt setTitle:@"编辑" forState:UIControlStateNormal];
    [self.tableView setEditing:NO animated:YES];
    VC_ClockInfo *clockInfo = [[VC_ClockInfo alloc] initWithNibName:@"VC_ClockInfo" bundle:nil];
    clockInfo.clockmodel =  tag == 0 ? nil : self.dataArray[indx];
    clockInfo.vc_tag = tag;
    clockInfo.index = indx;
    clockInfo.updateViewBlock = ^(NSArray *datas) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:datas];
        //更具数据来确定是否要显示
        [self updateViewDisplay];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:clockInfo animated:YES];
}

- (void)updateViewDisplay{
    if (!_dataArray || _dataArray.count == 0) {
        _bgView.hidden = NO;
        bntAdd2.hidden = YES;
        _bntEidt.hidden = YES;
    }else{
        _bgView.hidden = YES;
        bntAdd2.hidden = NO;
        _bntEidt.hidden = NO;
    }
}

- (void)dealOpenORClose:(BOOL)isOpen index:(NSInteger)index{
    
    ClockDataModel *model = self.dataArray[index];
    if (!model) {
        return;
    }
    if (isOpen) {
        [[AlarmTool sharedSingleton] setRemindTimeWithData:model];
    }else{
        [[AlarmTool sharedSingleton] cancelNotification:model];
    }
    model.isOpen = isOpen;
    [self.dataArray replaceObjectAtIndex:index withObject:model];
    [[TMCache sharedCache] setObject:self.dataArray forKey:LOCK_CLOCK_TIME];
}


//处理数据同步问题
- (void)dealDataTBWithData:(NSArray *)array{
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ClockDataModel *cl = obj;
        __block BOOL isYC = YES;
        [cl.weeksStatus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj boolValue]) {
                isYC = NO;
            }
        }];
        
        int timeV = [cl.timeValue timeIntervalSince1970];
        int timeCurrent = [[NSDate date] timeIntervalSince1970];
        
        if (isYC && timeCurrent >= timeV) {
            cl.isOpen = NO;
        }
        
        [self.dataArray addObject:cl];
    }];
}

#pragma mark - setter and getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
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
