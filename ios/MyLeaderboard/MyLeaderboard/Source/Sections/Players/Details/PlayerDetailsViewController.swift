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

	init(api: LeaderboardAPI, player: Player) {
		self.api = api
		super.init()
		refreshable = true

		viewModel = PlayerDetailsViewModel(api: api, player: player) { [weak self] action in
			switch action {
			case .dataChanged:
				self?.finishRefresh()
				self?.render()
			case .apiError(let error):
				self?.presentError(error)
			case .gameSelected(let game):
				self?.showGameDetails(for: game)
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .openAllPlays:
				self?.openAllPlays()
			}
		}

		self.title = player.displayName
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		let sections = PlayerDetailsBuilder.sections(player: viewModel.player, records: viewModel.records, players: viewModel.players, plays: viewModel.plays, tableData: tableData, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func showGameDetails(for game: Game) {
		show(GameDetailsViewController(api: api, game: game), sender: self)
	}

	private func showPlayerDetails(for player: Player) {
		show(PlayerDetailsViewController(api: api, player: player), sender: self)
	}

	private func openAllPlays() {
		show(PlaysListViewController(api: api, player: viewModel.player), sender: self)
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

extension PlayerDetailsViewController: PlayerDetailsActionable {
	func selectedGame(game: Game) {
		viewModel.postViewAction(.selectGame(game))
	}

	func selectedPlayer(player: Player) {
		viewModel.postViewAction(.selectPlayer(player))
	}

	func showAllPlays() {
		viewModel.postViewAction(.showAllPlays)
	}
}
