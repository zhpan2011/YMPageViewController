//
//  YMPageViewController.m
//  YMPageVC
//
//  Created by YanMao on 2017/8/10.
//  Copyright © 2017年 YanMao. All rights reserved.
//
//打印
#ifdef DEBUG
#define DeLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DeLog(...)
#endif

// 屏幕尺寸
#define HZBounds [UIScreen mainScreen].bounds
// 屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
// 字符串是否为空
#define isStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref)isEqualToString:@""]))
// 抛出异常
#define kException(_ref) [[NSException exceptionWithName:@"YMPageViewController" reason:(_ref) userInfo:nil] raise]
// 三元色
#define HZRGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//16进制颜色
#define kHexColor(rgbValue , a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
// 懒加载
#define HZ_LAZY(object, assignment) (object = object ?: assignment)

//头部高度
#define Head_H 38
//标题栏高度
#define Title_H 38
//导航栏高度
#define Nav_H (SCREEN_HEIGHT == 812.0 ? 88 : 64)
//标题正常颜色
#define TitleNormalBackgroundColor kHexColor(0xE1E1E1 , 1.0)
//标题选中颜色
#define TitleSelectBackgroundColor kHexColor(0x3398FD , 1.0)

#import "YMPageViewController.h"

@interface YMPageViewController ()<UIScrollViewDelegate>
/**头部view容器*/
@property(nonatomic, strong)UIView                  *headerView;
/**标题view容器*/
@property(nonatomic, strong)UIView                  *sectionTitleView;
/**底部容器*/
@property(nonatomic, strong)UIScrollView            *bottomScrollView;
/**子控制器个数*/
@property(nonatomic, assign)NSInteger               childCount;
/**标题数组*/
@property(nonatomic, strong)NSMutableArray          *titleAry;
/**子view数组*/
@property(nonatomic, strong)NSMutableArray          *childViewAry;


/**当前滚动到第几个*/
@property(nonatomic, assign)NSInteger               NOW_INDEX;
/**滚动的上一个Label*/
@property(nonatomic, strong)UILabel                 *perLabel;

/**标题正常背景颜色*/
@property(nonatomic, strong)UIColor                 *labelGrayColor;
/**标题选中背景颜色*/
@property(nonatomic, strong)UIColor                 *labelBGColor;
/**头部高度*/
@property(nonatomic, assign)CGFloat                 Header_H;
/**标题栏高度*/
@property(nonatomic, assign)CGFloat                 SectionTitleView_H;
/**是否需要弹簧效果*/
@property(nonatomic, assign)BOOL                    isNeedBounces;
/**子控制器数组*/
@property(nonatomic, strong)NSArray                 *childViewcontrollersAry;
/**头部视图<必须指定frame>*/
@property(nonatomic, strong)UIView                  *HZ_HeaderView;
/**网络等待view*/
@property(nonatomic, strong)UIView                  *loadingView;

@end

@implementation YMPageViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)initial
{
    // 初始化标题高度
    self.Header_H = Head_H;
    self.SectionTitleView_H = Title_H;
    self.isNeedBounces = NO;
    
    self.YM_isBottomScrollEnable = YES;
//    self.Use UIScrollView's contentInsetAdjustmentBehavior instead = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingView];
}

- (void)HZ_load{
    [self.loadingView removeFromSuperview];
    [self setupAeraView];
    [self setupChild];
}

- (void)setupChild{
    
    _childCount = self.childViewcontrollersAry.count;
    NSLog(@"我的底部");
    if (_childCount == 0) return;
    
    [self setupTitle];
    
    [self setupChildView];
    
    CGFloat H = 0;
    if (!self.HZ_HeaderView) { // 如果没有传headerview进来,那么头部就没有
        H = _SectionTitleView_H;
    }else{
        H = _Header_H;
    }
    self.headerView.frame = CGRectMake(0, Nav_H, SCREEN_WIDTH, H);
    self.sectionTitleView.frame = CGRectMake(0, CGRectGetHeight(self.headerView.frame) - _SectionTitleView_H, SCREEN_WIDTH, self.SectionTitleView_H);
    self.sectionTitleView.backgroundColor = self.labelGrayColor;
    self.bottomScrollView.scrollEnabled = self.YM_isBottomScrollEnable;
    
    self.HZ_HeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, H - _SectionTitleView_H);
    [self.headerView insertSubview:self.HZ_HeaderView belowSubview:_sectionTitleView];
}

