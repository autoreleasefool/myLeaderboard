//
//  PlayerDetailsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class PlayerDetailsViewController: FTDViewController {
	private var viewModel: PlayerDetailsViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder!

	init(playerID: GraphID, boardId: GraphID, withPlayerName playerName: String? = nil) {
		super.init()
		setup(withID: playerID, boardId: boardId)
		self.title = playerName
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(withID playerID: GraphID, boardId: GraphID) {
		refreshable = true
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)

		let handleAction = { [weak self] (action: PlayerDetailsAction) in
			switch action {
			case .dataChanged:
				self?.title = self?.viewModel.player?.displayName ?? self?.title
				self?.finishRefresh()
				self?.render()
			case .graphQLError(let error):
				self?.finishRefresh()
				self?.presentError(error)
			case .gameSelected(let game):
				self?.showGameDetails(for: game)
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .showPlays(let filter):
				self?.openPlays(filter: filter)
			}
		}

		viewModel = PlayerDetailsViewModel(playerID: playerID, boardId: boardId, handleAction: handleAction)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.postViewAction(.initialize)
		render()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		spreadsheetBuilder.interfaceSize = traitCollection.horizontalSizeClass
		render()
	}

	private func render() {
		guard let player = viewModel.player else {
			let sections = viewModel.dataLoading ? [LoadingCell.section()] : []
			tableData.renderAndDiff(sections)
			return
		}

		let sections = PlayerDetailsBuilder.sections(
			player: player,
			players: viewModel.players,
			records: viewModel.records,
			recentPlays: viewModel.plays,
			builder: spreadsheetBuilder,
			actionable: self
		)
		tableData.renderAndDiff(sections)
	}

	private func showGameDetails(for gameID: GraphID) {
		let gameName = viewModel.records.first(where: { $0.game.id == gameID })?.game.name
		show(
			GameDetailsViewController(
				gameID: gameID,
				boardId: viewModel.boardId,
				withGameName: gameName
			),
			sender: self
		)
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

	private func openPlays(filter: PlayListFilter) {
		show(PlaysListViewController(boardId: viewModel.boardId, filter: filter), sender: self)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension PlayerDetailsViewController: PlayerDetailsActionable {
	func selectedGame(gameID: GraphID) {
		viewModel.postViewAction(.selectGame(gameID))
	}

	func selectedPlayer(playerID: GraphID) {
		viewModel.postViewAction(.selectPlayer(playerID))
	}

	func showPlays(gameID: GraphID?, playerIDs: [GraphID]) {
		let filter = PlayListFilter(gameID: gameID, playerIDs: playerIDs)
		viewModel.postViewAction(.showPlays(filter))
	}
}
