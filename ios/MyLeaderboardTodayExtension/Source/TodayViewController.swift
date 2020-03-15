//
//  TodayViewController.swift
//  MyLeaderboardTodayExtension
//
//  Created by Joseph Roque on 2019-09-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import NotificationCenter
import FunctionalTableData

typealias TodayCompletionHandler = (NCUpdateResult) -> Void

@objc(TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding {

	private let tableView = UITableView()
	private let tableData = FunctionalTableData()

	private var viewModel: TodayViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		Theme.applyToday()
		spreadsheetBuilder.interfaceSize = .compact

		viewModel = TodayViewModel { [weak self] action in
			switch action {
			case .noPreferredPlayer(let completionHandler),
				.noPreferredOpponents(let completionHandler),
				.dataChanged(let completionHandler):
				completionHandler?(.newData)
				self?.render()
			case .graphQLError(let error, let completionHandler):
				completionHandler(.failed)
				self?.render(error: error)
			case .presentRoute(let route):
				self?.open(route: route)
			}
		}

		render()
	}

	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		render()
	}

	func widgetPerformUpdate(completionHandler: @escaping TodayCompletionHandler) {
		viewModel.postViewAction(.performUpdate(completionHandler))
	}

	override func loadView() {
		view = tableView
	}

	private func setupView() {
		tableData.tableView = tableView
	}

	private func render(error: GraphAPIError? = nil) {
		guard let preferredPlayer = viewModel.preferredPlayer else {
			extensionContext?.widgetLargestAvailableDisplayMode = .compact
			let sections = TodayBuilder.noPreferredPlayerSection(actionable: self)
			tableData.renderAndDiff(sections, animated: true) { [weak self] in
				guard let self = self else { return }
				DispatchQueue.main.async {
					self.preferredContentSize = self.estimatedWidgetSize()
				}
			}
			return
		}

		guard viewModel.preferredOpponents.count > 0 else {
			extensionContext?.widgetLargestAvailableDisplayMode = .compact
			let sections = TodayBuilder.noPreferredOpponentsSection(actionable: self)
			tableData.renderAndDiff(sections, animated: true) { [weak self] in
				guard let self = self else { return }
				DispatchQueue.main.async {
					self.preferredContentSize = self.estimatedWidgetSize()
				}
			}
			return
		}

		let maxRows = extensionContext?.widgetActiveDisplayMode == .expanded ? Int.max : 2

		let sections = TodayBuilder.sections(
			player: preferredPlayer,
			standings: viewModel.standings,
			opponents: viewModel.visiblePlayers,
			builder: spreadsheetBuilder,
			maxRows: maxRows,
			error: error,
			actionable: self
		)

		extensionContext?.widgetLargestAvailableDisplayMode = viewModel.standings.count > 1 ? .expanded : .compact

		tableData.renderAndDiff(sections, animated: true) { [weak self] in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.preferredContentSize = self.estimatedWidgetSize()
			}
		}
	}

	private func estimatedWidgetSize() -> CGSize {
		if extensionContext?.widgetActiveDisplayMode == .expanded {
			return CGSize(width: 0, height: 48 * (1 + viewModel.standings.count))
		} else {
			return CGSize(width: 0, height: 96)
		}
	}

	private func open(route: Route) {
		guard let extensionContext = extensionContext else { return }
		extensionContext.open(route.url)
	}
}

extension TodayViewController: TodayActionable {
	func openStandings() {
		viewModel.postViewAction(.openStandings)
	}

	func openPlayerDetails(playerID: GraphID) {
		viewModel.postViewAction(.openPlayerDetails(playerID))
	}

	func openGameDetails(gameID: GraphID) {
		viewModel.postViewAction(.openGameDetails(gameID))
	}

	func openPreferredPlayerSelection() {
		viewModel.postViewAction(.openPreferredPlayerSelection)
	}

	func openPreferredOpponentsSelection() {
		viewModel.postViewAction(.openPreferredOpponentsSelection)
	}
}