#pragma mark - 添加三大块父view
- (void)setupAeraView
{
    [self.view addSubview:self.bottomScrollView];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.sectionTitleView];
}

#pragma mark - 初始化设置
- (void)initWithYMPageViewController:(void (^)(UIView *__autoreleasing * ,NSArray *__autoreleasing *,UIColor *__autoreleasing *, UIColor *__autoreleasing *, BOOL *))initBlock
{
    UIView  *tempHeader;                         //头部视图
    UIColor *tempTitleNorBackgroundColor;       //子控制器数组
    UIColor *tempTitleSelectBackgroundColor;    //标题正常颜色
    NSArray *tempChildviewControllers;          // 标题选中颜色
    if (initBlock) {
        initBlock(&tempHeader , &tempChildviewControllers , &tempTitleNorBackgroundColor , &tempTitleSelectBackgroundColor , &_isNeedBounces);
        
        if (tempHeader) {
            self.HZ_HeaderView = tempHeader;
            CGFloat height = tempHeader.frame.size.height;
            _Header_H = height;
        }else {
            _Header_H = Title_H;
        }
        
        if (tempChildviewControllers) {
            self.childViewcontrollersAry = tempChildviewControllers;
        }
        
        if (tempTitleNorBackgroundColor) {
            self.labelGrayColor = tempTitleNorBackgroundColor;
        }else{
            self.labelGrayColor = TitleNormalBackgroundColor;
        }
        
        if (tempTitleSelectBackgroundColor) {
            self.labelBGColor = tempTitleSelectBackgroundColor;
        }else{
            self.labelBGColor = TitleSelectBackgroundColor;
        }
        
    }
    
    [self HZ_load];
}

#pragma mark - 设置标题宽度
- (void)setupTitle
{
    CGFloat titleWidth = 0;
    NSArray *titleAry = [self.childViewcontrollersAry valueForKeyPath:@"title"];
    
    for (NSString *title in titleAry) {
        if (isStrEmpty(title)) {
          kException(@"兄弟, 请先设置childController的title属性!");
        }
    }
    
    titleWidth = SCREEN_WIDTH / _childCount;
    
    CGFloat labelW = titleWidth;
    CGFloat labelH = _SectionTitleView_H;
    CGFloat labelY = 0;
    
    for (int i = 0 ; i < _childCount; i++) {
        
        UIViewController *vc = self.childViewcontrollersAry[i];
        UILabel *titlelabel = [self makeLabelWithTitle:vc.title];
        CGFloat labelX = i * labelW;
       
        titlelabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [self.sectionTitleView addSubview:titlelabel];
        [self.titleAry addObject:titlelabel];
        
        titlelabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeView:)];
        [titlelabel addGestureRecognizer:tapGes];
        UIView *temp = [tapGes view];
        temp.tag = i;
        
        if (i == 0) {
            titlelabel.backgroundColor = _labelBGColor;
            titlelabel.textColor = [UIColor whiteColor];
            self.NOW_INDEX = 0;
            _perLabel = titlelabel;
        }
        
    }
    
}

#pragma mark - 点击Label切换
- (void)changeView:(id)sender
{
    UITapGestureRecognizer *tapGes = (UITapGestureRecognizer *)sender;
    self.NOW_INDEX = [tapGes view].tag;
    [self setTitleViewBackgroundColor];
    [_bottomScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * self.NOW_INDEX, 0) animated:YES];
    
}

