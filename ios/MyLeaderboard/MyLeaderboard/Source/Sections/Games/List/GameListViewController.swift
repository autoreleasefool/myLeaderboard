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

		refreshable = true
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
				self.finishRefresh()
				self.render()
			case .gameSelected(let game):
				self.showGameDetails(for: game)
			case .addGame:
				self.showCreateGame()
			case .error(let error):
				self.presentError(error)
			}
		}

		self.title = "Games"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGame))

		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		let sections = GameListBuilder.sections(games: viewModel.games, actionable: self)
		tableData.renderAndDiff(sections)
	}

	@objc private func addNewGame() {
		viewModel.postViewAction(.addGame)
	}

	private func showCreateGame() {
		presentModal(CreateGameViewController(api: api))
	}

	private func showGameDetails(for game: Game) {
		print("Selected game \(game.name)")
	}

	private func presentError(_ error: Error) {
		print("Error: \(error)")
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension GameListViewController: GameListActionable {
	func selectedGame(game: Game) {
		viewModel.postViewAction(.selectGame(game))
	}
}