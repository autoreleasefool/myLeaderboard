//
//  StandingsListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol StandingsListActionable: AnyObject {
	func selectedGame(game: Game)
}

struct StandingsListBuilder {
	static func sections(standings: [Game: Standings?], actionable: StandingsListActionable) -> [TableSection] {
		let rows: [CellConfigType] = standings.keys.sorted(by: { $0.id < $1.id }).map { game in
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

		return [TableSection(key: "Standings", rows: rows)]
	}
}
