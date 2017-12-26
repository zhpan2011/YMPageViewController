//
//  YMPageViewController.h
//  YMPageVC
//
//  Created by YanMao on 2017/8/10.
//  Copyright © 2017年 YanMao. All rights reserved.
//


/*
 使用方法:1 . 继承YMPageViewController
        2 . 添加childController , 必须设置childController的title , 否则报错 .
 
            //示例代码
            ChildVC *vc = [[ChildVC alloc] init];
            vc = @"张三";
            [self addChildViewController:vc];
 
 
        3 . 调用初始化设置方法 , 一次性设置所有属性
 
        作者 : MustangYM
 */

#import <UIKit/UIKit.h>

@protocol YMpageViewControllerDelegate <NSObject>

@optional


@end

@interface YMPageViewController : UIViewController

/**头部视图<必须指定frame>*/
@property(nonatomic, strong)UIView      *YM_HeaderView;

/**是否允许底部容器横向滚动*/ /**这个属性用得很少*/
@property(nonatomic, assign)BOOL         YM_isBottomScrollEnable;

/**
 初始化设置

 @param initBlock *titleNorBackgroundColor      标题正常背景颜色
                  *titleSelectBackgroundColor   标题被选中时的背景颜色
                  *headerHeight                 头部视图高度
                  *titleHeight                  标题栏的高度
                  *isNeedBounces                下部是否需要弹簧效果
 */
- (void)initWithYMPageViewController:(void(^)(UIColor **titleNormalBackgroundColor ,
                                              UIColor **titleSelectBackgroundColor ,
                                              CGFloat *headerHeight ,
                                              CGFloat *titleHeight ,
                                              BOOL    *isNeedBounces))initBlock;

@end
