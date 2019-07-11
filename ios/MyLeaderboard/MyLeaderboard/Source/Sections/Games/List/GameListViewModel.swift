//
//  GameListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum GameListAction: BaseAction {
	case gamesUpdated([Game])
	case gameSelected(Game)
	case addGame
	case error(Error)
}

enum GameListViewAction: BaseViewAction {
	case initialize
	case reload
	case selectGame(Game)
	case addGame
}

class GameListViewModel: ViewModel {
	typealias ActionHandler = (_ action: GameListAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var games: [Game] = [] {
		didSet {
			handleAction(.gamesUpdated(games))
		}
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: GameListViewAction) {
		switch viewAction {
		case .selectGame(let game):
			handleAction(.gameSelected(game))
		case .initialize, .reload:
			loadGameList()
		case .addGame:
			handleAction(.addGame)
		}
	}

	private func loadGameList() {
		api.games { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.error(error))
			case .success(let games):
				self?.games = games
			}
		}
	}
}
