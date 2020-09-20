//
//  PlayerListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import MyLeaderboardApi
import UIKit
import Loaf

class PlayerListViewController: FTDViewController {
	private var viewModel: PlayerListViewModel!

	override init() {
		super.init()
		refreshable = true
		paginated = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = PlayerListViewModel { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .dataChanged:
				self.finishRefresh()
				self.render()
			case .playerSelected(let player):
				self.showPlayerDetails(for: player)
			case .graphQLError(let error):
				self.finishRefresh()
				self.presentError(error)
			case .addPlayer:
				self.showCreatePlayer()
			}
		}

		self.title = "Players"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewPlayer)
		)

		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		guard viewModel.players.count > 0 || !viewModel.dataLoading else {
			return tableData.renderAndDiff([LoadingCell.section()])
		}

		var sections = PlayerListBuilder.sections(players: viewModel.players, actionable: self)
		if viewModel.loadingMore {
			sections.append(LoadingCell.section(style: .medium, backgroundColor: .primary))
		}

		tableData.renderAndDiff(sections)
	}

	@objc private func addNewPlayer() {
		viewModel.postViewAction(.addPlayer)
	}

	private func showCreatePlayer() {
		presentModal(CreatePlayerViewController { [weak self] player in
			guard let self = self else { return }
			Loaf("\(player.displayName) added!", state: .success, sender: self).show()
			self.viewModel.postViewAction(.reload)
		})
	}

	private func showPlayerDetails(for playerID: GraphID) {
		let playerName = viewModel.players.first { $0.id == playerID }?.displayName
		show(PlayerDetailsViewController(playerID: playerID, withPlayerName: playerName), sender: self)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}

	override func loadMore() {
		viewModel.postViewAction(.loadMore)
	}
}

extension PlayerListViewController: PlayerListActionable {
	func selectedPlayer(playerID: GraphID) {
		viewModel.postViewAction(.selectPlayer(playerID))
	}
}

extension PlayerListViewController: RouteHandler {
	func openRoute(_ route: Route) {
		guard case .playerDetails(let playerID) = route else {
			return
		}

		show(PlayerDetailsViewController(playerID: playerID), sender: self)
	}
}
