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

@objc public protocol SegementSlideContentScrollViewDelegate where Self: UIViewController {
    /// must implement this variable, when use class `SegementSlideViewController` or it's subClass.
    /// you can ignore this variable, when you use `SegementSlideContentView` alone.
    @objc optional var scrollView: UIScrollView { get }
}


/// SegementSlideViewController
class SegementSlideViewController: UIViewController {
    
    // MARK: - Accessor
    
    internal var segementSlideScrollView: SegementSlideScrollView!
    internal var segementSlideHeaderView: SegementSlideHeaderView!
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
    
    open var tabbarTitles: [String] {
        #if DEBUG
        assert(false, "must override this variable")
        #endif
        return []
    }
    
    open var headerView: UIView? {
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
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSegementSlideScrollView()
    }
}

// MARK: - Public Methods
extension SegementSlideViewController {
    
    func layoutSegementSlideScrollView() {
        let topLayoutLength: CGFloat
        if edgesForExtendedLayout.contains(.top) {
            topLayoutLength = 0
        } else {
            topLayoutLength = self.topLayoutLength
        }
        
        segementSlideScrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        segementSlideHeaderView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.equalToSuperview()
            maker.top.equalTo(topLayoutLength)
        }
        segmentTabBarView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(tabbarHeight)
            maker.top.equalTo(213)
        }
        pageController.view.snp.makeConstraints { ( maker) in
            maker.left.equalToSuperview()
            maker.width.equalToSuperview()
            maker.top.equalTo(segmentTabBarView.snp.bottom)
            maker.height.equalTo(view.bounds.height - 213 - tabbarHeight)
        }
        
        segementSlideHeaderView.layer.zPosition = -3
        pageController.view.layer.zPosition = -2
        segmentTabBarView.layer.zPosition = -1
        
        segementSlideHeaderView.config(headerView)
        segementSlideHeaderView.layoutIfNeeded()
        
        let innerHeaderHeight = segementSlideHeaderView.frame.height
        let contentSize = CGSize(
            width: view.bounds.width,
            height: topLayoutLength + innerHeaderHeight + tabbarHeight + contentViewHeight + 1
        )
        if segementSlideScrollView.contentSize != contentSize {
            segementSlideScrollView.contentSize = contentSize
        }
    }
}

// MARK: - Private Methods
private extension SegementSlideViewController {
    func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = []
        /// setup
        segementSlideHeaderView = SegementSlideHeaderView()
        segementSlideScrollView = SegementSlideScrollView(frame: .zero)
        view.addSubview(segementSlideScrollView)
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
        let tabBarView = LMPageTabBar(frame:.zero, style: style)!
        self.segmentTabBarView = tabBarView
        segementSlideScrollView.addSubview(tabBarView)
        tabBarView.delegate = self
        tabBarView.dateSource = self
    }
    
    func setupSegmentTabBarController() {
        segmentPageController = LMPageTabController(witPageTabBar: self.segmentTabBarView)
        segmentPageController.delegate = self
        segmentPageController.dataSource = self
        addChild(pageController)
        segementSlideScrollView.addSubview(segmentPageController.view)
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
        return tabbarTitles.count
    }
    
    func pageController(_ pageController: LMPageTabController!, controllerFor index: Int) -> UIViewController! {
        return viewControllerForPageTabController(pageController, controllerFor: index)
    }
    
    func numberOfItem(for pageTabBar: LMPageTabBar!) -> Int {
        return tabbarTitles.count
    }
    
    func title(for pageTabBar: LMPageTabBar!, at index: Int) -> String! {
        let titleArray = tabbarTitles
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


