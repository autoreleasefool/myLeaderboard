//
//  TodayBuilder.swift
//  MyLeaderboardTodayExtension
//
//  Created by Joseph Roque on 2019-09-15.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit
import FunctionalTableData

protocol TodayActionable: AnyObject {
	func openStandings()
	func openPlayerDetails(player: Player)
	func openGameDetails(game: Game)
	func nextPlayer()
	func openPreferredPlayerSelection()
}

enum TodayBuilder {
	private static let avatarImageSize: CGFloat = 32

	static func sections(player: Player, standings: [Game: PlayerStandings?], players: [Player], firstPlayer: Int, builder: SpreadsheetBuilder, maxRows: Int, error: LeaderboardAPIError?, actionable: TodayActionable) -> [TableSection] {
		if let error = error {
			return [Sections.error(error, actionable: actionable)]
		}

		let visiblePlayers = Array(players.dropFirst(firstPlayer))

		var rows: [CellConfigType] = []
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(players: visiblePlayers, actionable: actionable))

		standings.keys.sorted().forEach {
			guard let optionalStandings = standings[$0], let gameStandings = optionalStandings else { return }
			spreadsheetCells.append(SpreadsheetCells.gameRow(game: $0, player: player, players: visiblePlayers, record: gameStandings, actionable: actionable))
		}

		spreadsheetCells = Array(spreadsheetCells.prefix(maxRows))

		let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
		let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
		let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil)

		if let spreadsheet = Spreadsheet.section(key: "PlayerRecord-\(player.id)", builder: builder, config: config) {
			rows.append(contentsOf: spreadsheet.rows)
		}

		return [TableSection(key: "Records", rows: rows)]
	}

	static func noPreferredPlayerSection(actionable: TodayActionable) -> [TableSection] {
		return [TableSection(
			key: "NoPreferredPlayer",
			rows: [
				LabelCell(
					key: "NoPreferredPlayer",
					style: CellStyle(highlight: true),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.openPreferredPlayerSelection()
						return .deselected
					}),
					state: LabelState(
						text: .attributed(NSAttributedString(string: "No preferred player selected. Choose one in the settings.", textColor: .text)),
						truncationStyle: .multiline,
						alignment: .center,
						size: Metrics.Text.body
					),
					cellUpdater: LabelState.updateView
				)
			]
		)]
	}

	enum Sections {
		static func error(_ error: LeaderboardAPIError, actionable: TodayActionable) -> TableSection {
			let rows: [CellConfigType] = []
			return TableSection(key: "Error", rows: rows)
		}
	}

	enum SpreadsheetCells {
		static func headerRow(players: [Player], actionable: TodayActionable) -> [GridCellConfig] {
			var headerRow: [GridCellConfig] = [
				textGridCell(key: "Header", text: ""),
				textGridCell(key: "Total", text: "Total"),
			]

			players.prefix(2).forEach {
				headerRow.append(playerCell(for: $0, actionable: actionable))
			}

			headerRow.append(textGridCell(key: "Next", text: "Next") { [weak actionable] in
				actionable?.nextPlayer()
			})

			return headerRow
		}

		static func gameRow(game: Game, player: Player, players: [Player], record: PlayerStandings, actionable: TodayActionable) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				gameCell(for: game, actionable: actionable),
				textGridCell(key: "Total", text: record.overallRecord.formatted),
			]

			players.prefix(2).forEach { opponent in
				if let recordAgainstOpponent = record.records[opponent.id] {
					row.append(textGridCell(key: "Opponent-\(opponent.id)", text: recordAgainstOpponent.formatted) { [weak actionable] in
						actionable?.openPlayerDetails(player: player)
					})
				} else {
					row.append(textGridCell(key: "Opponent-\(opponent.id)", text: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil).formatted))
				}
			}

			row.append(textGridCell(key: "Empty", text: ""))

			return row
		}

		static func textGridCell(key: String, text: String, onAction: (() -> Void)? = nil) -> GridCellConfig {
			return Spreadsheet.TextGridCellConfig(
				key: key,
				actions: CellActions(
					canSelectAction: { callback in
						callback(onAction != nil)
				},
					selectionAction: { _ in
						onAction?()
						return .deselected
				}
				),
				state: LabelState(text: .attributed(NSAttributedString(string: text, textColor: .text)), alignment: .center)
			)
		}

		static func playerCell(for player: Player, actionable: TodayActionable) -> GridCellConfig {
			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(player.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.openPlayerDetails(player: player)
					return .deselected
				}),
				state: ImageState(url: avatarURL, width: TodayBuilder.avatarImageSize, height: TodayBuilder.avatarImageSize, rounded: true)
			)
		}

		static func gameCell(for game: Game, actionable: TodayActionable) -> GridCellConfig {
			let imageURL: URL?
			if let image = game.image {
				imageURL = URL(string: image)
			} else {
				imageURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Game-\(game.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.openGameDetails(game: game)
					return .deselected
				}),
				state: ImageState(url: imageURL, width: TodayBuilder.avatarImageSize, height: TodayBuilder.avatarImageSize, rounded: false)
			)
		}
	}

	private struct SpreadsheetConfigs {
		static func rows(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.RowConfig] {
			var rowConfigs: [Int: Spreadsheet.RowConfig] = [:]
			cells.enumerated().forEach { index, _ in
				if index == 0 {
					rowConfigs[index] = Spreadsheet.CommonRowConfig(rowHeight: 48, topBorder: Spreadsheet.BorderConfig(color: .todayBorder), bottomBorder: Spreadsheet.BorderConfig(color: .todayBorder))
				} else {
					rowConfigs[index] = Spreadsheet.CommonRowConfig(rowHeight: 48, topBorder: nil, bottomBorder: Spreadsheet.BorderConfig(color: .todayBorder))
				}
			}
			return rowConfigs
		}

		static func columns(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.ColumnConfig] {
			var columnConfigs: [Int: Spreadsheet.ColumnConfig] = [:]
			cells.first?.enumerated().forEach { index, _ in
				if index == 0 {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: Spreadsheet.BorderConfig(color: .todayBorder), rightBorder: Spreadsheet.BorderConfig(color: .todayBorder))
				} else {
					columnConfigs[index] = Spreadsheet.ColumnConfig(columnWidth: 96, leftBorder: nil, rightBorder: Spreadsheet.BorderConfig(color: .todayBorder))
				}
			}
			return columnConfigs
		}
	}
}
