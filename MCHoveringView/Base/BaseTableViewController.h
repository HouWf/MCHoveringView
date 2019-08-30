//
//  BaseTableViewController.h
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "BaseViewController.h"

#define TitleKey @"title"
#define CtrKey @"ctr"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *main_tableView;

@property (nonatomic, strong) NSArray *dataSourceArray;

@end

NS_ASSUME_NONNULL_END
