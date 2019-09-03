//
//  SegmentSliderController.swift
//  LMPageContrllerExample
//
//  Created by zhuo on 2019/9/3.
//  Copyright © 2019 zhuo. All rights reserved.
//

import UIKit
import LMPageController
import SnapKit

public enum BouncesType {
    case parent
    case child
}

/// SegementSlideViewController
class SegementSlideViewController: UIViewController {
    
    // MARK: - Accessor
    
    internal var segementSlideScrollView: SegementSlideScrollView!
    internal var segementSlideHeaderView: UIView!
    internal var segmentTabBarView: LMPageTabBar!
    private var segmentPageController: LMPageTabController!
    
    internal var safeAreaTopConstraint: NSLayoutConstraint?
    internal var parentKeyValueObservation: NSKeyValueObservation?
    internal var childKeyValueObservation: NSKeyValueObservation?
    internal var innerBouncesType: BouncesType = .parent
    internal var canParentViewScroll: Bool = true
    internal var canChildViewScroll: Bool = false
    internal var lastChildBouncesTranslationY: CGFloat = 0
    internal var waitTobeResetContentOffsetY: Set<Int> = Set()
    
    public var slideScrollView: UIScrollView {
        return segementSlideScrollView
    }
    public var tabBarView: UIView {
        return segmentTabBarView
    }
    public var pageController: UIViewController {
        return segmentPageController
    }
    public var headerStickyHeight: CGFloat {
        let headerHeight = segementSlideHeaderView.frame.height.rounded(.up)
        if edgesForExtendedLayout.contains(.top) {
            return headerHeight - topLayoutLength
        } else {
            return headerHeight
        }
    }
    public var contentViewHeight: CGFloat {
        return view.bounds.height-topLayoutLength-tabbarHeight
    }
    public var currentIndex: Int? {
        return segmentTabBarView.currentSelectIndex
    }
    
    open var bouncesType: BouncesType {
        return .parent
    }
    
    open var tabbarHeight: CGFloat {
        return 48
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    open func tabbarTitles() -> [String] {
        #if DEBUG
        assert(false, "must override this variable")
        #endif
        return []
    }
    
    open func headerView() -> UIView? {
        if edgesForExtendedLayout.contains(.top) {
            #if DEBUG
            assert(false, "must override this variable")
            #endif
            return nil
        } else {
            return nil
        }
    }
    
    open func viewControllerForPageTabController(_ pageController: LMPageTabController!, controllerFor index: Int) -> UIViewController! {
        #if DEBUG
        assert(false, "must override this variable")
        #endif
        return UIViewController()
    }
}

// MARK: - Public Methods
extension SegementSlideViewController {
    
}

// MARK: - Private Methods
private extension SegementSlideViewController {
    func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = []
        /// setup
        segementSlideHeaderView = UIView()
        segementSlideScrollView = SegementSlideScrollView(frame: .zero)
        view.addSubview(segementSlideScrollView)
        segementSlideScrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        setupSlideHeaderView()
        setupSegmentTabBarView()
        setupSegmentTabBarController()
    }
    
    func setupSlideHeaderView() {
        segementSlideScrollView.addSubview(segementSlideHeaderView)
    }
    
    func setupSegmentTabBarView() {
        let style = LMPageTabBarStyle.default!
        style.itemSpace = 60
        style.titleFont = UIFont.systemFont(ofSize: 14)
        style.selectTitleFont = UIFont.boldSystemFont(ofSize: 14)
        style.indicatorViewWidth = 70
        let tabBarView = LMPageTabBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60), style: style)!
        self.segmentTabBarView = tabBarView
        segementSlideScrollView.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(tabbarHeight)
            maker.top.equalTo(segementSlideHeaderView.snp.bottom)
        }
        tabBarView.delegate = self
        tabBarView.dateSource = self
    }
    
    func setupSegmentTabBarController() {
        segmentPageController = LMPageTabController(witPageTabBar: self.segmentTabBarView)
        segmentPageController.delegate = self
        segmentPageController.dataSource = self
        addChild(pageController)
        segementSlideScrollView.addSubview(segmentPageController.view)
        segmentPageController.view.frame = CGRect()
    }
    
    func bindViewModel() {
        
    }
}

// MARK: - Event
extension SegementSlideViewController {
    
}

// MARK: - Delegate
extension SegementSlideViewController: LMPageTabBarDataSource, LMPageTabBarDelegate, LMPageTabControllerDelegate,  LMPageTabControllerDataSource {
    
    func numberOfControllers(forPageController pageController: LMPageTabController!) -> Int {
        return self.tabbarTitles().count
    }
    
    func pageController(_ pageController: LMPageTabController!, controllerFor index: Int) -> UIViewController! {
        return viewControllerForPageTabController(pageController, controllerFor: index)
    }
    
    func numberOfItem(for pageTabBar: LMPageTabBar!) -> Int {
        return self.tabbarTitles().count
    }
    
    func title(for pageTabBar: LMPageTabBar!, at index: Int) -> String! {
        let titleArray = self.tabbarTitles()
        guard index >= 0  && index < titleArray.count else {
            return ""
        }
        return titleArray[index]
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        
    }
    
    open func didSelectContentViewController(at index: Int) {
        
    }
}

extension SegementSlideViewController {
    
    internal var topLayoutLength: CGFloat {
        let topLayoutLength: CGFloat
        if #available(iOS 11, *) {
            topLayoutLength = view.safeAreaInsets.top
        } else {
            topLayoutLength = topLayoutGuide.length
        }
        return topLayoutLength
    }
    
    internal var bottomLayoutLength: CGFloat {
        let bottomLayoutLength: CGFloat
        if #available(iOS 11, *) {
            bottomLayoutLength = view.safeAreaInsets.bottom
        } else {
            bottomLayoutLength = bottomLayoutGuide.length
        }
        return bottomLayoutLength
    }
    
}


