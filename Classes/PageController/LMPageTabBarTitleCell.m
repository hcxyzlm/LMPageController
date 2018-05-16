//
//  LMPageTabBarTitleCell.m
//  lazyaudio
//
//  Created by zhuo on 17/08/2017.
//
//


#import "LMPageTabBarTitleCell.h"


@interface UIColor(LMAddition)

+ (UIColor *)calculateColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;

@end

@implementation UIColor (LMAddition)

- (CGFloat)redValue {
    return CGColorGetComponents(self.CGColor)[0];
}


- (CGFloat)greenValue {
    return CGColorGetComponents(self.CGColor)[1];
}


- (CGFloat)blueValue {
    return CGColorGetComponents(self.CGColor)[2];
}

+ (UIColor *)calculateColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    CGFloat oldRed = fromColor.redValue;
    CGFloat oldGreen = fromColor.greenValue;
    CGFloat oldBlue = fromColor.blueValue;
    CGFloat newRed = toColor.redValue;
    CGFloat newGreen = toColor.greenValue;
    CGFloat newBlue = toColor.blueValue;
    newRed = oldRed + (newRed - oldRed) * progress;
    newGreen = oldGreen + (newGreen - oldGreen) * progress;
    newBlue = oldBlue + (newBlue - oldBlue) * progress;
    UIColor *newColor = [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:1.0];
    return newColor;
}

@end


@interface LMPageTabBarTitleCell ()
@end

@implementation LMPageTabBarTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        self.titleLabel.textAlignment =NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)setupDataWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    self.titleLabel.text = title;
    self.titleLabel.font = font;
    self.titleLabel.textColor = color;
}



- (void)setupTitleFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    UIColor *newColor = [UIColor calculateColorWithFromColor:fromColor toColor:toColor progress:progress];
    self.titleLabel.textColor = newColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

#pragma mark private

@end

