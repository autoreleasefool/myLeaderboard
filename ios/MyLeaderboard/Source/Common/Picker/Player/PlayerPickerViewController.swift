//
//  PlayerPickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct PlayerListQueryable: PickerItemQueryable {
	typealias Query = MyLeaderboardAPI.PlayerListQuery
	typealias Response = MyLeaderboardAPI.PlayerListResponse

	func query(completion: @escaping (Query.ResponseResult) -> Void) {
		Query(first: 25, offset: 0).perform(callback: completion)
	}

	func pickerItems(from: Response) -> [PlayerListItem] {
		from.players.compactMap { $0?.asPlayerListItemFragment }
	}
}

typealias PlayerPicker = BasePickerViewController<PlayerListItem, PlayerListItemState, PlayerListQueryable>

class PlayerPickerViewController: PlayerPicker {
	init(
		multiSelect: Bool = true,
		limit: Int? = nil,
		initiallySelected: Set<GraphID>,
		completion: @escaping PlayerPicker.FinishedSelection
	) {
		let queryable = PlayerListQueryable()
		super.init(
			initiallySelected: initiallySelected,
			multiSelect: multiSelect,
			limit: limit,
			queryable: queryable,
			completion: completion
		)

		self.title = "Players"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func renderItems(_ items: [PlayerListItem]) -> [PickerItem<PlayerListItemState>] {
		return items.map {
			return PickerItem(
				graphID: $0.graphID,
				state: PlayerListItemState(
					displayName: $0.displayName,
					username: $0.username,
					avatar: $0.qualifiedAvatar
				)
			)
		}
	}
}
