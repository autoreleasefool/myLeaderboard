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
	case loadMore
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
	private static let pageSize = 10

	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var hasMore: Bool = false
	private(set) var loadingMore: Bool = false {
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
		case .loadMore:
			guard !dataLoading && !loadingMore && hasMore else { return }
			loadData(offset: games.count)
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
			Player.preferred = player
		case .selectPreferredOpponents(let opponents):
			Player.preferredOpponents = opponents.sorted(by: { left, right in left.id < right.id })
		}
	}

	private func loadData(offset: Int = 0) {
		dataLoading = true
		if offset > 0 {
			loadingMore = true
		}

		StandingsQuery(first: StandingsListViewModel.pageSize, offset: offset).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.handle(response: response, offset: offset)
			}

			self?.dataLoading = false
			if offset > 0 {
				self?.loadingMore = false
			}
		}
	}

	private func handle(response: StandingsQuery.Response, offset: Int) {
		let newGames = response.games.map { $0.asStandingsGameFragmentFragment }
		hasMore = newGames.count == StandingsListViewModel.pageSize

		if offset > 0 {
			self.games.append(contentsOf: newGames)
		} else {
			self.games = newGames
		}

		self.games.enumerated().forEach { (index, game) in
			self.standings[game] = response.games[index].asStandingsFragmentFragment
		}
	}
}
