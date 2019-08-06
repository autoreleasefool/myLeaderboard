//
//  PlayerListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol PlayerListActionable: AnyObject {
	func selectedPlayer(player: Player)
}

struct PlayerListBuilder {
	static func sections(players: [Player], actionable: PlayerListActionable) -> [TableSection] {
		let rows = players.map { player in
			PlayerCell(
				key: player.username,
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(player: player)
					return .deselected
				}),
				state: Cells.playerState(for: player),
				cellUpdater: { view, state in
					PlayerCellState.updateView(view, state: state)

					if state != nil {
						view.stackView.spacing = Metrics.Spacing.small
					} else {
						view.stackView.spacing = 0
					}
			}
			)
		}

		return [TableSection(key: "players", rows: rows)]
	}
}
