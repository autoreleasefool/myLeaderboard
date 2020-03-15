//
//  PlayerDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlayerDetailsAction: BaseAction {
	case playerLoaded(PlayerDetails)
	case dataChanged
	case graphQLError(GraphAPIError)
	case gameSelected(GraphID)
	case playerSelected(GraphID)
	case showPlays(PlayListFilter)
}

enum PlayerDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectGame(GraphID)
	case selectPlayer(GraphID)
	case showPlays(PlayListFilter)
}

class PlayerDetailsViewModel: ViewModel {
	typealias PlayerDetailsQuery = MyLeaderboardAPI.PlayerDetailsQuery
	typealias ActionHandler = (_ action: PlayerDetailsAction) -> Void

	var handleAction: ActionHandler

	private var playerID: GraphID
	private(set) var player: PlayerDetails? {
		didSet {
			if let player = self.player {
				handleAction(.playerLoaded(player))
			}
		}
	}

	private(set) var players: [Opponent] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var records: [PlayerDetailsRecord] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var plays: [RecentPlay] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(playerID: GraphID, handleAction: @escaping ActionHandler) {
		self.playerID = playerID
		self.player = nil
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlayerDetailsViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadData()
		case .selectGame(let game):
			handleAction(.gameSelected(game))
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .showPlays(let filter):
			handleAction(.showPlays(filter))
		}
	}

	private func loadData(retry: Bool = true) {
		PlayerDetailsQuery(id: self.playerID).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.handle(response: response)
			}
		}
	}

	private func handle(response: MyLeaderboardAPI.PlayerDetailsResponse) {
		guard let player = response.player?.asPlayerDetailsFragmentFragment else {
			return handleAction(.graphQLError(.missingData))
		}

		self.player = player
		players = Array(Set(response.player?.records.flatMap {
			$0.asPlayerDetailsRecordFragmentFragment.records.map { $0.opponent.asOpponentFragmentFragment }
		} ?? [])).sorted()
		records = response.player?.records.map { $0.asPlayerDetailsRecordFragmentFragment } ?? []
		plays = response.player?.recentPlays.map { $0.asRecentPlayFragmentFragment } ?? []
	}
}
