//
//  GamePickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import Maple
import myLeaderboardApi

struct GameListQueryable: PickerItemQueryable {
	typealias Query = MyLeaderboardApi.GameListQuery
	typealias Response = MyLeaderboardApi.GameListResponse

	func query(
		pageSize: Int,
		offset: Int
	) -> AnyPublisher<Maple.Result<Query.Response>, GraphError<MyLeaderboardAPIError>> {
		MLApi.shared.fetch(query: Query(first: pageSize, offset: offset))
	}

	func pickerItems(from: Response) -> [GameListItem] {
		from.games.compactMap { $0.asGameListItemFragment }
	}
}

typealias GamePicker = BasePickerViewController<GameListItem, GameListItemState, GameListQueryable>

class GamePickerViewController: GamePicker {
	init(
		multiSelect: Bool = true,
		limit: Int? = nil,
		initiallySelected: Set<GraphID>,
		completion: @escaping GamePicker.FinishedSelection
	) {
		let queryable = GameListQueryable()
		super.init(
			initiallySelected: initiallySelected,
			multiSelect: multiSelect,
			limit: limit,
			queryable: queryable,
			completion: completion
		)

		self.title = "Games"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func renderItems(_ items: [GameListItem]) -> [PickerItem<GameListItemState>] {
		return items.map {
			return PickerItem(
				graphID: $0.graphID,
				state: GameListItemState(name: $0.name, image: $0.image)
			)
		}
	}
}
