# YMPageViewController
Keep DA Dream Alive
# A pleasant four direction sliding page solution
![Picure Crash](https://github.com/MustangYM/YMPageViewController/blob/master/YMPageViewController/YMPageVC/2017-12-27%2015_56_14.gif)

＃How to use it

> Makesure your controller inherit YMPageViewController    
```
//一次性初始化
    [self initWithYMPageViewController:^(UIView *__autoreleasing *headerView,
                                         NSArray *__autoreleasing *childViewControllers,
                                         UIColor *__autoreleasing *titleNormalBackgroundColor,
                                         UIColor *__autoreleasing *titleSelectBackgroundColor,
                                         BOOL *isNeedBounces) {
        *headerView = tempHeaderView;
        *childViewControllers = childViewControllersArray;
    }];
   
```
