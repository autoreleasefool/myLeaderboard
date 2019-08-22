//
//  PlayerDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlayerDetailsAction: BaseAction {
	case dataChanged
	case apiError(LeaderboardAPIError)
	case gameSelected(Game)
	case playerSelected(Player)
	case openAllPlays
}

enum PlayerDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectGame(Game)
	case selectPlayer(Player)
	case showAllPlays
}

class PlayerDetailsViewModel: ViewModel {
	typealias ActionHandler = (_ action: PlayerDetailsAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	let player: Player

	private(set) var records: [Game: PlayerStandings?] = [:] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var players: [Player] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var plays: [GamePlay] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(api: LeaderboardAPI, player: Player, handleAction: @escaping ActionHandler) {
		self.api = api
		self.player = player
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlayerDetailsViewAction) {
		switch viewAction {
		case .initialize:
			loadData()
		case .reload:
			reloadData()
		case .selectGame(let game):
			handleAction(.gameSelected(game))
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .showAllPlays:
			handleAction(.openAllPlays)
		}
	}

	private func reloadData() {
		api.refresh { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success:
				self?.loadData()
			}
		}
	}

	private func loadData() {
		api.games { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let games):
				games.forEach {
					self?.records[$0] = nil
					self?.fetchPlayerStandings(for: $0)
				}
			}
		}

		api.players { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players
			}
		}

		// Fetch plays
	}

	private func fetchPlayerStandings(for game: Game) {
		api.playerRecord(playerID: player.id, gameID: game.id) { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let playerRecord):
				self?.records[game] = playerRecord
			}
		}
	}
}
