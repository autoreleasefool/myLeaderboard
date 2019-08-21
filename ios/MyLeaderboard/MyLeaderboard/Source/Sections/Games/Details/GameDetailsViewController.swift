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

	init(api: LeaderboardAPI, game: Game) {
		self.api = api
		super.init()

		refreshable = true
		viewModel = GameDetailsViewModel(api: api, game: game) { [weak self] action in
			switch action {
			case .gameUpdated:
				self?.render()
			case .playerSelected(let player):
				self?.showPlayerDetails(for: player)
			case .apiError(let error):
				self?.presentError(error)
			}
		}

		self.title = game.name
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
		let sections = GameDetailsBuilder.sections(game: viewModel.game, players: viewModel.players, standings: viewModel.standingΩs, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func showPlayerDetails(for player: Player) {
		print("Show details for \(player.displayName)")
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
}

