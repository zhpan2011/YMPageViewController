//
//  TestTableThree.h
//  YMPageVC
//
//  Created by YanMao on 2017/8/11.
//  Copyright © 2017年 YanMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableThree : UITableViewController
@property(nonatomic , copy)void (^UITableViewScrollDidScroll)(UIScrollView *scrollView);
@end
