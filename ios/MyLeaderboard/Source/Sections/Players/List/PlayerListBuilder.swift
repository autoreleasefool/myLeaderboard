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
			PlayerListItemCell(
				key: "player-\(player.id)",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(player: player)
					return .deselected
				}),
				state: PlayerListItemState(displayName: player.displayName, username: player.username, avatar: player.qualifiedAvatar),
				cellUpdater: PlayerListItemState.updateView
			)
		}

		return [TableSection(key: "players", rows: rows)]
	}
}
