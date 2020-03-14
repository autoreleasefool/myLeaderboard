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
	case noPreferredOpponents(TodayCompletionHandler?)
	case dataChanged(TodayCompletionHandler?)
	case apiError(LeaderboardAPIError, TodayCompletionHandler)
	case presentRoute(Route)
}

enum TodayViewAction: BaseViewAction {
	case performUpdate(TodayCompletionHandler)
	case openPlayerDetails(Player)
	case openGameDetails(Game)
	case openStandings
	case openPreferredPlayerSelection
	case openPreferredOpponentsSelection
}

class TodayViewModel: ViewModel {
	typealias ActionHandler = (_ action: TodayAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var preferredPlayer: Player?
	private(set) var preferredOpponents: [Player] = []
	private(set) var gameStandings: [Game: PlayerStandings?] = [:]

	var visiblePlayers: [Player] {
		return preferredOpponents.filter { player in
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

			guard Player.preferredOpponents.count > 0 else {
				handleAction(.noPreferredOpponents(completionHandler))
				return
			}

			preferredOpponents = Player.preferredOpponents
			fetchPlayerData(completionHandler: completionHandler)
		case .openGameDetails(let game):
			handleAction(.presentRoute(.gameDetails(game.id)))
		case .openPlayerDetails(let player):
			handleAction(.presentRoute(.playerDetails(player.id)))
		case .openStandings:
			handleAction(.presentRoute(.standings))
		case .openPreferredPlayerSelection:
			handleAction(.presentRoute(.preferredPlayer))
		case .openPreferredOpponentsSelection:
			handleAction(.presentRoute(.preferredOpponents))
		}
	}

	private func fetchPlayerData(completionHandler: @escaping TodayCompletionHandler) {
		// DispatchGroup to wait to fetch all players and game standings
		let dispatchGroup = DispatchGroup()

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

	private func fetchPlayerRecord(
		for game: Game,
		dispatchGroup: DispatchGroup,
		completionHandler: @escaping TodayCompletionHandler
	) {
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
