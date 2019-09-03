//
//  ContentViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import MJRefresh

class ContentViewController: UITableViewController, SegementSlideContentScrollViewDelegate {
    
    @objc var scrollView: UIScrollView {
        return tableView
    }
    internal var refreshHandler: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 45
        let noneView = UIView()
        noneView.frame = .zero
        tableView.tableHeaderView = noneView
        tableView.tableFooterView = noneView
//        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
//        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
//        tableView.mj_header = refreshHeader
//        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
//        tableView.mj_footer.isHidden = true
//        tableView.mj_header.executeRefreshingCallback()
    }
    
    internal func refresh() {
        tableView.mj_header.beginRefreshing()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "faas")
        cell.textLabel?.text = "row \(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinit")
    }

}
