//
//  StandingsListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-17.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum StandingsListAction: BaseAction {
	case dataChanged
	case graphQLError(GraphAPIError)
	case openRecordPlay
	case openGameDetails(GraphID)
	case openPlayerDetails(GraphID)
	case openPlays(PlayListFilter)
	case showPreferredPlayerSelection
}

enum StandingsListViewAction: BaseViewAction {
	case initialize
	case willAppear
	case reload
	case recordPlay
	case selectGame(GraphID)
	case selectPlayer(GraphID)
	case showPlays(PlayListFilter)
	case selectPreferredPlayer(PlayerListItem?)
	case selectPreferredOpponents([PlayerListItem])
}

class StandingsListViewModel: ViewModel {
	typealias StandingsQuery = MyLeaderboardAPI.StandingsQuery
	typealias ActionHandler = (_ action: StandingsListAction) -> Void

	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var games: [StandingsGame] = []
	private(set) var standings: [StandingsGame: StandingsFragment] = [:]

	private var hasCheckedForPreferredPlayer: Bool = false

	private var shouldCheckForPreferredPlayer: Bool {
		return !hasCheckedForPreferredPlayer && Player.preferred == nil
	}

	init(handleAction: @escaping ActionHandler) {
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: StandingsListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadData()
		case .willAppear:
			if shouldCheckForPreferredPlayer {
				hasCheckedForPreferredPlayer = true
				handleAction(.showPreferredPlayerSelection)
			}
		case .recordPlay:
			handleAction(.openRecordPlay)
		case .selectGame(let game):
			handleAction(.openGameDetails(game))
		case .selectPlayer(let player):
			handleAction(.openPlayerDetails(player))
		case .showPlays(let filter):
			handleAction(.openPlays(filter))
		case .selectPreferredPlayer(let player):
			Player.preferred = Player(from: player)
		case .selectPreferredOpponents(let opponents):
			Player.preferredOpponents = opponents.compactMap { Player(from: $0) }.sorted()
		}
	}

	private func loadData() {
		dataLoading = true
		StandingsQuery(first: 25, offset: 0).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.handle(response: response)
			}

			self?.dataLoading = false
		}
	}

	private func handle(response: StandingsQuery.Response) {
		self.games = response.games.map { $0.asStandingsGameFragmentFragment }
		self.games.enumerated().forEach { (index, game) in
			self.standings[game] = response.games[index].asStandingsFragmentFragment
		}
	}
}