#pragma mark - 设置子View
- (void)setupChildView
{

    self.bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _childCount, SCREEN_HEIGHT);
    for (int i = 0; i < _childCount; i++) {
        
        UIViewController *vc = self.childViewcontrollersAry[i];
        vc.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Nav_H);
        
        UIView *tempView;
        if ([vc.view isKindOfClass:[UITableView class]]) {//就是TableView
            
            UITableView *tableView = (UITableView *)vc.view;
            [self createTableHeadView:tableView];
            tempView = tableView;
            
        }else if ([vc.view isKindOfClass:[UIScrollView class]]){//就是ScrollView
            
            UIScrollView *scrollView = (UIScrollView *)vc.view;
            scrollView.delegate = self;
            if (self.isNeedBounces == YES) {
                scrollView.bounces = YES;
            }else{
                scrollView.bounces = NO;
            }
            tempView = scrollView;
            
        }else{ //就是View
            
            if (vc.view.subviews.count == 0) {//自控制器数为零
                
                tempView = vc.view;
                
            }else{//子控制器数不为零
                
                for (UIView *childView in vc.view.subviews) {//遍历
                    
                    if ([childView isKindOfClass:[UITableView class]]){ // 修复:控制器是UIViewController ,里面子控制器为UITableView,没有设置TableView的header的BUG
                        UITableView *tableView = (UITableView *)childView;
                        [self createTableHeadView:tableView];
                        tableView.contentInset = UIEdgeInsetsMake(0, 0, Nav_H, 0);
                        tempView = vc.view;
                    }else if (
                        [childView isKindOfClass:[UIScrollView class]] && //是scrollview
                        childView.frame.size.width > vc.view.frame.size.width * 0.8 && //宽度大于父view80%
                        childView.frame.size.height > vc.view.frame.size.height * 0.8
                        )
                    {
                        
                        UIScrollView *scrollView = (UIScrollView *)childView;
                        scrollView.delegate = self;
                        scrollView.frame = vc.view.frame;
                        tempView = scrollView;
                        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_Header_H, 0, 0, 0);
                        
                        for (UIView *sub in childView.subviews) { // 因为tableview有headerView , scrollview只能手动设置所有子view的偏移量
                            CGRect frame = sub.frame;
                            frame.origin.y += _Header_H;
                            sub.frame = frame;
                        }
                        
                    }else{
                        
                        UIView *view = (UIView *)vc.view;
                        tempView = view;
                        
                    }
                    
                }

            }
            
        }
        
        [tempView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self.childViewAry addObject:tempView];
        [self.bottomScrollView addSubview:tempView];
    }
    
}

#pragma mark - 创建头部视图
- (void)createTableHeadView:(UITableView *)tableView {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _Header_H)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = tableHeaderView;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[UIScrollView class]]) {
        [self observeScrollViewDidScroll:object];
    }
}

- (void)observeScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y; //向上0 --> 无限
    
    if (scrollView != _bottomScrollView) { // tableview
        
        CGRect frame = self.headerView.frame;
        frame.origin.y = -y + Nav_H;
        self.headerView.frame = frame;
        
        if (frame.origin.y < -(_Header_H - _SectionTitleView_H - Nav_H)){ // 控制上部极限
            frame.origin.y = -(_Header_H - _SectionTitleView_H - Nav_H);
            self.headerView.frame = frame;
        }
        
        if (self.isNeedBounces == NO) {// 控制下部极限
            if (frame.origin.y > Nav_H) {
                frame.origin.y = Nav_H;
                self.headerView.frame = frame;
            }
        }
        
        if (self.headerView.frame.origin.y > - (_Header_H - _SectionTitleView_H - Nav_H)) {
            [self setTableViewContentOfSet:scrollView.contentOffset isNeedAllToZero:YES];
        }
        
        [self setTableViewContentOfSet:scrollView.contentOffset isNeedAllToZero:false];
        
    }
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bottomScrollView) {
        DeLog(@"主view在滚动");
        CGFloat x = scrollView.contentOffset.x;
        self.NOW_INDEX = x / SCREEN_WIDTH;
        [self setTitleViewBackgroundColor];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _bottomScrollView) {
        return;
    }
    
    [self setTableViewContentOfSet:scrollView.contentOffset isNeedAllToZero:false];
}

#pragma mark - 所有Tableview/ScrollView的偏移量同步
- (void)setTableViewContentOfSet:(CGPoint)offset  isNeedAllToZero:(BOOL)isNeed{
    
    /*
     最核心 , 最难 ,都在这个方法.
     所以我尽量用空格隔开每一行,看起来不是那么的烦恼.
     */
    if (offset.y > _Header_H - _SectionTitleView_H ) {
        
        offset.y = _Header_H - _SectionTitleView_H;
        
    }
    
    if (isNeed == false) {//不需要同步所有的tableview
        
        for (int i = 0; i < _childCount; i++) {
            
            if (i != self.NOW_INDEX) {
                
                UIView *view = self.childViewAry[i];
                
                if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UIScrollView class]]) {
                    
                    [self setContentOffSetWithView:view offset:offset sychronizationEnable:YES];
                    
                }else if ([view isKindOfClass:[UIView class]]){//普通View
                    
                    for (UIView *childView in view.subviews) {
                        
                        if ([childView isKindOfClass:[UITableView class]] || [childView isKindOfClass:[UIScrollView class]]) {
                            
                            [self setContentOffSetWithView:childView offset:offset sychronizationEnable:YES];
                            
                        }
                    }
                }
            }
            
        }

    }else{//需要同步所有的tableview , 这里是用的sectionTitle的Y方向的偏移量做的判断(在didscroll中调用)
        
        for (int i = 0; i < _childCount; i++) {
            
            if (i != self.NOW_INDEX) {
                
                UIView *view = self.childViewAry[i];
                
                if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UIScrollView class]]) {
                    
                    [self setContentOffSetWithView:view offset:offset sychronizationEnable:NO];
                    
                }else if ([view isKindOfClass:[UIView class]]){//普通View
                    
                    for (UIView *childView in view.subviews) {
                        
                        if ([childView isKindOfClass:[UITableView class]] || [childView isKindOfClass:[UIScrollView class]]) {
                            
                            [self setContentOffSetWithView:childView offset:offset sychronizationEnable:NO];
                            
                        }
                    }
                }
                
            }
            
        }

    }
    
}

