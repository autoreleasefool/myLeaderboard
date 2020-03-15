//
//  PlayerListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlayerListAction: BaseAction {
	case dataChanged
	case playerSelected(GraphID)
	case addPlayer
	case graphQLError(GraphAPIError)
}

enum PlayerListViewAction: BaseViewAction {
	case initialize
	case reload
	case selectPlayer(GraphID)
	case addPlayer
}

class PlayerListViewModel: ViewModel {
	typealias PlayerListQuery = MyLeaderboardAPI.PlayerListQuery
	typealias ActionHandler = (_ action: PlayerListAction) -> Void

	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var players: [PlayerListItem] = []

	init(handleAction: @escaping ActionHandler) {
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlayerListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadPlayerList()
		case .selectPlayer(let playerID):
			handleAction(.playerSelected(playerID))
		case .addPlayer:
			handleAction(.addPlayer)
		}
	}

	private func loadPlayerList() {
		dataLoading = true
		PlayerListQuery(first: 25, offset: 0).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.players = response.players.map { $0.asPlayerListItemFragment }
			}

			self?.dataLoading = false
		}
	}
}
