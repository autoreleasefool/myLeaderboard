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

	let game: Game?
	let player: Player?

	private(set) var games: [Game] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

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

	init(api: LeaderboardAPI, game: Game?, player: Player?, handleAction: @escaping ActionHandler) {
		self.api = api
		self.game = game
		self.player = player
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

		if player != nil {
			api.games { [weak self] in
				switch $0 {
				case .failure(let error):
					self?.handleAction(.apiError(error))
				case .success(let games):
					self?.games = games
				}
			}
		}

		api.plays { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let plays):
				self?.plays = plays.filter {
					if let game = self?.game, $0.game != game.id {
						return false
					}

					if let player = self?.player, !$0.players.contains(player.id) {
						return false
					}

					return true
				}.sorted().reversed()
			}
		}
	}
}
