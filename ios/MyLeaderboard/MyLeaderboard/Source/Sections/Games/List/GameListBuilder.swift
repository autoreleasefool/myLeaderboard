//
//  GameListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol GameListActionable: AnyObject {
	func selectedGame(game: Game)
}

struct GameListBuilder {
	static func sections(games: [Game], actionable: GameListActionable) -> [TableSection] {
		let rows: [CellConfigType] = games.map { game in
			return GameListItemCell(
				key: "game-\(game.id)",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedGame(game: game)
					return .deselected
				}),
				state: GameListItemState(name: game.name, image: game.image),
				cellUpdater: GameListItemState.updateView
			)
		}

		return [TableSection(key: "games", rows: rows)]
	}
}
