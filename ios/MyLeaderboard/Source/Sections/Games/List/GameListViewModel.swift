//
//  GameListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi

enum GameListAction: BaseAction {
	case dataChanged
	case gameSelected(GraphID)
	case addGame
	case graphQLError(MyLeaderboardAPIError)
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

	private var cancellable: AnyCancellable?

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

		let query = GameListQuery(first: GameListViewModel.pageSize, offset: offset)

		cancellable = MLApi.shared.fetch(query: query)
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result, let graphError = error.graphQLError {
					self?.handleAction(.graphQLError(graphError))
				}

				self?.dataLoading = false
				if offset > 0 {
					self?.loadingMore = false
				}
			}, receiveValue: { [weak self] value in
				guard let response = value.response else { return }
				self?.handle(response: response, offset: offset)
			})
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
