//
//  GameListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum GameListAction: BaseAction {
	case gameSelected(Game)
}

enum GameListViewAction: BaseViewAction {
	case selectGame(Game)
}

struct GameListViewModel: ViewModel {
	typealias ActionHandler = (_ action: GameListAction) -> Void

	var handleAction: ActionHandler

	init(handleAction: @escaping ActionHandler) {
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: GameListViewAction) {
		switch viewAction {
		case .selectGame(let game): handleAction(.gameSelected(game))
		}
	}
}
