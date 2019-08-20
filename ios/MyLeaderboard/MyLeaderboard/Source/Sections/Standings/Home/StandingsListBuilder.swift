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
	static func sections(standings: [Game: Standings?], players: [Player], tableData: FunctionalTableData, actionable: StandingsListActionable) -> [TableSection] {
		var sections: [TableSection] = []

		standings.keys.sorted().forEach { game in
			var rows: [CellConfigType] = []

			rows.append(GameListItemCell(
				key: "Header",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedGame(game: game)
					return .deselected
				}),
				state: GameListItemState(name: game.name, image: game.image),
				cellUpdater: GameListItemState.updateView
			))

			var spreadsheetCells: [[GridCellConfig]] = []
			if let optionalGameStandings = standings[game], let gameStandings = optionalGameStandings {
				let visiblePlayers = self.visiblePlayers(from: players, standings: gameStandings)

				visiblePlayers.forEach { player in
					if let playerRecord = gameStandings.records[player.id] {
						var cells: [GridCellConfig] = []

						visiblePlayers.forEach { opponent in
							guard opponent.id != player.id else {
								cells.append(textGridCell(key: "\(player.id)-\(opponent.id)", text: "—"))
								return
							}

							if let recordAgainstOpponent = playerRecord.records[opponent.id] {
								cells.append(textGridCell(key: "\(player.id)-\(opponent.id)", text: format(record: recordAgainstOpponent)))
							} else {
								cells.append(textGridCell(key: "\(player.id)-\(opponent.id)", text: format(record: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil))))
							}
						}

						spreadsheetCells.append(cells)
					}
				}
			}

			var rowConfigs: [Int: Spreadsheet.RowConfig] = [:]
			spreadsheetCells.enumerated().forEach { index, _ in
				if index == spreadsheetCells.endIndex - 1 {
					rowConfigs[index] = Spreadsheet.RowConfig(rowHeight: 48, topBorder: nil, bottomBorder: nil)
				} else {
					rowConfigs[index] = Spreadsheet.RowConfig(rowHeight: 48, topBorder: nil)
				}
			}

			var columnConfigs: [Int: Spreadsheet.ColumnConfig] = [:]
			spreadsheetCells.first?.enumerated().forEach { index, _ in
				if index == (spreadsheetCells.first?.endIndex ?? 0) - 1 {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: nil, rightBorder: nil)
				} else {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: nil)
				}
			}

			let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, in: tableData)
			if let spreadsheet = Spreadsheet.section(key: "Standings-\(game.id)", config: config) {
				rows.append(contentsOf: spreadsheet.rows)
			}

			sections.append(TableSection(key: "game-\(game.id)", rows: rows))
		}

		return sections
	}

	static func format(record: Record) -> String {
		return "\(record.wins) - \(record.losses)\(record.ties > 0 ? " - \(record.ties)" : "")"
	}

	static func textGridCell(key: String, text: String) -> GridCellConfig {
		return Spreadsheet.TextGridCellConfig(
			key: key,
			state: LabelState(text: .attributed(NSAttributedString(string: text, textColor: .text)), alignment: .center),
			topBorder: nil,
			bottomBorder: nil,
			leftBorder: nil,
			rightBorder: nil
		)
	}

	static func visiblePlayers(from players: [Player], standings: Standings) -> [Player] {
		return players.filter { (standings.records[$0.id]?.isBanished ?? true) == false }
	}
}
