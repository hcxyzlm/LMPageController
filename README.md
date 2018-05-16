# LMPageController
基于TYPagerController封装的选项卡，方便集成使用

### 集成说明
    pod "LMPageController"

### 使用说明
分别实现LMPageTabBar，LMPageTabController的delegate即可
```objc
// 新建pagebar
 self.pageTabBar = [[LMPageTabBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, GLOBAL_NAVIGATIONBARITEM_HEIGHT) style:[LMPageTabBarStyle defaultStyle]];
    self.pageTabBar.delegate = self;
    self.pageTabBar.dateSource = self;
    [self.view addSubview:self.pageTabBar];
    
    
    // 新建pageController
    self.pageController = [[LMPageTabController alloc] initWitPageTabBar:self.pageTabBar];
    self.pageController.view.frame = CGRectMake(0, 108, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - GLOBAL_NAVIGATIONBARITEM_HEIGHT);
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
```
