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
	case graphQLError(GraphAPIError, TodayCompletionHandler)
	case presentRoute(Route)
}

enum TodayViewAction: BaseViewAction {
	case performUpdate(TodayCompletionHandler)
	case openPlayerDetails(GraphID)
	case openGameDetails(GraphID)
	case openStandings
	case openPreferredPlayerSelection
	case openPreferredOpponentsSelection
}

class TodayViewModel: ViewModel {
	typealias TodayViewQuery = MyLeaderboardAPI.TodayViewQuery
	typealias ActionHandler = (_ action: TodayAction) -> Void

	var handleAction: ActionHandler

	private(set) var preferredPlayer: PlayerListItem?
	private(set) var preferredOpponents: [PlayerListItem] = []
	private(set) var standings: [TodayViewRecord] = []

	var visiblePlayers: [Opponent] {
		return preferredOpponents.filter { player in
			return standings.first(where: {
				$0.records.first(where: { $0.opponent.id == player.id }) != nil
			}) != nil
		}.map { Opponent(id: $0.id, avatar: $0.avatar, displayName: $0.displayName) }
	}

	init(handleAction: @escaping ActionHandler) {
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
			fetchPlayerData(for: player, completionHandler: completionHandler)
		case .openGameDetails(let game):
			handleAction(.presentRoute(.gameDetails(game)))
		case .openPlayerDetails(let player):
			handleAction(.presentRoute(.playerDetails(player)))
		case .openStandings:
			handleAction(.presentRoute(.standings))
		case .openPreferredPlayerSelection:
			handleAction(.presentRoute(.preferredPlayer))
		case .openPreferredOpponentsSelection:
			handleAction(.presentRoute(.preferredOpponents))
		}
	}

	private func fetchPlayerData(for player: PlayerListItem, completionHandler: @escaping TodayCompletionHandler) {

		TodayViewQuery(player: player.id).perform { [weak self] in
			switch $0 {
			case .success(let response):
				guard let standings = response.player?.records.map({ $0.asTodayViewRecordFragmentFragment }) else {
					self?.handleAction(.graphQLError(.invalidResponse, completionHandler))
					return
				}
				self?.standings = standings
				self?.handleAction(.dataChanged(completionHandler))
			case .failure(let error):
				self?.handleAction(.graphQLError(error, completionHandler))
			}
		}
	}

	private func processData(completionHandler: @escaping TodayCompletionHandler) {
		guard visiblePlayers.count > 0 else {
			// Assume that an error was properly returned if there are no players or standings available
			return
		}

		handleAction(.dataChanged(completionHandler))
	}
}
