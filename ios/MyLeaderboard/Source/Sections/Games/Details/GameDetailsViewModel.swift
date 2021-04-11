//
//  GameDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

enum GameDetailsAction: BaseAction {
	case dataChanged
	case playerSelected(GraphID)
	case graphQLError(GraphAPIError)
	case openPlays(PlayListFilter)
}

enum GameDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectPlayer(GraphID)
	case showPlays(PlayListFilter)
}

class GameDetailsViewModel: ViewModel {
	typealias GameDetailsQuery = MyLeaderboardApi.GameDetailsQuery
	typealias ActionHandler = (_ action: GameDetailsAction) -> Void

	let boardId: GraphID
	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var gameID: GraphID
	private(set) var game: GameDetails?
	private(set) var plays: [RecentPlay] = []
	private(set) var players: [Opponent] = []
	private(set) var standings: GameDetailsStandings?

	init(gameID: GraphID, boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.gameID = gameID
		self.boardId = boardId
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: GameDetailsViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadData()
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .showPlays(let filter):
			handleAction(.openPlays(filter))
		}
	}

	private func loadData(retry: Bool = true) {
		self.dataLoading = true
		GameDetailsQuery(id: gameID, board: boardId, ignoreBanished: true).perform { [weak self] result in
			switch result {
			case .success(let response):
				self?.handle(response: response)
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}

			self?.dataLoading = false
		}
	}

	private func handle(response: MyLeaderboardApi.GameDetailsResponse) {
		guard let game = response.game?.asGameDetailsFragmentFragment else {
			return handleAction(.graphQLError(.missingData))
		}

		self.game = game
		self.players = response.game?.standings.records.map { $0.player.asOpponentFragmentFragment } ?? []
		self.standings = response.game?.standings.asGameDetailsStandingsFragmentFragment
		self.plays = response.game?.recentPlays.map { $0.asRecentPlayFragmentFragment } ?? []
	}
}
