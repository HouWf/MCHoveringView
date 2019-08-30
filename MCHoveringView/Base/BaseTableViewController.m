//
//  BaseTableViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.main_tableView];
    [self.main_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    [self.main_tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_identifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    cell.textLabel.text = self.dataSourceArray[indexPath.row][TitleKey];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[NSClassFromString(self.dataSourceArray[indexPath.row][CtrKey]) new] animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)main_tableView {
    if (!_main_tableView) {
        _main_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _main_tableView.dataSource = self;
        _main_tableView.delegate = self;
    }
    return _main_tableView;
}

@end
