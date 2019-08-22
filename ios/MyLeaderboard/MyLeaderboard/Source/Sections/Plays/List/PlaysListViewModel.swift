//
//  PlaysListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlaysListAction: BaseAction {
	case dataChanged
	case apiError(LeaderboardAPIError)
}

enum PlaysListViewAction: BaseViewAction {
	case initialize
	case reload
}

class PlaysListViewModel: ViewModel {
	typealias ActionHandler = (_ action: PlaysListAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private let gameID: ID?
	private let playerID: ID?

	private(set) var plays: [GamePlay] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var players: [Player] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(api: LeaderboardAPI, gameID: ID?, playerID: ID?, handleAction: @escaping ActionHandler) {
		self.api = api
		self.gameID = gameID
		self.playerID = playerID
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlaysListViewAction) {
		switch viewAction {
		case .initialize:
			loadData()
		case .reload:
			reloadData()
		}
	}

	private func reloadData() {
		api.refresh { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success:
				self?.loadData()
			}
		}
	}

	private func loadData() {
		api.players { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players
			}
		}

		api.plays { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let plays):
				self?.plays = plays.filter {
					if let gameID = self?.gameID, $0.game != gameID {
						return false
					}

					if let playerID = self?.playerID, !$0.players.contains(playerID) {
						return false
					}

					return true
				}.sorted().reversed()
			}
		}
	}
}
