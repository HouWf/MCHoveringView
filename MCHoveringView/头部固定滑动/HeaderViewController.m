//
//  HeaderViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/8.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "HeaderViewController.h"
#import "HeaderService.h"

@interface HeaderViewController ()

@end

@implementation HeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"底部固定可滚动视图";
    HeaderService *service = [[HeaderService alloc] init];
    self.view = service;
}

@end
