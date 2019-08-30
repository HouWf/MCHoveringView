//
//  MainTableViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "MainTableViewController.h"

#define TitleKey @"title"
#define CtrKey @"ctr"

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[
                    @{
                        TitleKey:@"顶部悬浮",
                        CtrKey:@"ViewController"
                        },
                    @{
                        TitleKey:@"头部背景固定",
                        CtrKey:@"HeaderViewController"
                        },
                    @{
                        TitleKey:@"GK效果",
                        CtrKey:@"GKTabViewController"
                        }
                    ];
    
    self.dataSourceArray = self.titles;
}

@end
