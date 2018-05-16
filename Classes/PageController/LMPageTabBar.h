//
//  LMPageTabBar.h
//  lazyaudio
//
//  Created by zhuo on 16/08/2017.
//
//  滑动页面结构的导航条

#import <UIKit/UIKit.h>
#import "LMPageTabBarTitleCellProtocol.h"
@class LMPageTabBar;

#define kPageTabBarHeight 40.0
#define kPageTabBarHeightInNavBar 40.0

/// pageTabBar的样式
@interface LMPageTabBarStyle : NSObject
@property (class, nonatomic, strong, readonly) LMPageTabBarStyle *defaultStyle;

@property (nonatomic, strong) UIColor *backgroundColor; ///< 背景颜色，默认白色
@property (nonatomic, assign) CGFloat itemSpace; ///< 按钮间的间距，默认20.0pt
@property (nonatomic, assign) UIEdgeInsets contentInset; ///< 按钮区域（CollectionView）的缩进，默认UIEdgeInsetsMake(0, 15.0, 0, 15.0)
@property (nonatomic, strong) UIFont *titleFont; ///< 标题字体，默认17.0pt
@property (nonatomic, strong) UIFont *selectTitleFont; ///< 选中时的标题字体，默认为titleFont的加粗字体
@property (nonatomic, strong) UIColor *titleColor; ///< 标题颜色，默认#333332
@property (nonatomic, strong) UIColor *selectedTitleColor; ///< 选中的标题颜色，默认#f39f19
@property (nonatomic, assign) CGFloat indicatorViewWidth; ///< 指示器的默认宽度，默认18pt
@property (nonatomic, strong) UIColor *indicatorViewColor; ///< 指示器的颜色，默认#f39f19
@property (nonatomic, assign) BOOL showRightFadeTransition; ///< 是否显示右侧渐隐过渡效果，默认可以滚动时为YES，不可滚动时为NO

@end


@protocol LMPageTabBarDataSource <NSObject>
- (NSUInteger)numberOfItemForPageTabBar:(LMPageTabBar *)pageTabBar;
@optional
/// 返回标题字符串，支持NSAttributeString
- (NSString *)titleForPageTabBar:(LMPageTabBar *)pageTabBar atIndex:(NSUInteger)index;
- (UICollectionViewCell<LMPageTabBarTitleCellProtocol> *)cellForPageTabBar:(LMPageTabBar *)pageTabBar atIndex:(NSUInteger)index;
@end

@protocol LMPageTabBarDelegate <NSObject>
@optional
- (void)pageTabBar:(LMPageTabBar *)pageTabBar didSelectItemAtIndex:(NSInteger)index;
- (CGFloat)pageTabBar:(LMPageTabBar *)pageTabBar itemWidthAtIndex:(NSInteger)index;
@end

@interface LMPageTabBar : UIView

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame style:(LMPageTabBarStyle *)style;

@property (nonatomic, assign) CGFloat preferWidth;
@property (nonatomic, weak) id<LMPageTabBarDelegate> delegate;
@property (nonatomic, weak) id<LMPageTabBarDataSource> dateSource;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *separateLine;

///< 是否能够滚动，如果不能滚动则会自动按照内容的大小设置CollectionView的大小，默认为YES
@property (nonatomic, assign) BOOL scrollEnable; 

/// 当前选中的index
@property (nonatomic, assign, readonly) NSInteger currentSelectIndex;

/// 滑动到序号为index的位置
- (void)scrollToIndex:(NSInteger)index animation:(BOOL)animation;

/// 重新刷新数据
- (void)reloadTitles;

/// 滑动到序号为index的位置，progress为进度
- (void)scrollToIndex:(NSInteger)index progress:(CGFloat)progress;

@end
