//
//  GameListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum GameListAction: BaseAction {
	case gamesUpdated([GameListItem])
	case gameSelected(GraphID)
	case addGame
	case graphQLError(GraphAPIError)
}

enum GameListViewAction: BaseViewAction {
	case initialize
	case reload
	case selectGame(GraphID)
	case addGame
}

class GameListViewModel: ViewModel {
	typealias GameListQuery = MyLeaderboardAPI.GameListQuery
	typealias ActionHandler = (_ action: GameListAction) -> Void

	var handleAction: ActionHandler

	private(set) var games: [GameListItem] = [] {
		didSet {
			handleAction(.gamesUpdated(games))
		}
	}

	init(handleAction: @escaping ActionHandler) {
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
		GameListQuery(first: 25, offset: 0).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.games = response.games.compactMap { $0.asGameListItemFragment }
			}
		}
	}
}
