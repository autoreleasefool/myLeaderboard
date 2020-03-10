//
//  GamePickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct GameListQueryable: PickerItemQueryable {
	typealias Query = MyLeaderboardAPI.GameListQuery
	typealias Response = MyLeaderboardAPI.GameListResponse

	func query(completion: @escaping (Query.ResponseResult) -> Void) {
		Query(first: 25, offset: 0).perform(callback: completion)
	}

	func pickerItems(from: Response) -> [Game] {
		from.games.compactMap { Game(from: $0?.asGameListItemFragment) }
	}
}

typealias GamePicker = BasePickerViewController<Game, GameListItemState, GameListQueryable>

class GamePickerViewController: GamePicker {
	init(multiSelect: Bool = true, limit: Int? = nil, initiallySelected: Set<GraphID>, completion: @escaping GamePicker.FinishedSelection) {
		let queryable = GameListQueryable()
		super.init(initiallySelected: initiallySelected, multiSelect: multiSelect, limit: limit, queryable: queryable, completion: completion)

		self.title = "Games"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func renderItems(_ items: [Game]) -> [PickerItem<GameListItemState>] {
		return items.map {
			return PickerItem(
				graphID: $0.graphID,
				state: GameListItemState(name: $0.name, image: $0.image)
			)
		}
	}
}
