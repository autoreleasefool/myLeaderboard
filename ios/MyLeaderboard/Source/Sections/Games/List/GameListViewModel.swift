//
//  GameListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

enum GameListAction: BaseAction {
	case dataChanged
	case gameSelected(GraphID)
	case addGame
	case graphQLError(GraphAPIError)
}

enum GameListViewAction: BaseViewAction {
	case initialize
	case reload
	case loadMore
	case selectGame(GraphID)
	case addGame
}

class GameListViewModel: ViewModel {
	typealias GameListQuery = MyLeaderboardApi.GameListQuery
	typealias ActionHandler = (_ action: GameListAction) -> Void
	private static let pageSize = 25

	let boardId: GraphID
	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var hasMore: Bool = false
	private(set) var loadingMore: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var games: [GameListItem] = []

	init(boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.boardId = boardId
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: GameListViewAction) {
		switch viewAction {
		case .selectGame(let game):
			handleAction(.gameSelected(game))
		case .initialize, .reload:
			loadGameList()
		case .loadMore:
			guard !dataLoading && !loadingMore && hasMore else { return }
			loadGameList(offset: games.count)
		case .addGame:
			handleAction(.addGame)
		}
	}

	private func loadGameList(offset: Int = 0) {
		dataLoading = true
		if offset > 0 {
			loadingMore = true
		}

		GameListQuery(first: GameListViewModel.pageSize, offset: offset).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.handle(response: response, offset: offset)
			}

			self?.dataLoading = false
			if offset > 0 {
				self?.loadingMore = false
			}
		}
	}

	private func handle(response: GameListQuery.Response, offset: Int) {
		let newGames = response.games.map { $0.asGameListItemFragment }
		hasMore = newGames.count == GameListViewModel.pageSize

		if offset > 0 {
			self.games.append(contentsOf: newGames)
		} else {
			self.games = newGames
		}
	}
}
