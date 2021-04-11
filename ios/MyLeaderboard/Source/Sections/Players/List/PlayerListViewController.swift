//
//  PlayerListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class PlayerListViewController: FTDViewController {
	private var viewModel: PlayerListViewModel!

	init(boardId: GraphID) {
		super.init()
		refreshable = true
		paginated = true

		viewModel = PlayerListViewModel(boardId: boardId) { [weak self] action in
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
			case .showPreferredPlayerSelection:
				self.openPreferredPlayerSelection()
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Players"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewPlayer)
		)

		viewModel.postViewAction(.initialize)
		render()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel.postViewAction(.didAppear)
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
		presentModal(CreatePlayerViewController(boardId: viewModel.boardId) { [weak self] player in
			guard let self = self else { return }
			Loaf("\(player.displayName) added!", state: .success, sender: self).show()
			self.viewModel.postViewAction(.reload)
		})
	}

	private func showPlayerDetails(for playerID: GraphID) {
		let playerName = viewModel.players.first { $0.id == playerID }?.displayName
		show(
			PlayerDetailsViewController(
				playerID: playerID,
				boardId: viewModel.boardId,
				withPlayerName: playerName
			),
			sender: self
		)
	}

	private func openPreferredPlayerSelection() {
		let alert = UIAlertController(
			title: "Select a preferred player?",
			message: "You haven't selected a preferred player yet. " +
				"Choosing a preferred player makes it easier to record " +
				"games by automatically adding them (yourself) to games you record! Pick a preferred player now?",
			preferredStyle: .alert
		)

		alert.addAction(UIAlertAction(title: "Pick", style: .default) { [weak self] _ in
			guard let self = self else { return }
			self.openPreferredPlayerModal()
		})
		alert.addAction(UIAlertAction(title: "Later", style: .cancel))

		present(alert, animated: true)
	}

	private func openPreferredPlayerModal() {
		var initiallySelected: Set<GraphID> = []
		if let player = Player.preferred {
			initiallySelected.insert(player.graphID)
		}

		presentModal(PlayerPickerViewController(
			boardId: viewModel.boardId,
			multiSelect: false,
			initiallySelected: initiallySelected
		) { [weak self] selected in
			self?.viewModel.postViewAction(.selectPreferredPlayer(selected.first))
		})
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

		show(PlayerDetailsViewController(playerID: playerID, boardId: viewModel.boardId), sender: self)
	}
}
