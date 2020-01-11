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
	case apiError(LeaderboardAPIError)
}

enum PlayerListViewAction: BaseViewAction {
	case initialize
	case reload
	case selectPlayer(Player)
	case addPlayer
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
		case .initialize:
			loadPlayerList()
		case .reload:
			reloadPlayerList()
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .addPlayer:
			handleAction(.addPlayer)
		}
	}

	private func loadPlayerList() {
		api.players { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players
			}
		}
	}

	private func reloadPlayerList() {
		api.refresh { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success:
				self?.loadPlayerList()
			}
		}
	}
}
