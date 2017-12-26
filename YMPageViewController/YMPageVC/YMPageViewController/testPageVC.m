//
//  testPageVC.m
//  YMPageVC
//
//  Created by YanMao on 2017/8/11.
//  Copyright © 2017年 YanMao. All rights reserved.
//

#import "testPageVC.h"
#import "tableOne.h"
#import "tableTwo.h"
#import "tableThree.h"
#import "viewController.h"

@interface testPageVC ()<UITableViewDelegate>

@end

@implementation testPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一次性初始化
    [self initWithYMPageViewController:^(UIColor *__autoreleasing *titleNormalBackgroundColor, UIColor *__autoreleasing *titleSelectBackgroundColor, CGFloat *headerHeight, CGFloat *titleHeight, BOOL *isNeedBounces) {
       
        *titleNormalBackgroundColor = [UIColor cyanColor];
        *titleSelectBackgroundColor = [UIColor redColor];
        *headerHeight = 250;
        *titleHeight = 44;
        *isNeedBounces = YES;
        
    }];
    
    //自定义头部
    UIView *tempHeaderView = [[UIView alloc] init];
    tempHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250 - 44);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EDC"]];
    imageView.frame = tempHeaderView.bounds;
    [tempHeaderView addSubview:imageView];
    self.YM_HeaderView = tempHeaderView;
    
    //设置子控制器
    tableOne *one = [[tableOne alloc] init];
    one.title = @"张三";
    [self addChildViewController:one];
    
    tableTwo *two = [[tableTwo alloc] init];
    two.title = @"李四";
    [self addChildViewController:two];
    
    tableThree *three = [[tableThree alloc] init];
    three.title = @"王五";
    [self addChildViewController:three];
    
    viewController *four = [[viewController alloc] init];
    four.title = @"view";
    [self addChildViewController:four];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
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
