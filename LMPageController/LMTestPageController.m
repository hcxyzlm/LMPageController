//
//  ViewController.m
//  LMPageController
//
//  Created by zhuo on 2018/5/16.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import "LMTestPageController.h"
#import "LMPageTabBar.h"
#import "LMPageTabController.h"
#import "LMPageTabBarTitleCell.h"

#import "LMTestPageChildController.h"

@interface LMTestPageController () <LMPageTabControllerDelegate,
LMPageTabControllerDataSource,
LMPageTabBarDelegate,
LMPageTabBarDataSource>

@property (nonatomic, strong) LMPageTabBar *pageTabBar;

@property (nonatomic, strong) LMPageTabController *pageController;

@property (nonatomic, copy) NSArray *titles;

@end

@implementation LMTestPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LMPageTabBarStyle *style =  [LMPageTabBarStyle defaultStyle];
    style.itemSpace = 30;
    style.scrollIndicatorTransition = YES;
    self.pageTabBar = [[LMPageTabBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44) style:style];
    self.pageTabBar.delegate = self;
    self.pageTabBar.dateSource = self;
    [self.view addSubview:self.pageTabBar];
    
    CGSize size =  [UIScreen mainScreen].bounds.size;
    
    self.pageController = [[LMPageTabController alloc] initWitPageTabBar:self.pageTabBar];
    self.pageController.view.frame = CGRectMake(0, 64, size.width, size.height-44);
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    self.titles = @[@"关注",@"推荐视频",@"视频",@"热点",@"科技",@"问答",@"互联网", @"音乐"];
}


#pragma mark delegate

- (NSUInteger)numberOfItemForPageTabBar:(LMPageTabBar *)pageTabBar {
    
    return self.titles.count;
    
}
- (NSString *)titleForPageTabBar:(LMPageTabBar *)pageTabBar atIndex:(NSUInteger)index {
    
    return [self.titles objectAtIndex:index];
}

- (void)pageTabBar:(LMPageTabBar *)pageTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pageController scrollToControllerAtIndex:index animate:YES];
}

- (NSInteger)numberOfControllersForPageController:(LMPageTabController *)pageController {
    return self.titles.count;
}

- (UIViewController *)pageController:(LMPageTabController *)pageController controllerForIndex:(NSInteger)index {
    LMTestPageChildController *vc = [[LMTestPageChildController alloc] initWithVCTitle:self.titles[index]];
    vc.view.backgroundColor = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:1];
    
    return vc;
}

@end
