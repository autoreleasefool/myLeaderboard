//
//  PlayerListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi

enum PlayerListAction: BaseAction {
	case dataChanged
	case playerSelected(GraphID)
	case addPlayer
	case graphQLError(MyLeaderboardAPIError)
	case showPreferredPlayerSelection
}

enum PlayerListViewAction: BaseViewAction {
	case initialize
	case didAppear
	case reload
	case loadMore
	case selectPlayer(GraphID)
	case addPlayer
	case selectPreferredPlayer(PlayerListItem?)
}

class PlayerListViewModel: ViewModel {
	typealias PlayerListQuery = MyLeaderboardApi.PlayerListQuery
	typealias ActionHandler = (_ action: PlayerListAction) -> Void
	private static let pageSize = 25

	let boardId: GraphID
	var handleAction: ActionHandler

	private var hasFetchedPlayers: Bool = false
	private var hasAppeared: Bool = false
	private var hasCheckedForPreferredPlayer: Bool = false

	private var shouldCheckForPreferredPlayer: Bool {
		return !hasCheckedForPreferredPlayer && hasFetchedPlayers && players.count > 0 && Player.preferred == nil
	}

	private var cancellable: AnyCancellable?

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
		case .didAppear:
			hasAppeared = true
			if shouldCheckForPreferredPlayer {
				hasCheckedForPreferredPlayer = true
				handleAction(.showPreferredPlayerSelection)
			}
		case .loadMore:
			guard !dataLoading && !loadingMore && hasMore else { return }
			loadPlayerList(offset: players.count)
		case .selectPlayer(let playerID):
			handleAction(.playerSelected(playerID))
		case .addPlayer:
			handleAction(.addPlayer)
		case .selectPreferredPlayer(let player):
			Player.preferred = player
		}
	}

	private func loadPlayerList(offset: Int = 0) {
		dataLoading = true
		if offset > 0 {
			loadingMore = true
		}

		let query = PlayerListQuery(
			board: boardId,
			first: PlayerListViewModel.pageSize,
			offset: offset
		)

		cancellable = MLApi.shared.fetch(query: query)
			.sink(receiveCompletion: { [weak self] result in
				guard let self = self else { return }
				self.hasFetchedPlayers = true

				if case let .failure(error) = result {
					self.handleAction(.graphQLError(error))
				}

				self.dataLoading = false
				if offset > 0 {
					self.loadingMore = false
				}

				if self.shouldCheckForPreferredPlayer {
					self.hasCheckedForPreferredPlayer = true
					self.handleAction(.showPreferredPlayerSelection)
				}
			}, receiveValue: { [weak self] value in
				self?.handle(response: value, offset: offset)
			})
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
