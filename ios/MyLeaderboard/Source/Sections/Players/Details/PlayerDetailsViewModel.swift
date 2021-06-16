//
//  PlayerDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi

enum PlayerDetailsAction: BaseAction {
	case dataChanged
	case graphQLError(MyLeaderboardAPIError)
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
	typealias PlayerDetailsQuery = MyLeaderboardApi.PlayerDetailsQuery
	typealias ActionHandler = (_ action: PlayerDetailsAction) -> Void

	let boardId: GraphID
	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private var playerID: GraphID

	private(set) var player: PlayerDetails?
	private(set) var players: [Opponent] = []
	private(set) var records: [PlayerDetailsRecord] = []
	private(set) var plays: [RecentPlay] = []

	private var cancellable: AnyCancellable?

	init(playerID: GraphID, boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.playerID = playerID
		self.boardId = boardId
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

	private func loadData() {
		dataLoading = true

		let query = PlayerDetailsQuery(id: self.playerID)
		cancellable = MLApi.shared.fetch(query: query)
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result {
					self?.handleAction(.graphQLError(error))
				}

				self?.dataLoading = false
			}, receiveValue: { [weak self] value in
				self?.handle(response: value)
			})
	}

	private func handle(response: MyLeaderboardApi.PlayerDetailsResponse) {
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
