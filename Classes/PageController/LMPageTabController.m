//
//  LMPageTabController.m
//  lazyaudio
//
//  Created by zhuo on 18/08/2017.
//
//

#import "LMPageTabController.h"
#import "TYPagerController.h"
#import "LMPageTabBar.h"


#if DEBUG
// 自定义调试宏
#define LMLog(format, ...)  {                                                                               \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
}
#else

#define LMLog(format, ...)
#endif


@interface LMPageTabController ()<TYPagerControllerDelegate, TYPagerControllerDataSource>
@property (nonatomic, strong) TYPagerController *pageController;
@property (nonatomic, weak) LMPageTabBar *pageTabBar;
@end

@implementation LMPageTabController
@dynamic scrollEnable;

- (instancetype)initWitPageTabBar:(LMPageTabBar *)tabBar {
    if (self = [self initWithFrame:CGRectZero PageTabBar:tabBar]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame PageTabBar:(LMPageTabBar *)tabBar {
    if (self = [super init]) {
        _pageTabBar = tabBar;
        _loadAfterScrollEnd = NO;
        self.view.frame = frame;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPageController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIViewController *vc in self.pageController.visibleControllers) {
        [vc beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIViewController *vc in self.pageController.visibleControllers) {
        [vc endAppearanceTransition];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIViewController *vc in self.pageController.visibleControllers) {
        [vc beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (UIViewController *vc in self.pageController.visibleControllers) {
        [vc endAppearanceTransition];
    }
}

- (void)viewWillLayoutSubviews {
    self.pageController.view.frame = self.view.bounds;
}

#pragma mark - Getter and Setter

- (void)setLoadAfterScrollEnd:(BOOL)loadAfterScrollEnd {
    _loadAfterScrollEnd = loadAfterScrollEnd;
    self.pageController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = loadAfterScrollEnd;
}

- (BOOL)scrollEnable {
    return self.pageController.scrollView.scrollEnabled;
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    self.pageController.scrollView.scrollEnabled = scrollEnable;
}

- (NSUInteger)currentIndex {
    return self.pageController.curIndex;
}

- (NSArray *)visibleControllers {
    return self.pageController.visibleControllers;
}

- (UIViewController *)currentViewController {
    return [self.pageController controllerForIndex:self.pageController.curIndex];
}

#pragma mark - Delegate

#pragma mark TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController viewWillAppear:(UIViewController *)viewController forIndex:(NSInteger)index {
    LMLog(@"%@-%@", NSStringFromSelector(_cmd), viewController);
    if ([self.delegate respondsToSelector:@selector(pageController:viewWillAppear:forIndex:)]) {
        [self.delegate pageController:self viewWillAppear:viewController forIndex:index];
    }
}

- (void)pagerController:(TYPagerController *)pagerController viewDidAppear:(UIViewController *)viewController forIndex:(NSInteger)index {
    LMLog(@"%@-%@", NSStringFromSelector(_cmd), viewController);
    if ([self.delegate respondsToSelector:@selector(pageController:viewDidAppear:forIndex:)]) {
        [self.delegate pageController:self viewDidAppear:viewController forIndex:index];
    }
}

- (void)pagerController:(TYPagerController *)pagerController viewWillDisappear:(UIViewController *)viewController forIndex:(NSInteger)index {
    LMLog(@"%@-%@", NSStringFromSelector(_cmd), viewController);
    if ([self.delegate respondsToSelector:@selector(pageController:viewWillDisappear:forIndex:)]) {
        [self.delegate pageController:self viewWillDisappear:viewController forIndex:index];
    }
}

- (void)pagerController:(TYPagerController *)pagerController viewDidDisappear:(UIViewController *)viewController forIndex:(NSInteger)index {
    LMLog(@"%@-%@", NSStringFromSelector(_cmd), viewController);
    if ([self.delegate respondsToSelector:@selector(pageController:viewDidDisappear:forIndex:)]) {
        [self.delegate pageController:self viewDidDisappear:viewController forIndex:index];
    }
}


- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if (self.pageTabBar.currentSelectIndex != fromIndex) {
        [self.pageTabBar scrollToIndex:toIndex animation:NO];
    }
    [self.pageTabBar scrollToIndex:toIndex progress:progress];
    if ([self.delegate respondsToSelector:@selector(pageController:transitionToIndex:progress:)]) {
        [self.delegate pageController:self transitionToIndex:toIndex progress:progress];
    }
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.pageTabBar scrollToIndex:toIndex animation:NO];
    if ([self.delegate respondsToSelector:@selector(pageController:transitionToIndex:animated:)]) {
        [self.delegate pageController:self transitionToIndex:toIndex animated:NO];
    }
}

#pragma mark TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    if ([self.dataSource respondsToSelector:@selector(numberOfControllersForPageController:)]) {
        return [self.dataSource numberOfControllersForPageController:self];
    }
    return 0;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if ([self.dataSource respondsToSelector:@selector(pageController:controllerForIndex:)]) {
        return [self.dataSource pageController:self controllerForIndex:index];
    }
    return nil;
}

#pragma mark - Public Method

- (void)scrollToControllerAtIndex:(NSInteger)index animate:(BOOL)animate {
    if (self.pageController.visibleControllers.count == 0) {
        [self.pageController reloadData];
    }
    [self.pageController scrollToControllerAtIndex:index animate:animate];
}

- (void)reloadData {
    [self.pageController updateData];
}

- (void)reloadDataWithCleanVisible {
    [self.pageController reloadData];
}

#pragma mark - Private Method
- (void)setupPageController {
    TYPagerController *pageController = [[TYPagerController alloc]init];
    pageController.layout.prefetchItemCount = 1;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pageController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = self.loadAfterScrollEnd;
    pageController.dataSource = self;
    pageController.delegate = self;
    [self addChildViewController:pageController];
    pageController.view.frame = self.view.bounds;
    [self.view addSubview:pageController.view];
    self.pageController = pageController;
}

@end
