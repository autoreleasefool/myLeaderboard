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
				players.forEach { player in
					if let playerRecord = gameStandings.records[player.id] {
						spreadsheetCells.append([])
						players.forEach { opponent in
							if let recordAgainstOpponent = playerRecord.records[opponent.id] {
								spreadsheetCells[spreadsheetCells.endIndex - 1].append(Spreadsheet.TextGridCell(
									key: "\(player.id)-\(opponent.id)",
									state: LabelState(text: .plain("\(recordAgainstOpponent.wins)-\(recordAgainstOpponent.losses)-\(recordAgainstOpponent.ties)")),
									topBorder: nil,
									bottomBorder: nil,
									leftBorder: nil,
									rightBorder: nil
								))
							}
						}
					}
				}
			}

			let config = Spreadsheet.Config(rows: [:], columns: [:], cells: spreadsheetCells, in: tableData)
			if let spreadsheet = Spreadsheet.section(key: "Standings-\(game.id)", config: config) {
				rows.append(contentsOf: spreadsheet.rows)
			}

			sections.append(TableSection(key: "game-\(game.id)", rows: rows))
		}

		return sections
	}
}
