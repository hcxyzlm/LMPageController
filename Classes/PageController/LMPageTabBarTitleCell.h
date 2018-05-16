//
//  LMPageTabBarTitleCell.h
//  lazyaudio
//
//  Created by zhuo on 17/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "LMPageTabBarTitleCellProtocol.h"
@class LMPageTabBarStyle;

@interface LMPageTabBarTitleCell : UICollectionViewCell<LMPageTabBarTitleCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)setupDataWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

@end
