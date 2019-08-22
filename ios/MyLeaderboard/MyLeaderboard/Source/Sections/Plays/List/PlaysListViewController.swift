//
//  PlaysListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData
import Loaf

class PlaysListViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: PlaysListViewModel!

	init(api: LeaderboardAPI, game: Game? = nil, player: Player? = nil) {
		self.api = api
		super.init()
		refreshable = true

		viewModel = PlaysListViewModel(api: api, game: game, player: player) { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .dataChanged:
				self.finishRefresh()
				self.render()
			case .apiError(let error):
				self.presentError(error)
			}
		}

		if let game = game, let player = player {
			self.title = "\(player.displayName)'s \(game.name) Plays"
		} else if let game = game {
			self.title = "\(game.name) Plays"
		} else if let player = player {
			self.title = "\(player.displayName)'s Plays"
		} else {
			self.title = "All Plays"
		}
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
		let sections: [TableSection]
		if let player = viewModel.player {
			sections = PlaysListBuilder.sections(forPlayer: player, plays: viewModel.plays, games: viewModel.games, players: viewModel.players, actionable: self)
		} else if let game = viewModel.game {
			sections = PlaysListBuilder.sections(forGame: game, plays: viewModel.plays, players: viewModel.players, actionable: self)
		} else {
			sections = PlaysListBuilder.sections(plays: viewModel.plays, players: viewModel.players, actionable: self)
		}

		tableData.renderAndDiff(sections)
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

extension PlaysListViewController: PlaysListActionable {

}
