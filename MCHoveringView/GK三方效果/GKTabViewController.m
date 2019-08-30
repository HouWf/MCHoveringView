//
//  GKTabViewController.m
//  MCHoveringView
//
//  Created by hzhy001 on 2019/8/21.
//  Copyright © 2019 MuYaQin. All rights reserved.
//

#import "GKTabViewController.h"


@interface GKTabViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation GKTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @[
                    @{
                        TitleKey:@"微博效果",
                        CtrKey:@"WBViewContoller"
                        },
                    @{
                        TitleKey:@"网易云音乐",
                        CtrKey:@"WYViewController"
                        },
                    @{
                        TitleKey:@"GK效果",
                        CtrKey:@"DYViewController"
                        }
                    ];
    self.dataSourceArray = self.titles;
    
}

@end
