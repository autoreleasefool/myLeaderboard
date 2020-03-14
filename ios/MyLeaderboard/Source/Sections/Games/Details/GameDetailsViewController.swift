//
//  GameDetailsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class GameDetailsViewController: FTDViewController {
	private var viewModel: GameDetailsViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder!

	init(gameID: GraphID) {
		super.init()
		setup(withID: gameID)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(withID gameID: GraphID) {
		refreshable = true
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)

		let handleAction = { [weak self] (action: GameDetailsAction) in
			switch action {
			case .gameLoaded(let game):
				self?.title = game.name
			case .dataChanged:
				self?.finishRefresh()
				self?.render()
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .graphQLError(let error):
				self?.finishRefresh()
				self?.presentError(error)
			case .openPlayerPlays(let players):
				self?.openPlayerPlays(playerIDs: players)
			}
		}

		viewModel = GameDetailsViewModel(gameID: gameID, handleAction: handleAction)
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
			tableData.renderAndDiff([])
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
		show(PlayerDetailsViewController(playerID: playerID), sender: self)
	}

	private func openPlayerPlays(playerIDs: [GraphID]) {
//		let games: [Game]
//		if let game = viewModel.game {
//			games = [game]
//		} else {
//			games = []
//		}
//		show(PlaysListViewController(api: api, games: games, players: players), sender: self)
		#warning("TODO: show plays")
	}

	private func presentError(_ error: GraphAPIError) {
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
		viewModel.postViewAction(.showPlayerPlays(playerIDs))
	}
}
