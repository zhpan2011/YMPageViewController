//
//  mainVC.m
//  YMPageVC
//
//  Created by YanMao on 2017/8/10.
//  Copyright © 2017年 YanMao. All rights reserved.
//
#define YMBounds [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


#import "mainVC.h"
#import "YMPageViewController.h"
#import "TestPageViewController.h"
@interface mainVC ()

@end

@implementation mainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2 - 25, SCREEN_HEIGHT / 2, 50, 25)];
    [centerBtn setTitle:@"进入" forState:UIControlStateNormal];
    [centerBtn sizeToFit];
    [self.view addSubview:centerBtn];
    [centerBtn addTarget:self action:@selector(jumpToPageVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)jumpToPageVC
{
    TestPageViewController *pageVC = [[TestPageViewController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
