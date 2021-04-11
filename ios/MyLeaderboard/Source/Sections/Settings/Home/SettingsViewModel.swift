//
//  SettingsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi
import WidgetKit

enum SettingsAction: BaseAction {
	case playerUpdated
	case opponentsUpdated
	case openURL(URL)
	case openPlayerPicker
	case openLicenses
	case openContributors
	case updateInterfaceStyle
	case openOpponentPicker
	case openBoardChanger
}

enum SettingsViewAction: BaseViewAction {
	case initialize
	case editPlayer
	case selectPreferredPlayer(PlayerListItem?)
	case editOpponents
	case selectPreferredOpponents([PlayerListItem])
	case changeBoard
	case viewSource
	case viewLicenses
	case viewContributors
	case nextInterfaceStyle
}

class SettingsViewModel: ViewModel {
	typealias ActionHandler = (_ action: SettingsAction) -> Void

	let boardId: GraphID
	var handleAction: ActionHandler

	var currentBoard: BoardDetailsFragment? {
		Board.lastUsedBoard
	}

	var preferredPlayer: PlayerListItem? {
		Player.preferred
	}

	var preferredOpponents: [PlayerListItem] {
		Player.preferredOpponents
	}

	init(boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.boardId = boardId
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: SettingsViewAction) {
		switch viewAction {
		case .initialize:
			break
		case .changeBoard:
			handleAction(.openBoardChanger)
		case .editPlayer:
			handleAction(.openPlayerPicker)
		case .selectPreferredPlayer(let player):
			Player.preferred = player
			if #available(iOS 14.0, *) {
				WidgetCenter.shared.reloadAllTimelines()
			}
			handleAction(.playerUpdated)
		case .editOpponents:
			handleAction(.openOpponentPicker)
		case .selectPreferredOpponents(let opponents):
			Player.preferredOpponents = opponents.sorted(by: { left, right in left.id < right.id })
			handleAction(.opponentsUpdated)
		case .viewSource:
			viewSource()
		case .viewLicenses:
			handleAction(.openLicenses)
		case .viewContributors:
			handleAction(.openContributors)
		case .nextInterfaceStyle:
			handleAction(.updateInterfaceStyle)
		}
	}

	private func viewSource() {
		if let url = URL(string: "https://github.com/autoreleasefool/myLeaderboard") {
			handleAction(.openURL(url))
		}
	}
}
