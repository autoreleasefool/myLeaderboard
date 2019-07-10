//
//  GameListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class GameListViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: GameListViewModel!

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = GameListViewModel(api: api) { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .gamesUpdated:
				self.render()
			case .gameSelected(let game):
				self.showGameDetails(for: game)
			case .error(let error):
				self.presentError(error)
			}
		}

		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		let sections = GameListBuilder.sections(games: viewModel.games, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func showGameDetails(for game: Game) {
		print("Selected game \(game.name)")
	}

	private func presentError(_ error: Error) {
		print("Error: \(error)")
	}
}

extension GameListViewController: GameListActionable {
	func selectedGame(game: Game) {
		viewModel.postViewAction(.selectGame(game))
	}
}
