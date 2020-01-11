//
//  PlaysListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum PlaysListAction: BaseAction {
	case dataChanged
	case apiError(LeaderboardAPIError)
}

enum PlaysListViewAction: BaseViewAction {
	case initialize
	case reload
}

class PlaysListViewModel: ViewModel {
	typealias ActionHandler = (_ action: PlaysListAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	let specifiedGameIDs: Set<ID>
	let specifiedPlayerIDs: Set<ID>

	private(set) var games: [Game] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var plays: [GamePlay] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var players: [Player] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(api: LeaderboardAPI, games: [Game] = [], players: [Player] = [], handleAction: @escaping ActionHandler) {
		self.api = api
		self.specifiedGameIDs = Set(games.map { $0.id })
		self.specifiedPlayerIDs = Set(players.map { $0.id })
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PlaysListViewAction) {
		switch viewAction {
		case .initialize:
			loadData()
		case .reload:
			reloadData()
		}
	}

	private func reloadData() {
		api.refresh { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success:
				self?.loadData()
			}
		}
	}

	private func loadData() {
		api.players { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players
			}
		}

		if specifiedPlayerIDs.count == 1 {
			api.games { [weak self] in
				switch $0 {
				case .failure(let error):
					self?.handleAction(.apiError(error))
				case .success(let games):
					self?.games = games
				}
			}
		}

		api.plays { [weak self] in
			guard let self = self else { return }
			switch $0 {
			case .failure(let error):
				self.handleAction(.apiError(error))
			case .success(let plays):
				self.plays = plays.filter {
					if self.specifiedGameIDs.count > 0, self.specifiedGameIDs.contains($0.game) == false {
						return false
					}

					if self.specifiedPlayerIDs.count > 0, self.specifiedPlayerIDs.intersection($0.players).count != self.specifiedPlayerIDs.count {
						return false
					}

					return true
				}.sorted().reversed()
			}
		}
	}
}
