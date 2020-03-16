//
//  FTDViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class FTDViewController: UIViewController {
	let tableView: UITableView = UITableView()
	let tableData: FunctionalTableData = FunctionalTableData()
	private let refreshControl = UIRefreshControl()

	var refreshable: Bool = false {
		didSet {
			if refreshable {
				tableView.refreshControl = refreshControl
			} else {
				tableView.refreshControl = nil
			}
		}
	}

	var paginated: Bool = false

	init() {
		super.init(nibName: nil, bundle: nil)
		refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
		tableView.cellLayoutMarginsFollowReadableWidth = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupTableData()

		view.backgroundColor = .primaryDark
	}

	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .primaryDark
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			])
	}

	private func setupTableData() {
		tableData.tableView = tableView
		tableData.scrollViewDidScroll = { [weak self] scrollView in
			let height = scrollView.frame.size.height
			let contentYoffset = scrollView.contentOffset.y
			let distanceFromBottom = scrollView.contentSize.height - contentYoffset
			if distanceFromBottom < height {
				self?.loadMore()
			}
		}
	}

	@objc private func didPullToRefresh(_ sender: Any) {
		refresh()
	}

	func refresh() {
		guard refreshable else { return }
		fatalError("You must override refresh() if the controller is refreshable")
	}

	func loadMore() {
		guard paginated else { return }
		fatalError("You must override loadMore() if the controller is paginated")
	}

	func finishRefresh() {
		refreshControl.endRefreshing()
	}
}
