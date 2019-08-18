//
//  StandingsListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-17.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum StandingsListAction: BaseAction {
	case standingsUpdated
	case apiError(LeaderboardAPIError)
	case openRecordPlay
	case openGameDetails(Game)
}

enum StandingsListViewAction: BaseViewAction {
	case initialize
	case reload
	case recordPlay
	case selectGame(Game)
}

class StandingsListViewModel: ViewModel {
	typealias ActionHandler = (_ action: StandingsListAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var standings: [Game: Standings?] = [:] {
		didSet {
			handleAction(.standingsUpdated)
		}
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: StandingsListViewAction) {
		switch viewAction {
		case .initialize:
			loadGamesAndStandings()
		case .reload:
			reloadGamesAndStandings()
		case .recordPlay:
			handleAction(.openRecordPlay)
		case .selectGame(let game):
			handleAction(.openGameDetails(game))
		}
	}

	private func reloadGamesAndStandings() {
		api.refresh { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success:
				self?.loadGamesAndStandings()
			}
		}
	}

	private func loadGamesAndStandings() {
		api.games { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let games):
				self?.loadStandings(for: games)
			}
		}
	}

	private func loadStandings(for games: [Game]) {
		games.forEach {
			standings[$0] = nil

			api.standings(for: $0) { [weak self] result in
				switch result {
				case .failure(let error):
					self?.handleAction(.apiError(error))
				case .success((let game, let standings)):
					self?.standings[game] = standings
				}
			}
		}
	}
}
