//
//  GameDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum GameDetailsAction: BaseAction {
	case dataChanged
	case playerSelected(Player)
	case apiError(LeaderboardAPIError)
	case openPlays([Player])
}

enum GameDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectPlayer(Player)
	case showPlays([Player])
}

class GameDetailsViewModel: ViewModel {
	typealias ActionHandler = (_ action: GameDetailsAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var game: Game

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

	private(set) var standings: Standings? = nil {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(api: LeaderboardAPI, game: Game, handleAction: @escaping ActionHandler) {
		self.api = api
		self.game = game
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: GameDetailsViewAction) {
		switch viewAction {
		case .initialize:
			loadData()
		case .reload:
			reloadData()
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .showPlays(let players):
			handleAction(.openPlays(players))
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
		api.plays { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let plays):
				self?.plays = plays.filter { $0.game == self?.game.id }.sorted().reversed()
			}
		}

		api.standings(for: game) { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success((_, let standings)):
				self?.standings = standings
			}
		}

		api.players { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players.sorted()
			}
		}
	}
}
