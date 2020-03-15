//
//  PlaysListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlaysListAction: BaseAction {
	case titleChanged
	case dataChanged
	case graphQLError(GraphAPIError)
}

enum PlaysListViewAction: BaseViewAction {
	case initialize
	case reload
}

class PlaysListViewModel: ViewModel {
	typealias PlayListQuery = MyLeaderboardAPI.PlayListQuery
	typealias ActionHandler = (_ action: PlaysListAction) -> Void
	static let defaultTitle = "Filtered plays"

	var handleAction: ActionHandler

	let filterGameID: GraphID?
	let filterPlayerIDs: [GraphID]?

	private(set) var plays: [PlayListItem] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var title: String = PlaysListViewModel.defaultTitle {
		didSet {
			handleAction(.titleChanged)
		}
	}

	init(gameID: GraphID? = nil, playerIDs: [GraphID] = [], handleAction: @escaping ActionHandler) {
		self.filterGameID = gameID
		self.filterPlayerIDs = playerIDs.count > 0 ? playerIDs : nil
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlaysListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadData()
		}
	}

	private func loadData() {
		PlayListQuery(
			first: 25,
			offset: 0,
			game: filterGameID,
			players: filterPlayerIDs
		).perform { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			case .success(let response):
				self?.handle(response: response)
			}
		}
	}

	private func playerName(for playerID: GraphID, from play: PlayListItem) -> String? {
		return play.players.first(where: { $0.id == playerID })?.displayName
	}

	private func handle(response: PlayListQuery.Response) {
		self.plays = response.plays.map { $0.asPlayListItemFragment }

		guard let firstPlay = plays.first else {
			self.title = PlaysListViewModel.defaultTitle
			return
		}

		let playerCount = filterPlayerIDs?.count ?? 0

		if filterGameID != nil {
			if playerCount > 1 {
				self.title = "Filtered \(firstPlay.game.name) plays"
			} else if playerCount == 1 {
				let playerName = self.playerName(for: filterPlayerIDs!.first!, from: firstPlay)!
				self.title = "\(playerName)'s \(firstPlay.game.name) plays"
			} else {
				self.title = "\(firstPlay.game.name) plays"
			}
		} else {
			if playerCount > 1 {
				self.title = "Filtered plays"
			} else if playerCount == 1 {
				let playerName = self.playerName(for: filterPlayerIDs!.first!, from: firstPlay)!
				self.title = "\(playerName)'s plays"
			} else {
				self.title = "All plays"
			}
		}
	}
}
