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

				var headerRow: [GridCellConfig] = [Cells.textGridCell(key: "Header", text: ""), Cells.textGridCell(key: "Total", text: "Total")]
				visiblePlayers.forEach { headerRow.append(Cells.playerCell(for: $0)) }
				spreadsheetCells.append(headerRow)

				visiblePlayers.forEach { player in
					if let playerRecord = gameStandings.records[player.id] {
						var cells: [GridCellConfig] = [
							Cells.playerCell(for: player),
							Cells.textGridCell(key: "Total", text: format(record: playerRecord.overallRecord), backgroundColor: backgroundColor(for: playerRecord.overallRecord))
						]

						visiblePlayers.forEach { opponent in
							guard opponent.id != player.id else {
								cells.append(Cells.textGridCell(key: "\(player.id)-\(opponent.id)", text: "—"))
								return
							}

							if let recordAgainstOpponent = playerRecord.records[opponent.id] {
								cells.append(Cells.textGridCell(key: "\(player.id)-\(opponent.id)", text: format(record: recordAgainstOpponent), backgroundColor: backgroundColor(for: recordAgainstOpponent)))
							} else {
								cells.append(Cells.textGridCell(key: "\(player.id)-\(opponent.id)", text: format(record: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil))))
							}
						}

						spreadsheetCells.append(cells)
					}
				}
			}

			let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
			let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
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

	static func backgroundColor(for record: Record) -> UIColor? {
		if record.isBest == true {
			return .bestRecord
		} else if record.isWorst == true {
			return .worstRecord
		} else {
			return nil
		}
	}

	static func visiblePlayers(from players: [Player], standings: Standings) -> [Player] {
		return players.filter { (standings.records[$0.id]?.isBanished ?? true) == false }
	}

	static func banishedPlayers(from players: [Player], standings: Standings) -> [Player] {
		let visiblePlayers = self.visiblePlayers(from: players, standings: standings)
		return players.filter { standings.records.keys.contains($0.id) && visiblePlayers.contains($0) }
	}

	private struct SpreadsheetConfigs {
		static func rows(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.RowConfig] {
			var rowConfigs: [Int: Spreadsheet.RowConfig] = [:]
			cells.enumerated().forEach { index, _ in
				if index == cells.endIndex - 1 {
					rowConfigs[index] = Spreadsheet.RowConfig(rowHeight: 48, topBorder: nil, bottomBorder: nil)
				} else {
					rowConfigs[index] = Spreadsheet.RowConfig(rowHeight: 48, topBorder: nil)
				}
			}
			return rowConfigs
		}

		static func columns(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.ColumnConfig] {
			var columnConfigs: [Int: Spreadsheet.ColumnConfig] = [:]
			cells.first?.enumerated().forEach { index, _ in
				if index == (cells.first?.endIndex ?? 0) - 1 {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: nil, rightBorder: nil)
				} else {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: nil)
				}
			}
			return columnConfigs
		}
	}

	private struct Cells {
		static func textGridCell(key: String, text: String, backgroundColor: UIColor? = nil) -> GridCellConfig {
			return Spreadsheet.TextGridCellConfig(
				key: key,
				state: LabelState(text: .attributed(NSAttributedString(string: text, textColor: .text)), alignment: .center),
				backgroundColor: backgroundColor,
				topBorder: nil,
				bottomBorder: nil,
				leftBorder: nil,
				rightBorder: nil
			)
		}

		static func playerCell(for player: Player) -> GridCellConfig {
			let imageSize: CGFloat = 32

			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(player.id)",
				state: ImageState(url: avatarURL, width: imageSize, height: imageSize, rounded: true),
				backgroundColor: nil,
				topBorder: nil,
				bottomBorder: nil,
				leftBorder: nil,
				rightBorder: nil
			)
		}
	}
}
