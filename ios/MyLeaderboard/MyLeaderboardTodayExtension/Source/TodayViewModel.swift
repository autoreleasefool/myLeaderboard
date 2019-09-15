//
//  TodayViewModel.swift
//  MyLeaderboardTodayExtension
//
//  Created by Joseph Roque on 2019-09-15.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum TodayAction: BaseAction {
	case noPreferredPlayer(TodayCompletionHandler?)
	case dataChanged(TodayCompletionHandler?)
	case apiError(LeaderboardAPIError, TodayCompletionHandler)
}

enum TodayViewAction: BaseViewAction {
	case performUpdate(TodayCompletionHandler)
	case nextPlayer
	case previousPlayer
}

class TodayViewModel: ViewModel {
	typealias ActionHandler = (_ action: TodayAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var preferredPlayer: Player?
	private(set) var players: [Player] = [] {
		didSet {
			if visiblePlayers.count <= firstPlayerIndex {
				firstPlayerIndex = visiblePlayers.count - 1
			}
		}
	}
	private(set) var gameStandings: [Game: PlayerStandings?] = [:]
	private(set) var firstPlayerIndex: Int = 0

	var visiblePlayers: [Player] {
		return players.filter { player in
			return gameStandings.first(where: { $0.value?.records[player.id] != nil }) != nil
		}
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: TodayViewAction) {
		switch viewAction {
		case .performUpdate(let completionHandler):
			guard let player = Player.preferred else {
				handleAction(.noPreferredPlayer(completionHandler))
				return
			}

			preferredPlayer = player
			fetchPlayerData(completionHandler: completionHandler)
		case .nextPlayer:
			firstPlayerIndex += 1
			if firstPlayerIndex == visiblePlayers.count - 2 {
				firstPlayerIndex = 0
			}
			handleAction(.dataChanged(nil))
		case .previousPlayer:
			firstPlayerIndex -= 1
			if firstPlayerIndex == -1 {
				firstPlayerIndex = visiblePlayers.count - 3
			}
			if firstPlayerIndex < 0 {
				firstPlayerIndex = 0
			}
			handleAction(.dataChanged(nil))
		}
	}

	private func fetchPlayerData(completionHandler: @escaping TodayCompletionHandler) {
		// DispatchGroup to wait to fetch all players and game standings
		let dispatchGroup = DispatchGroup()
		dispatchGroup.enter()

		api.players { [weak self] result in
			switch result {
			case .success(let players):
				self?.players = players.sorted()
			case .failure(let error):
				self?.players = []
				self?.handleAction(.apiError(error, completionHandler))
			}

			dispatchGroup.leave()
		}

		api.games { [weak self] result in
			switch result {
			case .success(let games):
				games.forEach {
					dispatchGroup.enter()
					self?.gameStandings[$0] = nil
					self?.fetchPlayerRecord(for: $0, dispatchGroup: dispatchGroup, completionHandler: completionHandler)
				}
			case .failure(let error):
				self?.handleAction(.apiError(error, completionHandler))
			}

			dispatchGroup.notify(queue: .main) { [weak self] in
				self?.processData(completionHandler: completionHandler)
			}
		}
	}

	private func fetchPlayerRecord(for game: Game, dispatchGroup: DispatchGroup, completionHandler: @escaping TodayCompletionHandler) {
		api.playerRecord(playerID: preferredPlayer!.id, gameID: game.id) { [weak self] result in
			switch result {
			case .success(let standings):
				self?.gameStandings[game] = standings
			case .failure(let error):
				self?.gameStandings = [:]
				self?.handleAction(.apiError(error, completionHandler))
			}

			dispatchGroup.leave()
		}
	}

	private func processData(completionHandler: @escaping TodayCompletionHandler) {
		guard visiblePlayers.count > 0 && gameStandings.count > 0 else {
			// Assume that an error was properly returned if there are no players or standings available
			return
		}

		handleAction(.dataChanged(completionHandler))
	}
}
