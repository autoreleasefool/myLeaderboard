//
//  CreateGameViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

enum CreateGameAction {
	case nameUpdated(String)
	case gameCreated(Game)
	case error(Error)
}

enum CreateGameViewAction {
	case initialize
	case updateName(String)
	case submit
}

class CreateGameViewModel {
	typealias ActionHandler = (_ action: CreateGameAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var gameName: String = "" {
		didSet {
			handleAction(.nameUpdated(gameName))
		}
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: CreateGameViewAction) {
		switch viewAction {
		case .initialize: break
		case .updateName(let name):
			self.gameName = name
		case .submit:
			createGame(withName: gameName)
		}
	}

	private func createGame(withName name: String) {
		api.createGame(withName: name) { [weak self] result in
			switch result {
			case .success(let game):
				self?.handleAction(.gameCreated(game))
			case .failure(let error):
				self?.handleAction(.error(error))
			}
		}
	}
}
