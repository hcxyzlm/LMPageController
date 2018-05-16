//
//  LMTestPageChildController.m
//  LMPageController
//
//  Created by zhuo on 2018/5/16.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import "LMTestPageChildController.h"

@interface LMTestPageChildController ()

@end

@implementation LMTestPageChildController

- (instancetype)initWithVCTitle:(NSString *)title {
    
    if (self = [super init]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds)-100)/2, CGRectGetWidth(self.view.bounds), 100)];
        label.textColor = [UIColor whiteColor];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:32];
        
        [self.view addSubview:label];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
