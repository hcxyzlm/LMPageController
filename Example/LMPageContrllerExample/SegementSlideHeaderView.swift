//
//  SegementSlideHeaderView.swift
//  LMPageContrllerExample
//
//  Created by zhuo on 2019/9/3.
//  Copyright © 2019 zhuo. All rights reserved.
//

import UIKit

internal class SegementSlideHeaderView: UIView {
    
    private weak var lastHeaderView: UIView?
    private weak var scrollView: UIScrollView?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    internal func config(_ headerView: UIView?) {
        guard headerView != lastHeaderView else { return }
        if let lastHeaderView = lastHeaderView {
            lastHeaderView.removeFromSuperview()
        }
        guard let headerView = headerView else { return }
        addSubview(headerView)
//        headerView.snp.makeConstraints { (maker) in
//            maker.top.equalToSuperview()
//            maker.left.right.equalToSuperview()
//            maker.bottom.equalToSuperview()
//        }
        lastHeaderView = headerView
    }
    
    override func layoutSubviews() {
        guard let headerView = lastHeaderView else {
            return
        }
        var frame = self.frame
        frame.size.width = headerView.frame.size.width
        frame.size.height = headerView.frame.size.height
        self.frame = frame
    }
    
}
