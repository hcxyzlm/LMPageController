//
//  LMPageTabBar.m
//  lazyaudio
//
//  Created by zhuo on 16/08/2017.
//
//

#import "LMPageTabBar.h"
#import "LMPageTabBarTitleCell.h"

/// 滚动的方向
typedef NS_ENUM(NSUInteger, LMPageTabBarScrollDirection) {
    LMPageTabBarScrollDirectionToLeft,
    LMPageTabBarScrollDirectionToRight
};

static NSString *const kPageTabBarTitleCellReuseIdentifier = @"PageTabBarTitleCellReuseIdentifier";

@implementation LMPageTabBarStyle

- (instancetype)init {
    if (self = [super init]) {
        _pageViewWith  = UIScreen.mainScreen.bounds.size.width;
        _pageViewHeight = 40;
        _backgroundColor = [UIColor whiteColor];
        _itemSpace = 20.0;
        _contentInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
        _titleFont = [UIFont systemFontOfSize:17.0];
        _selectTitleFont = [UIFont boldSystemFontOfSize:17.0];
        _titleColor = [UIColor blackColor];
        _selectedTitleColor = [UIColor orangeColor];
        _indicatorViewWidth = 19;
        _indicatorViewHeight = 2;
        _indicatorViewColor = [UIColor orangeColor];
        _scrollIndicatorTransition = YES;
        _separateLineViewColor = UIColor.grayColor;
        _separateLineHeight = 1;
    }
    return self;
}

+ (LMPageTabBarStyle *)defaultStyle {
    LMPageTabBarStyle *style = [[LMPageTabBarStyle alloc] init];
    return style;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    CGFloat size = titleFont.pointSize;
    self.selectTitleFont = [UIFont boldSystemFontOfSize:size];
}

@end

@interface LMPageTabBar ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>
@property (nonatomic, strong) LMPageTabBarStyle *style;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *indicatorView; ///< 底部指示器View

@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation LMPageTabBar

- (instancetype)initWithFrame:(CGRect)frame style:(LMPageTabBarStyle *)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        _scrollEnable = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.bounds)- _style.separateLineHeight, CGRectGetWidth(self.bounds), _style.separateLineHeight);
    self.separateLine.frame = frame;
    
    self.collectionView.frame = self.bounds;

    [self moveIndicatorViewToIndex:self.currentSelectIndex animation:NO];
}

- (CGSize )intrinsicContentSize {
    if (self.preferWidth > 0) {
        return CGSizeMake(self.preferWidth, 44.0);
    }
    return UILayoutFittingExpandedSize;
}

#pragma mark - Getter and Setter

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    self.collectionView.scrollEnabled = scrollEnable;
}

#pragma mark - Public Method

- (void)scrollToIndex:(NSInteger)index animation:(BOOL)animation {
    
    if (self.currentSelectIndex == index) { return; }
    
    index = (index < 0) ? 0 : index;
    NSUInteger titlesCount = [self numberOfTitle];
    index = (index > titlesCount) ? (titlesCount - 1) : index;
    self.currentSelectIndex = index;
    [self transitionToIndex:index animation:animation];
}

- (void)reloadTitles {
    if (self.currentSelectIndex >= [self numberOfTitle]) {
        self.currentSelectIndex = [self numberOfTitle] - 1;
    }
    [self.collectionView reloadData];

    [self moveIndicatorViewToIndex:self.currentSelectIndex animation:NO];
}

- (void)scrollToIndex:(NSInteger)index progress:(CGFloat)progress {
    
    if (self.currentSelectIndex == index) {
        return;
    }
    
    if (progress > 1.0 || progress < 0) {
        return;
    }
    
    if (index >= [self numberOfTitle] || index < 0) {
        return;
    }
    
    [self updateIndicatorViewToIndex:index progress:progress];
    [self updateTitleColorToIndex:index progress:progress];
    
    if (progress >= 1.0) {
        [self scrollToIndex:index animation:YES];
    }
}

#pragma mark - Delegate


