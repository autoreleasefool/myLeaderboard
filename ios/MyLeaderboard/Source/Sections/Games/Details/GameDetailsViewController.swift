//
//  GameDetailsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class GameDetailsViewController: FTDViewController {
	private var viewModel: GameDetailsViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder!

	init(gameID: GraphID, boardId: GraphID, withGameName gameName: String? = nil) {
		super.init()
		setup(withID: gameID, boardId: boardId)
		self.title = gameName
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(withID gameID: GraphID, boardId: GraphID) {
		refreshable = true
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)

		let handleAction = { [weak self] (action: GameDetailsAction) in
			switch action {
			case .dataChanged:
				self?.title = self?.viewModel.game?.name ?? self?.title
				self?.finishRefresh()
				self?.render()
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .graphQLError(let error):
				self?.finishRefresh()
				self?.presentError(error)
			case .openPlays(let filter):
				self?.openPlayerPlays(filter: filter)
			}
		}

		viewModel = GameDetailsViewModel(gameID: gameID, boardId: boardId, handleAction: handleAction)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.postViewAction(.initialize)
		render()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		guard let spreadsheetBuilder = spreadsheetBuilder else { return }
		spreadsheetBuilder.interfaceSize = traitCollection.horizontalSizeClass
		render()
	}

	private func render() {
		guard let game = viewModel.game, let standings = viewModel.standings else {
			let sections = viewModel.dataLoading ? [LoadingCell.section()] : []
			tableData.renderAndDiff(sections)
			return
		}

		let sections = GameDetailsBuilder.sections(
			game: game,
			players: viewModel.players,
			standings: standings,
			recentPlays: viewModel.plays,
			builder: spreadsheetBuilder,
			actionable: self
		)

		tableData.renderAndDiff(sections)
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

	private func openPlayerPlays(filter: PlayListFilter) {
		show(PlaysListViewController(boardId: viewModel.boardId, filter: filter), sender: self)
	}

	private func presentError(_ error: MyLeaderboardAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension GameDetailsViewController: GameDetailsActionable {
	func selectedPlayer(playerID: GraphID) {
		viewModel.postViewAction(.selectPlayer(playerID))
	}

	func showPlayerPlays(playerIDs: [GraphID]) {
		let filter = PlayListFilter(gameID: viewModel.gameID, playerIDs: playerIDs)
		viewModel.postViewAction(.showPlays(filter))
	}
}
