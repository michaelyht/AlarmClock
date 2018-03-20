//
//  WorkbenchBaseVC.m
//  JKHousekeeper
//
//  Created by Michael on 2017/7/26.
//  Copyright © 2017年 Lingday. All rights reserved.
//

#import "WorkbenchBaseVC.h"

@interface WorkbenchBaseVC ()

@end

@implementation WorkbenchBaseVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
