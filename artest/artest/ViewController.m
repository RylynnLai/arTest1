//
//  ViewController.m
//  artest
//
//  Created by LLZ on 2017/10/31.
//  Copyright © 2017年 LLZ. All rights reserved.
//

#import "ViewController.h"
#import "ARViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"AR-plant" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 100, 30)];
    [btn setCenter:self.view.center];
    [btn addTarget:self action:@selector(toARPlant) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)toARPlant
{
    ARViewController *vc = [ARViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
