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
        let vc = ContentViewController()
        return vc
    }
    
    override var headerView: UIView? {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.image = UIImage(named: "bg_working.png")
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 213)
        return headerView
    }
    
    override var tabbarTitles: [String] {
        let title = ["科技", "明星","体育", "电脑"]
        return title
    }
    
    override var bouncesType: BouncesType {
        return .child
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

