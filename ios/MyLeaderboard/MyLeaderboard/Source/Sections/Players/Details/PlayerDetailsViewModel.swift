//
//  PlayerDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlayerDetailsAction: BaseAction {
	case playerLoaded(Player)
	case dataChanged
	case apiError(LeaderboardAPIError)
	case gameSelected(Game)
	case playerSelected(Player)
	case showPlays([Game], [Player])
}

enum PlayerDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectGame(Game)
	case selectPlayer(Player)
	case showPlays([Game], [Player])
}

class PlayerDetailsViewModel: ViewModel {
	typealias ActionHandler = (_ action: PlayerDetailsAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private var playerID: ID?
	private(set) var player: Player? {
		didSet {
			if let player = self.player {
				handleAction(.playerLoaded(player))
			}
		}
	}

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

	init(api: LeaderboardAPI, id: ID, handleAction: @escaping ActionHandler) {
		self.api = api
		self.playerID = id
		self.player = nil
		self.handleAction = handleAction
	}

	init(api: LeaderboardAPI, player: Player, handleAction: @escaping ActionHandler) {
		self.api = api
		self.playerID = player.id
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
		case .showPlays(let games, let players):
			handleAction(.showPlays(games, players))
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

	private func loadData(retry: Bool = true) {
		guard let player = player else {
			if retry {
				loadPlayer()
			} else {
				self.handleAction(.apiError(.missingData))
			}
			return
		}

		api.games { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let games):
				games.forEach {
					self?.records[$0] = nil
					self?.fetchPlayerStandings(for: $0, player: player)
				}
			}
		}

		api.players { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players.sorted()
			}
		}

		api.plays { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure(let error):
				self.handleAction(.apiError(error))
			case .success(let plays):
				self.plays = plays.filter {
					$0.players.contains(player.id)
				}.sorted().reversed()
			}
		}
	}

	private func fetchPlayerStandings(for game: Game, player: Player) {
		api.playerRecord(playerID: player.id, gameID: game.id) { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let playerRecord):
				self?.records[game] = playerRecord
			}
		}
	}

	private func loadPlayer() {
		api.players { [weak self] result in
			switch result {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.player = players.first { $0.id == self?.playerID }
				self?.loadData(retry: false)
			}
		}
	}
}
