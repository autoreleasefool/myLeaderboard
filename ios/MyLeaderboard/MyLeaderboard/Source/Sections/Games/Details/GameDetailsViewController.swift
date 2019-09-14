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

	init(api: LeaderboardAPI, game: Game) {
		self.api = api
		super.init()

		refreshable = true
		viewModel = GameDetailsViewModel(api: api, game: game) { [weak self] action in
			switch action {
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

		self.title = game.name
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
		let sections = GameDetailsBuilder.sections(game: viewModel.game, plays: viewModel.plays, players: viewModel.players, standings: viewModel.standings, builder: spreadsheetBuilder, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func showPlayerDetails(for player: Player) {
		show(PlayerDetailsViewController(api: api, player: player), sender: self)
	}

	private func openPlays(players: [Player]) {
		show(PlaysListViewController(api: api, games: [viewModel.game], players: players), sender: self)
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
