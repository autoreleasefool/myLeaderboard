//
//  PlayerListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import MyLeaderboardApi

enum PlayerListAction: BaseAction {
	case dataChanged
	case playerSelected(GraphID)
	case addPlayer
	case graphQLError(GraphAPIError)
}

enum PlayerListViewAction: BaseViewAction {
	case initialize
	case reload
	case loadMore
	case selectPlayer(GraphID)
	case addPlayer
}

class PlayerListViewModel: ViewModel {
	typealias PlayerListQuery = MyLeaderboardApi.PlayerListQuery
	typealias ActionHandler = (_ action: PlayerListAction) -> Void
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

	private(set) var players: [PlayerListItem] = []

	init(boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.boardId = boardId
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlayerListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadPlayerList()
		case .loadMore:
			guard !dataLoading && !loadingMore && hasMore else { return }
			loadPlayerList(offset: players.count)
		case .selectPlayer(let playerID):
			handleAction(.playerSelected(playerID))
		case .addPlayer:
			handleAction(.addPlayer)
		}
	}

	private func loadPlayerList(offset: Int = 0) {
		dataLoading = true
		if offset > 0 {
			loadingMore = true
		}

		PlayerListQuery(
			board: boardId,
			first: PlayerListViewModel.pageSize,
			offset: offset
		).perform { [weak self] in
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

	private func handle(response: PlayerListQuery.Response, offset: Int) {
		let newPlayers = response.players.map { $0.asPlayerListItemFragment }
		hasMore = newPlayers.count == PlayerListViewModel.pageSize

		if offset > 0 {
			self.players.append(contentsOf: newPlayers)
		} else {
			self.players = newPlayers
		}
	}
}
