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
	case graphQLError(GraphAPIError)
	case gameSelected(GraphID)
	case playerSelected(GraphID)
	case showPlays([GraphID], [GraphID])
}

enum PlayerDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectGame(GraphID)
	case selectPlayer(GraphID)
	case showPlays([GraphID], [GraphID])
}

class PlayerDetailsViewModel: ViewModel {
	typealias ActionHandler = (_ action: PlayerDetailsAction) -> Void

	var handleAction: ActionHandler

	private var playerID: GraphID
	private(set) var player: Player? {
		didSet {
			if let player = self.player {
				handleAction(.playerLoaded(player))
			}
		}
	}

	private(set) var records: [PlayerGameRecord] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var plays: [RecentPlay] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(api: LeaderboardAPI, id: GraphID, handleAction: @escaping ActionHandler) {
		self.playerID = id
		self.player = nil
		self.handleAction = handleAction
	}

	init(api: LeaderboardAPI, player: Player, handleAction: @escaping ActionHandler) {
		self.playerID = player.graphID
		self.player = player
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
		case .showPlays(let games, let players):
			handleAction(.showPlays(games, players))
		}
	}

	private func loadData(retry: Bool = true) {
		MyLeaderboardAPI.PlayerDetailsQuery(id: self.playerID).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.handle(response: response)
			}
		}
	}

	private func handle(response: MyLeaderboardAPI.PlayerDetailsResponse) {
		guard let player = response.player else {
			return handleAction(.graphQLError(.missingData))
		}

		self.player = Player(from: player)
		records = response.player?.records.map {
			PlayerGameRecord(from: $0)
		} ?? []
		plays = response.player?.recentPlays.map {
			RecentPlay(from: $0.asRecentPlayFragmentFragment)
		} ?? []
	}
}
