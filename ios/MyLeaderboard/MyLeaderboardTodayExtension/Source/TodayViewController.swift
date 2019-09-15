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

	private let api: LeaderboardAPI
	private var viewModel: TodayViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)
		self.api = LeaderboardAPI()
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		Theme.apply()
		spreadsheetBuilder.interfaceSize = .compact

		viewModel = TodayViewModel(api: api) { [weak self] action in
			switch action {
			case .noPreferredPlayer(let completionHandler), .dataChanged(let completionHandler):
				completionHandler?(.newData)
				self?.render()
			case .apiError(let error, let completionHandler):
				completionHandler(.failed)
				self?.render(error: error)
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
		view.backgroundColor = .primaryDark
		tableView.backgroundColor = .primaryDark
		tableData.tableView = tableView
	}

	private func render(error: LeaderboardAPIError? = nil) {
		guard let preferredPlayer = viewModel.preferredPlayer else { return }
		let maxRows = extensionContext?.widgetActiveDisplayMode == .expanded ? Int.max : 2

		let sections = TodayBuilder.sections(player: preferredPlayer, standings: viewModel.gameStandings, players: viewModel.visiblePlayers, firstPlayer: viewModel.firstPlayerIndex, builder: spreadsheetBuilder, maxRows: maxRows, error: error, actionable: self)

		extensionContext?.widgetLargestAvailableDisplayMode = viewModel.gameStandings.count > 1 ? .expanded : .compact

		tableData.renderAndDiff(sections, animated: true, completion: { [weak self] in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.preferredContentSize = self.estimatedWidgetSize()
			}
		})
	}

	private func estimatedWidgetSize() -> CGSize {
		if extensionContext?.widgetActiveDisplayMode == .expanded {
			return CGSize(width: 0, height: 48 * (1 + viewModel.gameStandings.count))
		} else {
			return CGSize(width: 0, height: 96)
		}
	}
}

extension TodayViewController: TodayActionable {
	func openStandings() {
//		guard let extensionContext = extensionContext else { return }
	}

	func openPlayerDetails(player: Player) {
//		guard let extensionContext = extensionContext else { return }
	}

	func openGameDetails(game: Game) {
//		guard let extensionContext = extensionContext else { return }
	}

	func nextPlayer() {
		viewModel.postViewAction(.nextPlayer)
	}
}
