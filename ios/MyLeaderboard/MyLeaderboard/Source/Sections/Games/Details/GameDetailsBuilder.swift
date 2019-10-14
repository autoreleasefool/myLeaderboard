//
//  GameDetailsBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol GameDetailsActionable: AnyObject {
	func selectedPlayer(player: Player)
	func showPlays(players: [Player])
}

struct GameDetailsBuilder {
	private static let avatarImageSize: CGFloat = 32
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter
	}()

	static func sections(game: Game, plays: [GamePlay], players: [Player], standings: Standings?, builder: SpreadsheetBuilder, actionable: GameDetailsActionable) -> [TableSection] {
		let visiblePlayers = players.filter { standings?.records[$0.id] != nil }

		return [
			scoreSection(standings: standings),
			playsSection(players: visiblePlayers, plays: plays, actionable: actionable),
			standingsSection(players: visiblePlayers, standings: standings, builder: builder, actionable: actionable),
		]
	}

	static func scoreSection(standings: Standings?) -> TableSection {
		var rows: [CellConfigType] = []
		if let score = standings?.scoreStats {
			rows.append(Cells.sectionHeader(key: "Header", title: "Score Statistics"))
			rows.append(ScoreCell(
				key: "Scores",
				state: ScoreCellState(bestScore: score.best, worstScore: score.worst, averageScore: score.average),
				cellUpdater: ScoreCellState.updateView
			))
		}

		return TableSection(key: "Scores", rows: rows)
	}

	static func playsSection(players: [Player], plays: [GamePlay], actionable: GameDetailsActionable) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "MostRecent", title: "Most Recent Plays", action: "View All") { [weak actionable] in
				actionable?.showPlays(players: [])
			},
		]

		var lastDatePlayed: Date?
		plays.prefix(3).forEach {
			if let playCell = Cells.playCell(for: $0, players: players, actionable: actionable) {
				if let date = $0.playedOnDay, date != lastDatePlayed {
					rows.append(Cells.dateCell(for: date))
					lastDatePlayed = date
				}
				rows.append(playCell)
			}
		}

		if rows.count == 1 {
			rows.append(Cells.loadingCell())
		}

		return TableSection(key: "Plays", rows: rows)
	}

	static func standingsSection(players: [Player], standings: Standings?, builder: SpreadsheetBuilder, actionable: GameDetailsActionable) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "Standings", title: "Standings"),
		]
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(players: players, actionable: actionable))

		if let standings = standings {
			players.forEach {
				spreadsheetCells.append(SpreadsheetCells.spreadsheetRow(player: $0, opponents: players, record: standings.records[$0.id]!, actionable: actionable))
			}
		}

		let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
		let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
		let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil)

		if spreadsheetCells.count > 1, let spreadsheet = Spreadsheet.section(key: "GameStandings", builder: builder, config: config) {
			rows.append(contentsOf: spreadsheet.rows)
		} else {
			rows.append(Cells.loadingCell())
		}

		return TableSection(key: "Standings", rows: rows)
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

		static func playCell(for play: GamePlay, players: [Player], actionable: GameDetailsActionable) -> CellConfigType? {
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }) else { return nil }

			return GamePlayCell(
				key: "Play-\(play.id)",
				state: GamePlayState(firstPlayer: firstPlayer, secondPlayer: secondPlayer, winners: play.winners, scores: play.scores),
				cellUpdater: GamePlayState.updateView
			)
		}

		static func dateCell(for date: Date) -> CellConfigType {
			let dateString = GameDetailsBuilder.dateFormatter.string(from: date)
			return LabelCell(
				key: "Date-\(dateString)",
				state: LabelState(text: .attributed(NSAttributedString(string: dateString, textColor: .textSecondary)), size: Metrics.Text.caption),
				cellUpdater: LabelState.updateView
			)
		}

		static func loadingCell() -> CellConfigType {
			return LabelCell(
				key: "NoData",
				state: LabelState(text: .attributed(NSAttributedString(string: "Waiting for data", textColor: .textSecondary)), size: Metrics.Text.body),
				cellUpdater: LabelState.updateView
			)
		}
	}

	private struct SpreadsheetCells {
		static func headerRow(players: [Player], actionable: GameDetailsActionable) -> [GridCellConfig] {
			var headerRow: [GridCellConfig] = [
				textGridCell(key: "Header", text: ""),
				textGridCell(key: "Total", text: "Total"),
			]

			players.forEach {
				headerRow.append(playerCell(for: $0, actionable: actionable))
			}

			return headerRow
		}

		static func spreadsheetRow(player: Player, opponents: [Player], record: PlayerRecord, actionable: GameDetailsActionable) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				playerCell(for: player, actionable: actionable),
				textGridCell(key: "Total", text: record.overallRecord.formatted, backgroundColor: record.overallRecord.backgroundColor) { [weak actionable] in
					actionable?.showPlays(players: [player])
				},
			]

			opponents.forEach { opponent in
				guard player.id != opponent.id else {
					row.append(textGridCell(key: "\(player.id)-\(player.id)", text: "—"))
					return
				}

				if let recordAgainstOpponent = record.records[opponent.id] {
					row.append(textGridCell(key: "\(player.id)-\(opponent.id)", text: recordAgainstOpponent.formatted, backgroundColor: recordAgainstOpponent.backgroundColor) { [weak actionable] in
						actionable?.showPlays(players: [player, opponent])
					})
				} else {
					row.append(textGridCell(key: "\(player.id)-\(opponent.id)", text: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil).formatted))
				}
			}

			return row
		}

		static func textGridCell(key: String, text: String, backgroundColor: UIColor? = nil, onAction: (() -> Void)? = nil) -> GridCellConfig {
			return Spreadsheet.TextGridCellConfig(
				key: key,
				style: CellStyle(selectionColor: .primaryExtraLight),
				actions: CellActions(
					canSelectAction: { callback in
						callback(onAction != nil)
					},
					selectionAction: { _ in
						onAction?()
						return .deselected
					}
				),
				state: LabelState(text: .attributed(NSAttributedString(string: text, textColor: .text)), alignment: .center),
				backgroundColor: backgroundColor
			)
		}

		static func playerCell(for player: Player, actionable: GameDetailsActionable) -> GridCellConfig {
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
				state: ImageState(url: avatarURL, width: GameDetailsBuilder.avatarImageSize, height: GameDetailsBuilder.avatarImageSize, rounded: true)
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
