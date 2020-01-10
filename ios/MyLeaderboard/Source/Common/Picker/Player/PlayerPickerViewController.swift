//
//  PlayerPickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct PlayerListQueryable: PickerItemQueryable {
	func query(api: LeaderboardAPI, completion: @escaping (LeaderboardAPIResult<[Player]>) -> Void) {
		api.players(completion: completion)
	}
}

typealias PlayerPicker = BasePickerViewController<Player, PlayerListItemState, PlayerListQueryable>

class PlayerPickerViewController: PlayerPicker {
	init(api: LeaderboardAPI, multiSelect: Bool = true, initiallySelected: Set<ID>, completion: @escaping PlayerPicker.FinishedSelection) {
		let queryable = PlayerListQueryable()
		super.init(api: api, initiallySelected: initiallySelected, multiSelect: multiSelect, queryable: queryable, completion: completion)

		self.title = "Players"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func renderItems(_ items: [Player]) -> [PickerItem<PlayerListItemState>] {
		return items.map {
			return PickerItem(
				id: $0.id,
				state: PlayerListItemState(displayName: $0.displayName, username: $0.username, avatar: $0.avatar)
			)
		}
	}
}
