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
	private var api: LeaderboardAPI
	private var viewModel: GameDetailsViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder!

	init(api: LeaderboardAPI, gameID: ID) {
		self.api = api
		super.init()

		setup(withID: gameID)
	}

	init(api: LeaderboardAPI, game: Game) {
		self.api = api
		super.init()

		setup(withGame: game)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(withID id: ID? = nil, withGame game: Game? = nil) {
		refreshable = true
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)
		self.title = game?.name

		let handleAction = { [weak self] (action: GameDetailsAction) in
			switch action {
			case .gameLoaded(let game):
				self?.title = game.name
			case .dataChanged:
				self?.render()
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .apiError(let error):
				self?.presentError(error)
			case .openPlays(let players):
				self?.openPlays(players: players)
			}
		}

		if let game = game {
			viewModel = GameDetailsViewModel(api: api, game: game, handleAction: handleAction)
		} else if let id = id {
			viewModel = GameDetailsViewModel(api: api, id: id, handleAction: handleAction)
		} else {
			fatalError("ID or Game must be provided")
		}
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
		guard let game = viewModel.game else {
			tableData.renderAndDiff([])
			return
		}

		let sections = GameDetailsBuilder.sections(game: game, plays: viewModel.plays, players: viewModel.players, standings: viewModel.standings, builder: spreadsheetBuilder, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func showPlayerDetails(for player: Player) {
		show(PlayerDetailsViewController(api: api, player: player), sender: self)
	}

	private func openPlays(players: [Player]) {
		let games: [Game]
		if let game = viewModel.game {
			games = [game]
		} else {
			games = []
		}
		show(PlaysListViewController(api: api, games: games, players: players), sender: self)
	}

	private func presentError(_ error: LeaderboardAPIError) {
		let message: String
		if let errorDescription = error.errorDescription {
			message = errorDescription
		} else {
			message = "Unknown error."
		}

		Loaf(message, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension GameDetailsViewController: GameDetailsActionable {
	func selectedPlayer(player: Player) {
		viewModel.postViewAction(.selectPlayer(player))
	}

	func showPlays(players: [Player]) {
		viewModel.postViewAction(.showPlays(players))
	}
}
