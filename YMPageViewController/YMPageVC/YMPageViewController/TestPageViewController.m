//
//  TestPageViewController.m
//  YMPageVC
//
//  Created by YanMao on 2017/8/11.
//  Copyright © 2017年 YanMao. All rights reserved.
//

#import "TestPageViewController.h"
#import "TestTableOne.h"
#import "TestTableTwo.h"
#import "TestTableThree.h"
#import "TestOnlyViewController.h"

@interface TestPageViewController ()<UITableViewDelegate>

@end

@implementation TestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义头部
    UIView *tempHeaderView = [[UIView alloc] init];
    tempHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250 - 44);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EDC"]];
    imageView.frame = tempHeaderView.bounds;
    [tempHeaderView addSubview:imageView];
    
    
    //设置子控制器
    NSMutableArray *childViewControllersArray = [NSMutableArray array];
    TestTableOne *one = [[TestTableOne alloc] init];
    one.title = @"张三";
    [childViewControllersArray addObject:one];
    
    TestTableTwo *two = [[TestTableTwo alloc] init];
    two.title = @"李四";
    [childViewControllersArray addObject:two];
    
    TestTableThree *three = [[TestTableThree alloc] init];
    three.title = @"王五";
    [childViewControllersArray addObject:three];
    
    TestOnlyViewController *four = [[TestOnlyViewController alloc] init];
    four.title = @"view";
    [childViewControllersArray addObject:four];
    
    one.UITableViewScrollDidScroll = ^(UIScrollView *scrollView) {
        [self YMScrollViewDidScroll:scrollView];
    };
    
    two.UITableViewScrollDidScroll = ^(UIScrollView *scrollView) {
        [self YMScrollViewDidScroll:scrollView];
    };
    
    three.UITableViewScrollDidScroll = ^(UIScrollView *scrollView) {
        [self YMScrollViewDidScroll:scrollView];
    };
    
    //一次性初始化
    [self initWithYMPageViewController:^(UIView *__autoreleasing *headerView,
                                         NSArray *__autoreleasing *childViewControllers,
                                         UIColor *__autoreleasing *titleNormalBackgroundColor,
                                         UIColor *__autoreleasing *titleSelectBackgroundColor,
                                         BOOL *isNeedBounces) {
        *headerView = tempHeaderView;
        *childViewControllers = childViewControllersArray;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}

@end
