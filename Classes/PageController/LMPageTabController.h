//
//  LMPageTabController.h
//  lazyaudio
//
//  Created by zhuo on 18/08/2017.
//
//

#import <UIKit/UIKit.h>
@class LMPageTabBar;
@class LMPageTabController;

@protocol LMPageTabControllerDelegate <NSObject>
@optional
- (void)pageController:(LMPageTabController *)pageController viewWillAppear:(UIViewController *)viewController forIndex:(NSInteger)index;
- (void)pageController:(LMPageTabController *)pageController viewDidAppear:(UIViewController *)viewController forIndex:(NSInteger)index;

- (void)pageController:(LMPageTabController *)pageController viewWillDisappear:(UIViewController *)viewController forIndex:(NSInteger)index;
- (void)pageController:(LMPageTabController *)pageController viewDidDisappear:(UIViewController *)viewController forIndex:(NSInteger)index;

// Transition animation customization
- (void)pageController:(LMPageTabController *)pageController transitionToIndex:(NSInteger)toIndex progress:(CGFloat)progress;
- (void)pageController:(LMPageTabController *)pageController transitionToIndex:(NSInteger)toIndex animated:(BOOL)animated;
@end

@protocol LMPageTabControllerDataSource <NSObject>
- (NSInteger)numberOfControllersForPageController:(LMPageTabController *)pageController;
- (UIViewController *)pageController:(LMPageTabController *)pageController controllerForIndex:(NSInteger)index;
@end

@class TYPagerController;

@interface LMPageTabController : UIViewController

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWitPageTabBar:(LMPageTabBar *)tabBar;

/// 是否等到滚动结束后再加载数据
@property (nonatomic, assign) BOOL loadAfterScrollEnd;
@property (nonatomic, strong, readonly) NSArray *visibleControllers;
@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, strong, readonly) TYPagerController *pageController;

@property (nonatomic, weak) id<LMPageTabControllerDelegate> delegate;
@property (nonatomic, weak) id<LMPageTabControllerDataSource> dataSource;

- (void)scrollToControllerAtIndex:(NSInteger)index animate:(BOOL)animate;
- (void)reloadData; ///< 刷新数据
- (void)reloadDataWithCleanVisible; ///< 刷新数据并清除

@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, assign, readonly) NSUInteger currentIndex;
@end
