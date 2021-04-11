//
//  PlayerPickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

struct PlayerListQueryable: PickerItemQueryable {
	typealias Query = MyLeaderboardApi.PlayerListQuery
	typealias Response = MyLeaderboardApi.PlayerListResponse

	private let boardId: GraphID

	init(boardId: GraphID) {
		self.boardId = boardId
	}

	func query(pageSize: Int, offset: Int, completion: @escaping (Query.ResponseResult) -> Void) {
		Query(board: boardId, first: pageSize, offset: offset).perform(callback: completion)
	}

	func pickerItems(from: Response) -> [PlayerListItem] {
		from.players.compactMap { $0.asPlayerListItemFragment }
	}
}

typealias PlayerPicker = BasePickerViewController<PlayerListItem, PlayerListItemState, PlayerListQueryable>

class PlayerPickerViewController: PlayerPicker {
	init(
		boardId: GraphID,
		multiSelect: Bool = true,
		limit: Int? = nil,
		initiallySelected: Set<GraphID>,
		completion: @escaping PlayerPicker.FinishedSelection
	) {
		let queryable = PlayerListQueryable(boardId: boardId)
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