#pragma mark UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollToIndex:indexPath.item animation:YES];
    if ([self.delegate respondsToSelector:@selector(pageTabBar:didSelectItemAtIndex:)]) {
        [self.delegate pageTabBar:self didSelectItemAtIndex:indexPath.item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemH = CGRectGetHeight(self.frame);
    if ([self.delegate respondsToSelector:@selector(pageTabBar:itemWidthAtIndex:)]) {
        CGFloat itemW = [self.delegate pageTabBar:self itemWidthAtIndex:indexPath.item];
        return CGSizeMake(itemW, itemH);
    }
    else {
        NSString *title = [self titleForIndexPath:indexPath];
        CGSize size = CGSizeZero;
        if (indexPath.item == self.currentSelectIndex) {
            size = [title sizeWithFont:self.style.selectTitleFont constrainedToSize:CGSizeMake(MAXFLOAT, itemH)];
        }
        else {
            size = [title sizeWithFont:self.style.titleFont constrainedToSize:CGSizeMake(MAXFLOAT, itemH)];
        }
        return CGSizeMake(size.width + 1.0, itemH);
    }
}

#pragma mark UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfTitle];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dateSource respondsToSelector:@selector(cellForPageTabBar:atIndex:)]) {
        UICollectionViewCell<LMPageTabBarTitleCellProtocol> *cell = [self.dateSource cellForPageTabBar:self atIndex:indexPath.item];
        if (indexPath.item == self.currentSelectIndex) {
            [cell setupTitleFromColor:self.style.titleColor toColor:self.style.selectedTitleColor progress:1.0];
            
        }
        else {
            [cell setupTitleFromColor:self.style.selectedTitleColor toColor:self.style.titleColor progress:1.0];
        }
        return cell;
    }
    
    LMPageTabBarTitleCell *cell = (LMPageTabBarTitleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPageTabBarTitleCellReuseIdentifier forIndexPath:indexPath];
    [self configureWithTitleCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark - Private Method

- (void)configureWithTitleCell:(LMPageTabBarTitleCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *title = [self titleForIndexPath:indexPath];
    NSInteger count = [self numberOfTitle];
    if (self.currentSelectIndex > count) {
        self.currentSelectIndex = 0;
    }
    
    UIColor *titleColor = self.style.titleColor;
    UIFont *titleFont = self.style.titleFont;
    if (self.currentSelectIndex == indexPath.item) {
        titleColor = self.style.selectedTitleColor;
        titleFont = self.style.selectTitleFont;
    }
    [cell setupDataWithTitle:title font:titleFont color:titleColor];
}

- (void)setupSubviews {
    self.backgroundColor = self.style.backgroundColor;
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = self.style.itemSpace;
        layout.minimumInteritemSpacing = self.style.itemSpace;
        layout.sectionInset = self.style.contentInset;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = self.style.backgroundColor;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        if ([collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
            collectionView.prefetchingEnabled = NO;
        }
        [self addSubview:collectionView];
        [collectionView registerClass:LMPageTabBarTitleCell.class  forCellWithReuseIdentifier:kPageTabBarTitleCellReuseIdentifier];
        collectionView;
    });
    
    _indicatorView = ({
        CGFloat y = CGRectGetHeight(self.frame) - self.style.indicatorViewHeight;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.style.indicatorViewWidth, self.style.indicatorViewHeight)];
        view.backgroundColor = self.style.indicatorViewColor;
        [self.collectionView addSubview:view];
        view;
    });
    
    _separateLine = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        view.backgroundColor = _style.separateLineViewColor;
        [view.superview bringSubviewToFront:view];
        view;
    });
}

- (NSUInteger)numberOfTitle {
    NSUInteger count = 0;
    if ([self.dateSource respondsToSelector:@selector(numberOfItemForPageTabBar:)]) {
        count = [self.dateSource numberOfItemForPageTabBar:self];
    }
    return count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    if ([self.dateSource respondsToSelector:@selector(titleForPageTabBar:atIndex:)]) {
        title = [self.dateSource titleForPageTabBar:self atIndex:indexPath.item];
    }
    return title;
}

#pragma mark Scroll Progress

