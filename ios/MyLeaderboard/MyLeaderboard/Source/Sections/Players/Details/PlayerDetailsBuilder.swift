//
//  PlayerDetailsBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol PlayerDetailsActionable: AnyObject {
	func selectedGame(game: Game)
	func selectedPlayer(player: Player)
	func showAllPlays()
}

struct PlayerDetailsBuilder {
	static func sections(player: Player, records: [Game: PlayerStandings?], players: [Player], plays: [GamePlay], actionable: PlayerDetailsActionable) -> [TableSection] {
		return [
			profileSection(player: player),
			recordsSection(player: player, records: records, players: players, actionable: actionable),
			playsSection(games: Array(records.keys), players: players, plays: plays, actionable: actionable),
		]
	}

	private static func profileSection(player: Player) -> TableSection {
		let avatarURL: URL?
		if let avatar = player.avatar {
			avatarURL = URL(string: avatar)
		} else {
			avatarURL = nil
		}

		let rows: [CellConfigType] = [
			ImageCell(
				key: "Avatar",
				state: ImageState(url: avatarURL, width: Metrics.Image.large, height: Metrics.Image.large, rounded: true),
				cellUpdater: ImageState.updateImageView
			),
		]

		return TableSection(key: "Profile", rows: rows)
	}

	private static func recordsSection(player: Player, records: [Game: PlayerStandings?], players: [Player], actionable: PlayerDetailsActionable) -> TableSection {
		return TableSection(key: "Records")
	}

	private static func playsSection(games: [Game], players: [Player], plays: [GamePlay], actionable: PlayerDetailsActionable) -> TableSection {
		return TableSection(key: "Plays")
	}

//	static func sections(players: [Player], actionable: PlayerListActionable) -> [TableSection] {
//		let rows = players.map { player in
//			PlayerListItemCell(
//				key: "player-\(player.id)",
//				style: CellStyle(highlight: true),
//				actions: CellActions(selectionAction: { [weak actionable] _ in
//					actionable?.selectedPlayer(player: player)
//					return .deselected
//				}),
//				state: PlayerListItemState(displayName: player.displayName, username: player.username, avatar: player.avatar),
//				cellUpdater: PlayerListItemState.updateView
//			)
//		}
//
//		return [TableSection(key: "players", rows: rows)]
//	}
}
