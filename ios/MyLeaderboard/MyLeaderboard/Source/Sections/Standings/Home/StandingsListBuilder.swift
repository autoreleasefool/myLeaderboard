//
//  StandingsListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol StandingsListActionable: AnyObject {
	func selectedPlayer(player: Player)
	func selectedGame(game: Game)
}

struct StandingsListBuilder {
	private static let avatarImageSize: CGFloat = 32

	static func sections(standings: [Game: Standings?], players: [Player], tableData: FunctionalTableData, actionable: StandingsListActionable) -> [TableSection] {
		var sections: [TableSection] = []

		standings.keys.sorted().forEach { game in
			var rows: [CellConfigType] = [
				Cells.gameHeader(for: game, actionable: actionable),
			]

			var spreadsheetCells: [[GridCellConfig]] = []
			if let optionalGameStandings = standings[game], let gameStandings = optionalGameStandings {
				spreadsheetCells = standingsRows(from: gameStandings, players: players, actionable: actionable)
			}

			let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
			let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
			let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil, in: tableData)

			if let spreadsheet = Spreadsheet.section(key: "Standings-\(game.id)", config: config) {
				rows.append(contentsOf: spreadsheet.rows)
			}

			sections.append(TableSection(key: "game-\(game.id)", rows: rows))

			if let optionalGameStandings = standings[game], let gameStandings = optionalGameStandings {
				if let limbo = limboSection(forGame: game, players: Players.limboing(from: players, standings: gameStandings), actionable: actionable) {
					sections.append(limbo)
				}
				if let banished = banishedSection(forGame: game, players: Players.banished(from: players, standings: gameStandings), actionable: actionable) {
					sections.append(banished)
				}
			}
		}

