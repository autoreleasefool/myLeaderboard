//
//  PlaysListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

enum PlaysListAction: BaseAction {
	case dataChanged
	case graphQLError(GraphAPIError)
}

enum PlaysListViewAction: BaseViewAction {
	case initialize
	case reload
	case loadMore
}

class PlaysListViewModel: ViewModel {
	typealias PlayListQuery = MyLeaderboardApi.PlayListQuery
	typealias ActionHandler = (_ action: PlaysListAction) -> Void
	private static let defaultTitle = "Filtered plays"
	private static let pageSize = 25

	let boardId: GraphID
	var handleAction: ActionHandler

	let filter: PlayListFilter

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

	private(set) var plays: [PlayListItem] = []
	private(set) var title: String = PlaysListViewModel.defaultTitle

	init(boardId: GraphID, filter: PlayListFilter, handleAction: @escaping ActionHandler) {
		self.boardId = boardId
		self.filter = filter
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlaysListViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadData()
		case .loadMore:
			guard !dataLoading && !loadingMore && hasMore else { return }
			loadData(offset: plays.count)
		}
	}

	private func loadData(offset: Int = 0) {
		dataLoading = true
		if offset > 0 {
			loadingMore = true
		}

		PlayListQuery(
			first: PlaysListViewModel.pageSize,
			offset: offset,
			game: filter.gameID,
			board: boardId,
			players: filter.playerIDs
		).perform { [weak self] in
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

	private func playerName(for playerID: GraphID, from play: PlayListItem) -> String? {
		return play.players.first(where: { $0.id == playerID })?.displayName
	}

	private func handle(response: PlayListQuery.Response, offset: Int) {
		let newPlays = response.plays.map { $0.asPlayListItemFragment }
		hasMore = newPlays.count == PlaysListViewModel.pageSize

		if offset > 0 {
			self.plays.append(contentsOf: newPlays)
		} else {
			self.plays = newPlays
		}

		guard let firstPlay = plays.first else {
			self.title = PlaysListViewModel.defaultTitle
			return
		}

		let playerCount = filter.playerIDs.count

		if filter.gameID != nil {
			if playerCount > 1 {
				self.title = "Filtered \(firstPlay.game.name) plays"
			} else if playerCount == 1 {
				let playerName = self.playerName(for: filter.playerIDs.first!, from: firstPlay)!
				self.title = "\(playerName)'s \(firstPlay.game.name) plays"
			} else {
				self.title = "\(firstPlay.game.name) plays"
			}
		} else {
			if playerCount > 1 {
				self.title = "Filtered plays"
			} else if playerCount == 1 {
				let playerName = self.playerName(for: filter.playerIDs.first!, from: firstPlay)!
				self.title = "\(playerName)'s plays"
			} else {
				self.title = "All plays"
			}
		}
	}
}
