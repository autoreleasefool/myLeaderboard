//
//  PlayerListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlayerListAction: BaseAction {
	case playersUpdated([Player])
	case playerSelected(Player)
	case addPlayer
	case graphQLError(GraphAPIError)
}

enum PlayerListViewAction: BaseViewAction {
	case initialize
	case reload
	case selectPlayer(Player)
	case addPlayer
}

class PlayerListViewModel: ViewModel {
	typealias PlayerListQuery = MyLeaderboardAPI.PlayerListQuery
	typealias ActionHandler = (_ action: PlayerListAction) -> Void

	var handleAction: ActionHandler

	private(set) var players: [Player] = [] {
		didSet {
			handleAction(.playersUpdated(players))
		}
	}

	init(handleAction: @escaping ActionHandler) {
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlayerListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadPlayerList()
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .addPlayer:
			handleAction(.addPlayer)
		}
	}

	private func loadPlayerList() {
		PlayerListQuery(first: 25, offset: 0).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.players = response.players.compactMap { Player(from: $0.asPlayerListItemFragment) }.sorted()
			}
		}
	}
}
