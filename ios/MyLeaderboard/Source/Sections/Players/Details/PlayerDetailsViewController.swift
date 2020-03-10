//
//  PlayerDetailsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class PlayerDetailsViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: PlayerDetailsViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder!

	init(api: LeaderboardAPI, playerID: GraphID) {
		self.api = api
		super.init()

		setup(withID: playerID)
	}

	init(api: LeaderboardAPI, player: Player) {
		self.api = api
		super.init()

		setup(withPlayer: player)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(withID id: GraphID? = nil, withPlayer player: Player? = nil) {
		refreshable = true
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)
		self.title = player?.displayName

		let handleAction = { [weak self] (action: PlayerDetailsAction) in
			switch action {
			case .playerLoaded(let player):
				self?.title = player.displayName
			case .dataChanged:
				self?.finishRefresh()
				self?.render()
			case .graphQLError(let error):
				self?.presentError(error)
			case .gameSelected(let game):
				self?.showGameDetails(for: game)
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .showPlays(let games, let players):
				self?.openPlays(games: games, players: players)
			}
		}

		if let player = player {
			viewModel = PlayerDetailsViewModel(api: api, player: player, handleAction: handleAction)
		} else if let id = id {
			viewModel = PlayerDetailsViewModel(api: api, id: id, handleAction: handleAction)
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
		spreadsheetBuilder.interfaceSize = traitCollection.horizontalSizeClass
		render()
	}

	private func render() {
		guard let player = viewModel.player else {
			tableData.renderAndDiff([])
			return
		}

		let sections = PlayerDetailsBuilder.sections(player: player, records: viewModel.records, recentPlays: viewModel.plays, builder: spreadsheetBuilder, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func showGameDetails(for game: GraphID) {
		show(GameDetailsViewController(api: api, gameID: Int(game.rawValue)!), sender: self)
	}

	private func showPlayerDetails(for player: GraphID) {
		show(PlayerDetailsViewController(api: api, playerID: player), sender: self)
	}

	private func openPlays(games: [GraphID], players: [GraphID]) {
//		show(PlaysListViewController(api: api, games: games, players: players), sender: self)
		#warning("TODO: PlaysListViewController")
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

	func showPlays(games: [GraphID], players: [GraphID]) {
		viewModel.postViewAction(.showPlays(games, players))
	}
}