		return sections
	}

	private static func standingsRows(from gameStandings: Standings, players: [Player], actionable: StandingsListActionable) -> [[GridCellConfig]] {
		var spreadsheetCells: [[GridCellConfig]] = []
		let visiblePlayers = Players.visible(from: players, standings: gameStandings)

		var headerRow: [GridCellConfig] = [
			SpreadsheetCells.textGridCell(key: "Header", text: ""),
			SpreadsheetCells.textGridCell(key: "Total", text: "Total"),
		]
		visiblePlayers.forEach {
			headerRow.append(SpreadsheetCells.playerCell(for: $0, record: gameStandings.records[$0.id], actionable: actionable))
		}
		spreadsheetCells.append(headerRow)

		visiblePlayers.forEach { player in
			if let playerRecord = gameStandings.records[player.id] {
				var cells: [GridCellConfig] = [
					SpreadsheetCells.playerCell(for: player, record: gameStandings.records[player.id], actionable: actionable),
					SpreadsheetCells.textGridCell(key: "Total", text: playerRecord.overallRecord.formatted, backgroundColor: playerRecord.overallRecord.backgroundColor)
				]

				visiblePlayers.forEach { opponent in
					guard opponent.id != player.id else {
						cells.append(SpreadsheetCells.textGridCell(key: "\(player.id)-\(opponent.id)", text: "—"))
						return
					}

					if let recordAgainstOpponent = playerRecord.records[opponent.id] {
						cells.append(SpreadsheetCells.textGridCell(key: "\(player.id)-\(opponent.id)", text: recordAgainstOpponent.formatted, backgroundColor: recordAgainstOpponent.backgroundColor))
					} else {
						cells.append(SpreadsheetCells.textGridCell(key: "\(player.id)-\(opponent.id)", text: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil).formatted))
					}
				}

				spreadsheetCells.append(cells)
			}
		}

		return spreadsheetCells
	}

	private static func limboSection(forGame game: Game, players: [Player], actionable: StandingsListActionable) -> TableSection? {
		guard players.count > 0 else { return nil }

		var rows: [CellConfigType] = [
			Cells.subHeader(key: "LimboHeader-\(game.id)", text: "Limbo")
		]

		let limboingPlayerRows: [CellConfigType] = players.map { Cells.playerAvatar(for: $0, actionable: actionable) }

		rows.append(CollectionViewCell(
			key: "Limbo",
			state: CollectionViewCellState(
				sections: [TableSection(key: "Limbo", rows: limboingPlayerRows)],
				itemSize: CGSize(width: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard, height: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard)
			),
			cellUpdater: CollectionViewCellState.updateView
		))

		return TableSection(key: "Limbo-\(game.id)", rows: rows)
	}

	private static func banishedSection(forGame game: Game, players: [Player], actionable: StandingsListActionable) -> TableSection? {
		guard players.count > 0 else { return nil }

		var rows: [CellConfigType] = [
			Cells.subHeader(key: "BanishedHeader-\(game.id)", text: "Shadow Realm")
		]

		let banishedPlayerRows: [CellConfigType] = players.map { Cells.playerAvatar(for: $0, actionable: actionable) }

		rows.append(CollectionViewCell(
			key: "Banished",
			state: CollectionViewCellState(
				sections: [TableSection(key: "Banished", rows: banishedPlayerRows)],
				itemSize: CGSize(width: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard, height: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard)
			),
			cellUpdater: CollectionViewCellState.updateView
		))

		return TableSection(key: "Banished-\(game.id)", rows: rows)
	}

	private struct Players {
		static func visible(from players: [Player], standings: Standings) -> [Player] {
			return players.filter { (standings.records[$0.id]?.isBanished ?? true) == false }
		}

		static func banished(from players: [Player], standings: Standings) -> [Player] {
			return players.filter { standings.records[$0.id]?.isBanished == true }
		}

		static func limboing(from players: [Player], standings: Standings) -> [Player] {
			return players.filter {
				guard let freshness = standings.records[$0.id]?.freshness else { return false }
				return freshness > 0 && freshness < 0.2
			}
		}
	}

	private struct SpreadsheetConfigs {
		static func rows(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.RowConfig] {
			var rowConfigs: [Int: Spreadsheet.RowConfig] = [:]
			cells.enumerated().forEach { index, _ in
				if index == 0 {
					rowConfigs[index] = Spreadsheet.CommonRowConfig(rowHeight: 48, topBorder: Spreadsheet.BorderConfig(color: .standingsBorder), bottomBorder: Spreadsheet.BorderConfig(color: .standingsBorder))
				} else {
					rowConfigs[index] = Spreadsheet.CommonRowConfig(rowHeight: 48, topBorder: nil, bottomBorder: Spreadsheet.BorderConfig(color: .standingsBorder))
				}
			}
			return rowConfigs
		}

		static func columns(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.ColumnConfig] {
			var columnConfigs: [Int: Spreadsheet.ColumnConfig] = [:]
			cells.first?.enumerated().forEach { index, _ in
				if index == 0 {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: Spreadsheet.BorderConfig(color: .standingsBorder), rightBorder: Spreadsheet.BorderConfig(color: .standingsBorder))
				} else {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: nil, rightBorder: Spreadsheet.BorderConfig(color: .standingsBorder))
				}
			}
			return columnConfigs
		}
	}

	private struct Cells {
		static func subHeader(key: String, text: String) -> CellConfigType {
			return LabelCell(
				key: key,
				state: LabelState(text: .attributed(NSAttributedString(string: text, textColor: .textSecondary)), size: Metrics.Text.title),
				cellUpdater: LabelState.updateView
			)
		}

		static func gameHeader(for game: Game, actionable: StandingsListActionable) -> CellConfigType {
			return GameListItemCell(
				key: "Header",
				style: CellStyle(highlight: true, backgroundColor: .primaryLight),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedGame(game: game)
					return .deselected
				}),
				state: GameListItemState(name: game.name, image: game.image),
				cellUpdater: GameListItemState.updateView
			)
		}

		static func playerAvatar(for player: Player, actionable: StandingsListActionable) -> CellConfigType {
			return ImageCell(
				key: "player-\(player.id)",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(player: player)
					return .deselected
				}),
				state: playerAvatarState(for: player),
				cellUpdater: ImageState.updateImageView
			)
		}

		static func playerAvatarState(for player: Player, opacity: CGFloat = 1.0) -> ImageState {
			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return ImageState(url: avatarURL, width: StandingsListBuilder.avatarImageSize, height: StandingsListBuilder.avatarImageSize, rounded: true, opacity: opacity)
		}
	}

	private struct SpreadsheetCells {
		static func textGridCell(key: String, text: String, backgroundColor: UIColor? = nil) -> GridCellConfig {
			return Spreadsheet.TextGridCellConfig(
				key: key,
				actions: CellActions(),
				state: LabelState(text: .attributed(NSAttributedString(string: text, textColor: .text)), alignment: .center),
				backgroundColor: backgroundColor,
				topBorder: nil,
				bottomBorder: nil,
				leftBorder: nil,
				rightBorder: nil
			)
		}

		static func playerCell(for player: Player, record: PlayerRecord?, actionable: StandingsListActionable) -> GridCellConfig {
			let opacity = CGFloat(record?.freshness ?? 1)

			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(player.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(player: player)
					return .deselected
				}),
				state: Cells.playerAvatarState(for: player, opacity: opacity),
				backgroundColor: nil,
				topBorder: nil,
				bottomBorder: nil,
				leftBorder: nil,
				rightBorder: nil
			)
		}
	}
}
