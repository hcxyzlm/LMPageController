//
//  ViewController.swift
//  LMPageContrllerExample
//
//  Created by zhuo on 2019/9/3.
//  Copyright © 2019 zhuo. All rights reserved.
//

import UIKit
import LMPageController

class ViewController: SegementSlideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewControllerForPageTabController(_ pageController: LMPageTabController!, controllerFor index: Int) -> UIViewController! {
        if index % 2 == 0 {
            return YellowController()
        } else {
            return GreenController()
        }
    }
    
    override func tabbarTitles() -> [String] {
        let title = ["科技", "明星","体育", "电脑"]
        return title
    }
}

class YellowController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
    }
}

class GreenController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
    }
}

