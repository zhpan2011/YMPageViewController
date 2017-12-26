//
//  viewController.m
//  YMPageVC
//
//  Created by YanMao on 2017/8/15.
//  Copyright © 2017年 YanMao. All rights reserved.
//

#import "viewController.h"

@interface viewController () <UIScrollViewDelegate>

@end

@implementation viewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.frame = self.view.bounds;
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
    scrollview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scrollview];
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor yellowColor];
    redView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    [scrollview addSubview:redView];
    
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.frame = CGRectMake(0, 0, 20, 20);
    [redView addSubview:blueView];
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
