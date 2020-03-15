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
	func selectedPlayer(playerID: GraphID)
	func showPlayerPlays(playerIDs: [GraphID])
}

struct GameDetailsBuilder {
	private static let avatarImageSize: CGFloat = 32
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter
	}()

	static func sections(
		game: GameDetails,
		players: [Opponent],
		standings: GameDetailsStandings,
		recentPlays: [RecentPlay],
		builder: SpreadsheetBuilder,
		actionable: GameDetailsActionable
	) -> [TableSection] {
		return [
			scoreSection(standings: standings),
			playsSection(players: players, recentPlays: recentPlays, actionable: actionable),
			standingsSection(players: players, standings: standings, builder: builder, actionable: actionable),
		]
	}

	static func scoreSection(standings: GameDetailsStandings) -> TableSection {
		var rows: [CellConfigType] = []
		if let score = standings.scoreStats {
			rows.append(Cells.sectionHeader(key: "Header", title: "Score Statistics"))
			rows.append(ScoreCell(
				key: "Scores",
				state: ScoreCellState(bestScore: score.best, worstScore: score.worst, averageScore: score.average),
				cellUpdater: ScoreCellState.updateView
			))
		}

		return TableSection(key: "Scores", rows: rows)
	}

	static func playsSection(
		players: [Opponent],
		recentPlays: [RecentPlay],
		actionable: GameDetailsActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(
				key: "MostRecent",
				title: "Most Recent Plays",
				action: "View All"
			) { [weak actionable] in
				actionable?.showPlayerPlays(playerIDs: [])
			},
		]

		var lastDatePlayed: Date?
		recentPlays.forEach {
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

	static func standingsSection(
		players: [Opponent],
		standings: GameDetailsStandings,
		builder: SpreadsheetBuilder,
		actionable: GameDetailsActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "Standings", title: "Standings"),
		]
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(players: players, actionable: actionable))

		standings.records.forEach {
			spreadsheetCells.append(SpreadsheetCells.spreadsheetRow(
				player: $0.player.asOpponentFragmentFragment,
				opponents: players,
				record: $0.record.asGameDetailsPlayerRecordFragmentFragment,
				actionable: actionable
			))
		}

		let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
		let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
		let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil)

		if spreadsheetCells.count > 1,
			let spreadsheet = Spreadsheet.section(key: "GameStandings", builder: builder, config: config) {
			rows.append(contentsOf: spreadsheet.rows)
		} else {
			rows.append(Cells.loadingCell())
		}

		return TableSection(key: "Standings", rows: rows)
	}

	private struct Cells {
		static func sectionHeader(
			key: String,
			title: String,
			action: String? = nil,
			onAction: (() -> Void)? = nil
		) -> CellConfigType {
			let titleState = LabelState(
				text: .attributed(NSAttributedString(string: title, textColor: .text)),
				size: Metrics.Text.title
			)

			if let action = action, let onAction = onAction {
				let actionState = LabelState(
					text: .attributed(NSAttributedString(string: action, textColor: .textSecondary)),
					size: Metrics.Text.caption
				)

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

		static func playCell(
			for play: RecentPlay,
			players: [Opponent],
			actionable: GameDetailsActionable
		) -> CellConfigType? {
			guard let firstPlayer = players.first(where: { $0.id == play.players[0].id }),
				let secondPlayer = players.first(where: { $0.id == play.players[1].id }) else { return nil }

			return GamePlayCell(
				key: "Play-\(play.id)",
				state: GamePlayState(
					firstPlayerID: firstPlayer.id,
					firstPlayerAvatar: Avatar(from: firstPlayer.avatar),
					secondPlayerAvatar: Avatar(from: secondPlayer.avatar),
					winners: play.winners.map { $0.id },
					scores: play.scores
				),
				cellUpdater: GamePlayState.updateView
			)
		}

		static func dateCell(for date: Date) -> CellConfigType {
			let dateString = GameDetailsBuilder.dateFormatter.string(from: date)
			return LabelCell(
				key: "Date-\(dateString)",
				state: LabelState(
					text: .attributed(NSAttributedString(string: dateString, textColor: .textSecondary)),
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			)
		}

		static func loadingCell() -> CellConfigType {
			return LabelCell(
				key: "NoData",
				state: LabelState(
					text: .attributed(NSAttributedString(string: "Waiting for data", textColor: .textSecondary)),
					size: Metrics.Text.body
				),
				cellUpdater: LabelState.updateView
			)
		}
	}

	private struct SpreadsheetCells {
		static func headerRow(players: [Opponent], actionable: GameDetailsActionable) -> [GridCellConfig] {
			var headerRow: [GridCellConfig] = [
				textGridCell(key: "Header", text: ""),
				textGridCell(key: "Total", text: "Total"),
			]

			players.forEach {
				headerRow.append(playerCell(for: $0, actionable: actionable))
			}

			return headerRow
		}

		static func spreadsheetRow(
			player: Opponent,
			opponents: [Opponent],
			record: GameDetailsPlayerRecord,
			actionable: GameDetailsActionable
		) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				playerCell(for: player, actionable: actionable),
				textGridCell(
					key: "Total",
					text: record.overallRecord.asRecordFragmentFragment.formatted,
					backgroundColor: record.overallRecord.asRecordFragmentFragment.backgroundColor
				) { [weak actionable] in
					actionable?.showPlayerPlays(playerIDs: [player.id])
				},
			]

			var opponentsIndex = 0
			var gamePlayersIndex = 0

			while opponentsIndex < opponents.count {
				let columnPlayer = opponents[opponentsIndex]

				guard gamePlayersIndex < record.records.count &&
					record.records[gamePlayersIndex].opponent.id == columnPlayer.id else {
					let recordText: String
					if player.id == columnPlayer.id {
						recordText = "—"
					} else {
						recordText = Record.empty.formatted
					}
					row.append(textGridCell(key: "\(player.id)-\(columnPlayer.id)", text: recordText))
					opponentsIndex += 1
					continue
				}

				let opponent = record.records[gamePlayersIndex].opponent
				let vsRecord = record.records[gamePlayersIndex].record

				row.append(textGridCell(
					key: "\(player.id)-\(opponent.id)",
					text: vsRecord.asRecordFragmentFragment.formatted,
					backgroundColor: vsRecord.asRecordFragmentFragment.backgroundColor,
					onAction: { [weak actionable] in
						actionable?.showPlayerPlays(playerIDs: [player.id, opponent.id])
					}
				))

				opponentsIndex += 1
				gamePlayersIndex += 1
			}

			return row
		}

		static func textGridCell(
			key: String,
			text: String,
			backgroundColor: UIColor? = nil,
			onAction: (() -> Void)? = nil
		) -> GridCellConfig {
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
				state: LabelState(
					text: .attributed(NSAttributedString(string: text, textColor: .text)),
					alignment: .center
				),
				backgroundColor: backgroundColor
			)
		}

		static func playerCell(for player: Opponent, actionable: GameDetailsActionable) -> GridCellConfig {
			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(player.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(playerID: player.id)
					return .deselected
				}),
				state: ImageState(
					url: avatarURL,
					width: GameDetailsBuilder.avatarImageSize,
					height: GameDetailsBuilder.avatarImageSize,
					rounded: true
				)
			)
		}
	}

	private struct SpreadsheetConfigs {
		static func rows(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.RowConfig] {
			var rowConfigs: [Int: Spreadsheet.RowConfig] = [:]
			cells.enumerated().forEach { index, _ in
				let topBorder = index == 0 ? Spreadsheet.BorderConfig(color: .standingsBorder) : nil
				rowConfigs[index] = Spreadsheet.CommonRowConfig(
					rowHeight: 48,
					topBorder: topBorder,
					bottomBorder: Spreadsheet.BorderConfig(color: .standingsBorder)
				)
			}
			return rowConfigs
		}

		static func columns(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.ColumnConfig] {
			var columnConfigs: [Int: Spreadsheet.ColumnConfig] = [:]
			cells.first?.enumerated().forEach { index, _ in
				let leftBorder = index == 0 ? Spreadsheet.BorderConfig(color: .standingsBorder) : nil
				columnConfigs[index] = Spreadsheet.ColumnConfig(
					columnWidth: 96,
					leftBorder: leftBorder,
					rightBorder: Spreadsheet.BorderConfig(color: .standingsBorder)
				)
			}
			return columnConfigs
		}
	}
}