#pragma mark - 同步滚动偏移量
- (void)setContentOffSetWithView:(UIView *)view offset:(CGPoint)offset sychronizationEnable:(BOOL)sychronizationEnable{
    if ([view isKindOfClass:[UITableView class]]) {
        if (sychronizationEnable == NO) {
            UITableView *tableView = (UITableView *)view;
            [tableView setContentOffset:offset animated:NO];//全部同步
        }else{
            UITableView *tableView = (UITableView *)view;
            if (tableView.contentOffset.y < _Header_H - _SectionTitleView_H) {//如果它的滚动范围非常大,大出这个范围 , 不能让其被同步
                [tableView setContentOffset:offset animated:NO];
            }
        }
    }else if ([view isKindOfClass:[UIScrollView class]]){
        if (sychronizationEnable == NO) {
            UIScrollView *scrollView = (UIScrollView *)view;
            [scrollView setContentOffset:offset animated:NO];//全部同步
        }else{
            UIScrollView *scrollView = (UIScrollView *)view;
            if (scrollView.contentOffset.y < _Header_H - _SectionTitleView_H) {//同上
                [scrollView setContentOffset:offset animated:NO];
            }
        }
        
    }
}

#pragma mark - 标题Label的颜色变化逻辑
- (void)setTitleViewBackgroundColor
{
    _perLabel.backgroundColor = _labelGrayColor;
    _perLabel.textColor = [UIColor blackColor];
    UILabel *titlelbael = _titleAry[self.NOW_INDEX];
    titlelbael.backgroundColor = _labelBGColor;
    titlelbael.textColor = [UIColor whiteColor];
    _perLabel = titlelbael;
}


/**************************工具*****************************/

- (UILabel *)makeLabelWithTitle:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.text = title;
    titlelabel.textColor = [UIColor blackColor];
    titlelabel.font = [UIFont systemFontOfSize:14];
    [titlelabel sizeToFit];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    return titlelabel;
}

/************************** 懒加载 view  *****************************/

- (UIView *)loadingView{
    return HZ_LAZY(_loadingView, ({
        UIView *view = [[UIView alloc] init];
        CGRect frame = view.frame;
        frame.size.width = 100;
        frame.size.height = 100;
        frame.origin.x = SCREEN_WIDTH / 2 - 100 / 2;
        frame.origin.y = SCREEN_HEIGHT / 2 - 100 / 2;
        view.frame = frame;
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(30, 30, 40, 40);
        [view addSubview:activityView];
        [activityView startAnimating];
        
        view;
    }));
}

#pragma mark - 头部视图
- (UIView *)headerView
{
    return HZ_LAZY(_headerView, ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Nav_H, SCREEN_WIDTH, _Header_H)];
        view.backgroundColor = [UIColor whiteColor];
        view;
    }));
    
}

#pragma mark - 标题视图
- (UIView *)sectionTitleView
{
    return HZ_LAZY(_sectionTitleView, ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _Header_H - _SectionTitleView_H, SCREEN_WIDTH, _SectionTitleView_H)];
        view.backgroundColor = _labelGrayColor;
        view;
    }));
    
}

#pragma mark - 底部scrollerView
- (UIScrollView *)bottomScrollView
{
    return HZ_LAZY(_bottomScrollView, ({
       UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Nav_H, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView;
    }));
    
}

- (NSMutableArray *)titleAry{
    if (!_titleAry) {
        _titleAry = [NSMutableArray array];
    }
    
    return _titleAry;
}

- (NSMutableArray *)childViewAry{
    if (!_childViewAry) {
        _childViewAry = [NSMutableArray array];
    }
    
    return _childViewAry;
}
@end
