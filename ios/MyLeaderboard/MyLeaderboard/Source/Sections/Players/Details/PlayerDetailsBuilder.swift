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
	private static let avatarImageSize: CGFloat = 32

	static func sections(player: Player, records: [Game: PlayerStandings?], players: [Player], plays: [GamePlay], tableData: FunctionalTableData, actionable: PlayerDetailsActionable) -> [TableSection] {
		let visiblePlayers = players.filter { player in
			return records.first(where: { $0.value?.records[player.id] != nil }) != nil
		}

		return [
			profileSection(player: player),
			recordsSection(player: player, records: records, players: visiblePlayers, tableData: tableData, actionable: actionable),
			playsSection(games: records.keys.sorted(), players: players, plays: plays, actionable: actionable),
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

	private static func recordsSection(player: Player, records: [Game: PlayerStandings?], players: [Player], tableData: FunctionalTableData, actionable: PlayerDetailsActionable) -> TableSection {
		var rows: [CellConfigType] = []
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(players: players, actionable: actionable))

		records.keys.sorted().forEach {
			if let optionalPlayerStandings = records[$0], let playerStandings = optionalPlayerStandings {
				spreadsheetCells.append(SpreadsheetCells.gameRow(game: $0, players: players, record: playerStandings, actionable: actionable))
			}
		}

		let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
		let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
		let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil, in: tableData)

		if let spreadsheet = Spreadsheet.section(key: "Records", config: config) {
			rows.append(contentsOf: spreadsheet.rows)
		}

		return TableSection(key: "Records", rows: rows)
	}

	private static func playsSection(games: [Game], players: [Player], plays: [GamePlay], actionable: PlayerDetailsActionable) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "MostRecentPlays", title: "Most Recent Plays", action: "View All") { [weak actionable] in
				actionable?.showAllPlays()
			}
		]

		plays.prefix(3).forEach {
			if let playCell = Cells.playCell(for: $0, players: players, actionable: actionable) {
				rows.append(playCell)
			}
		}

		return TableSection(key: "Plays", rows: rows)
	}

	private struct Cells {
		static func sectionHeader(key: String, title: String, action: String? = nil, onAction: (() -> Void)? = nil) -> CellConfigType {
			let titleState = LabelState(text: .attributed(NSAttributedString(string: title, textColor: .text)), size: Metrics.Text.title)

			if let action = action, let onAction = onAction {
				let actionState = LabelState(text: .attributed(NSAttributedString(string: action, textColor: .textSecondary)), size: Metrics.Text.caption)

				return CombinedCell<UILabel, LabelState, UILabel, LabelState, LayoutMarginsTableItemLayout>(
					key: key,
					style: CellStyle(highlight: true, backgroundColor: .primaryLight),
					actions: CellActions(selectionAction: { _ in
						onAction()
						return .deselected
					}),
					state: CombinedState(state1: titleState, state2: actionState),
					cellUpdater: { view, state in
						if state == nil {
							view.stackView.alignment = .center
							view.view2.textAlignment = .natural
						} else {
							view.stackView.alignment = .firstBaseline
							view.view2.textAlignment = .right
						}
						CombinedState<LabelState, LabelState>.updateView(view, state: state)
				}
				)
			} else {
				return LabelCell(
					key: key,
					style: CellStyle(backgroundColor: .primaryLight),
					state: titleState,
					cellUpdater: LabelState.updateView
				)
			}
		}

		static func playCell(for play: GamePlay, players: [Player], actionable: PlayerDetailsActionable) -> CellConfigType? {
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }) else { return nil }

			return GamePlayCell(
				key: "Play-\(play.id)",
				state: GamePlayState(firstPlayer: firstPlayer, secondPlayer: secondPlayer, winners: play.winners),
				cellUpdater: GamePlayState.updateView
			)
		}
	}

	private struct SpreadsheetCells {
		static func headerRow(players: [Player], actionable: PlayerDetailsActionable) -> [GridCellConfig] {
			var headerRow: [GridCellConfig] = [
				textGridCell(key: "Header", text: ""),
				textGridCell(key: "Total", text: "Total"),
			]

			players.forEach {
				headerRow.append(playerCell(for: $0, actionable: actionable))
			}

			return headerRow
		}

		static func gameRow(game: Game, players: [Player], record: PlayerStandings, actionable: PlayerDetailsActionable) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				gameCell(for: game, actionable: actionable),
				textGridCell(key: "Total", text: record.overallRecord.formatted, backgroundColor: record.overallRecord.backgroundColor),
			]

			players.forEach { opponent in
				if let recordAgainstOpponent = record.records[opponent.id] {
					row.append(textGridCell(key: "Opponent-\(opponent.id)", text: recordAgainstOpponent.formatted, backgroundColor: recordAgainstOpponent.backgroundColor))
				} else {
					row.append(textGridCell(key: "Opponent-\(opponent.id)", text: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil).formatted))
				}
			}

			return row
		}

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

		static func playerCell(for player: Player, actionable: PlayerDetailsActionable) -> GridCellConfig {
			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(player.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(player: player)
					return .deselected
				}),
				state: ImageState(url: avatarURL, width: PlayerDetailsBuilder.avatarImageSize, height: PlayerDetailsBuilder.avatarImageSize, rounded: true),
				backgroundColor: nil,
				topBorder: nil,
				bottomBorder: nil,
				leftBorder: nil,
				rightBorder: nil
			)
		}

		static func gameCell(for game: Game, actionable: PlayerDetailsActionable) -> GridCellConfig {
			let imageURL: URL?
			if let image = game.image {
				imageURL = URL(string: image)
			} else {
				imageURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Game-\(game.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedGame(game: game)
					return .deselected
				}),
				state: ImageState(url: imageURL, width: PlayerDetailsBuilder.avatarImageSize, height: PlayerDetailsBuilder.avatarImageSize, rounded: false),
				backgroundColor: nil,
				topBorder: nil,
				bottomBorder: nil,
				leftBorder: nil,
				rightBorder: nil
			)
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
}
