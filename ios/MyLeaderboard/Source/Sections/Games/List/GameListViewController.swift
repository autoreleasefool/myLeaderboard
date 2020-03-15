//
//  GameListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

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
		viewModel = GameListViewModel { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .gamesUpdated:
				self.finishRefresh()
				self.render()
			case .gameSelected(let game):
				self.showGameDetails(for: game)
			case .addGame:
				self.showCreateGame()
			case .graphQLError(let error):
				self.finishRefresh()
				self.presentError(error)
			}
		}

		self.title = "Games"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewGame)
		)

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
		presentModal(CreateGameViewController(api: api) { game in
			Loaf("\(game.name) created!", state: .success, sender: self).show()
		})
	}

	private func showGameDetails(for gameID: GraphID) {
		let gameName = viewModel.games.first(where: { $0.id == gameID })?.name
		show(GameDetailsViewController(gameID: gameID, withGameName: gameName), sender: self)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension GameListViewController: GameListActionable {
	func selectedGame(gameID: GraphID) {
		viewModel.postViewAction(.selectGame(gameID))
	}
}

extension GameListViewController: RouteHandler {
	func openRoute(_ route: Route) {
		guard case .gameDetails(let gameID) = route else {
			return
		}

		show(GameDetailsViewController(gameID: gameID), sender: self)
	}
}
