//
//  LMPageTabBarTitleCellProtocol.h
//  lazyaudio
//
//  Created by zhuo on 23/08/2017.
//
//

#import <Foundation/Foundation.h>

@protocol LMPageTabBarTitleCellProtocol <NSObject>
/// 根据进度设置标题的颜色
- (void)setupTitleFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;

@end
