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
        3 . 调用初始化设置方法 , 一次性设置所有属性
 
        作者 : MustangHZ
 */

#import <UIKit/UIKit.h>

@protocol YMPageViewControllerDelegate <NSObject>

@optional


@end

@interface YMPageViewController : UIViewController


/**是否允许底部容器横向滚动*/ /**这个属性用得很少*/
@property(nonatomic, assign)BOOL         YM_isBottomScrollEnable;

/**
 初始化设置

 @param initBlock *headerView                   头部视图(必须设置头部视图的frame)
                  *childViewControllers         子控制器的个数
                  *titleNorBackgroundColor      标题正常背景颜色
                  *titleSelectBackgroundColor   标题被选中时的背景颜色
                  *isNeedBounces                头部是否需要弹簧效果
 */
- (void)initWithYMPageViewController:(void(^)(UIView  **headerView,
                                              NSArray **childViewControllers,
                                              UIColor **titleNormalBackgroundColor ,
                                              UIColor **titleSelectBackgroundColor ,
                                              BOOL    *isNeedBounces))initBlock;

@end