- (CGRect)calculateIndicatorViewWithFromCellMidX:(CGFloat)fromCellMidX
                                 toCellMidX:(CGFloat)toCellMidX
                                   progress:(CGFloat)progress {
    CGFloat percent = progress <= 0.5 ? (progress / 0.5) : ((progress - 0.5) / 0.5);
    CGFloat finalW = 0;
    CGFloat finalX = 0;
    CGFloat originX = fromCellMidX - self.style.indicatorViewWidth / 2.0;
    if (fromCellMidX > toCellMidX) {
        // 左移
        if (progress <= 0.5) {
            finalW = self.style.indicatorViewWidth + fabs(fromCellMidX - toCellMidX) * percent;
            finalX = originX - (finalW - self.style.indicatorViewWidth);
        }
        else {
            finalW = self.style.indicatorViewWidth + fabs(fromCellMidX - toCellMidX) * (1 - percent);
            finalX = originX - (fromCellMidX - toCellMidX);
        }
    }
    else {
        // 右移
        if (progress <= 0.5) {
            finalW = self.style.indicatorViewWidth + fabs(fromCellMidX - toCellMidX) * percent;
            finalX = originX;
        }
        else {
            finalW = self.style.indicatorViewWidth + fabs(fromCellMidX - toCellMidX) * (1.0 - percent);
            finalX = originX + percent * fabs(fromCellMidX - toCellMidX);
        }
    }
    CGRect frame = self.indicatorView.frame;
    frame.origin.x = finalX;
    frame.size.width = finalW;
    return frame;
}

- (void)updateIndicatorViewToIndex:(NSInteger)index progress:(CGFloat)progress {
    if (index >= [self numberOfTitle]) {
        return;
    }
    if (self.style.scrollIndicatorTransition) {
        CGRect fromCellFrame = [self cellPositionWithIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0]];
        CGRect toCellFrame = [self cellPositionWithIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        CGFloat fromCellMidX = CGRectGetMidX(fromCellFrame);
        CGFloat toCellMidX = CGRectGetMidX(toCellFrame);
        self.indicatorView.frame = [self calculateIndicatorViewWithFromCellMidX:fromCellMidX toCellMidX:toCellMidX progress:progress];
    }
}

- (void)updateTitleColorToIndex:(NSInteger)index progress:(CGFloat)progress {
    if (index >= [self numberOfTitle]) {
        return;
    }
    UICollectionViewCell<LMPageTabBarTitleCellProtocol> *fromCell = (UICollectionViewCell<LMPageTabBarTitleCellProtocol> *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0]];
    UICollectionViewCell<LMPageTabBarTitleCellProtocol> *toCell = (UICollectionViewCell<LMPageTabBarTitleCellProtocol> *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [fromCell setupTitleFromColor:self.style.selectedTitleColor toColor:self.style.titleColor progress:progress];
    [toCell setupTitleFromColor:self.style.titleColor toColor:self.style.selectedTitleColor progress:progress];
}

#pragma mark Move to Index

- (CGRect)cellPositionWithIndexPath:(NSIndexPath *)indexPath {
    CGRect ret = CGRectZero;
    UICollectionViewLayoutAttributes *attribute = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    if (attribute) {
        ret = attribute.frame;
    }
    return ret;
}

- (void)transitionToIndex:(NSUInteger)index animation:(BOOL)animation {
    if (index >= [self numberOfTitle]) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    if (self.scrollEnable) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animation];
    }
    [self.collectionView reloadData];
    [self moveIndicatorViewToIndex:index animation:animation];
}

- (void)moveIndicatorViewToIndex:(NSUInteger)index animation:(BOOL)animation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    CGRect cellFrame = [self cellPositionWithIndexPath:indexPath];
    CGRect originFrame = self.indicatorView.frame;
    originFrame.size.width = cellFrame.size.width;
    CGFloat moveToPositionX = CGRectGetMidX(cellFrame) - self.style.indicatorViewWidth / 2.0;
    CGFloat moveToPositionY = CGRectGetHeight(self.frame) - self.style.indicatorViewHeight;
    originFrame.origin = CGPointMake(moveToPositionX, moveToPositionY);
    originFrame.size.width = self.style.indicatorViewWidth;
    if (animation) {
        [UIView animateWithDuration:0.1 animations:^{
            self.indicatorView.frame = originFrame;
        }];
    }
    else {
        self.indicatorView.frame = originFrame;
    }
}

@end
