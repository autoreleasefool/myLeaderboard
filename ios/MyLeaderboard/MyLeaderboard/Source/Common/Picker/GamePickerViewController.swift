//
//  GamePickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct GameListQueryable: PickerItemQueryable {
	func query(api: LeaderboardAPI, completion: @escaping (LeaderboardAPIResult<[Game]>) -> Void) {
		api.games(completion: completion)
	}
}

typealias GamePicker = BasePickerViewController<Game, GameListItemState, GameListQueryable>

class GamePickerViewController: GamePicker {
	init(api: LeaderboardAPI, multiSelect: Bool = true, initiallySelected: Set<ID>, completion: @escaping GamePicker.FinishedSelection) {
		let queryable = GameListQueryable()
		super.init(api: api, initiallySelected: initiallySelected, multiSelect: multiSelect, queryable: queryable, completion: completion)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func renderItems(_ items: [Game]) -> [PickerItem<GameListItemState>] {
		return items.map {
			return PickerItem(
				id: $0.id,
				state: GameListItemState(name: $0.name, image: $0.image)
			)
		}
	}
}
