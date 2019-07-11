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
	case error(Error)
}

enum PlayerListViewAction: BaseViewAction {
	case initialize
	case reload
}

class PlayerListViewModel: ViewModel {
	typealias ActionHandler = (_ action: PlayerListAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var players: [Player] = [] {
		didSet {
			handleAction(.playersUpdated(players))
		}
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlayerListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadPlayerList()
		}
	}

	private func loadPlayerList() {
		api.players { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.error(error))
			case .success(let players):
				self?.players = players
			}
		}
	}
}
