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
	func openPlayerDetails(playerID: GraphID)
	func openGameDetails(gameID: GraphID)
	func openPreferredPlayerSelection()
	func openPreferredOpponentsSelection()
}

enum TodayBuilder {
	private static let avatarImageSize: CGFloat = 32

	static func sections(
		player: Player,
		standings: [TodayViewRecord],
		opponents: [Opponent],
		builder: SpreadsheetBuilder,
		maxRows: Int,
		error: GraphAPIError?,
		actionable: TodayActionable
	) -> [TableSection] {
		if let error = error {
			return [Sections.error(error, actionable: actionable)]
		}

		var rows: [CellConfigType] = []
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(opponents: opponents, actionable: actionable))

		standings.forEach {
			spreadsheetCells.append(SpreadsheetCells.gameRow(
				player: player,
				opponents: opponents,
				record: $0,
				actionable: actionable
			))
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
		return [
			TableSection(
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
							text: .attributed(NSAttributedString(
								string: "No preferred player selected.",
								textColor: .text
							)),
							truncationStyle: .multiline,
							alignment: .center,
							size: Metrics.Text.body
						),
						cellUpdater: LabelState.updateView
					),
				]
			),
		]
	}

	static func noPreferredOpponentsSection(actionable: TodayActionable) -> [TableSection] {
		return [
			TableSection(
				key: "NoPreferredOpponents",
				rows: [
					LabelCell(
						key: "NoPreferredOpponents",
						style: CellStyle(highlight: true),
						actions: CellActions(selectionAction: { [weak actionable] _ in
							actionable?.openPreferredOpponentsSelection()
							return .deselected
						}),
						state: LabelState(
							text: .attributed(NSAttributedString(string: "No opponents selected.", textColor: .text)),
							truncationStyle: .multiline,
							alignment: .center,
							size: Metrics.Text.body
						),
						cellUpdater: LabelState.updateView
					),
				]
			),
		]
	}

	enum Sections {
		static func error(_ error: GraphAPIError, actionable: TodayActionable) -> TableSection {
			let rows: [CellConfigType] = []
			#warning("TODO: fill out error section")
			return TableSection(key: "Error", rows: rows)
		}
	}

	enum SpreadsheetCells {
		static func headerRow(opponents: [Opponent], actionable: TodayActionable) -> [GridCellConfig] {
			var headerRow: [GridCellConfig] = [
				textGridCell(key: "Header", text: ""),
				textGridCell(key: "Total", text: "Total"),
			]

			headerRow.append(contentsOf: opponents.map { playerCell(for: $0, actionable: actionable) })

			return headerRow
		}

		static func gameRow(
			player: Player,
			opponents: [Opponent],
			record: TodayViewRecord,
			actionable: TodayActionable
		) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				gameCell(for: record.game.asTodayViewGameFragmentFragment, actionable: actionable),
				textGridCell(key: "Total", text: record.overallRecord.asRecordFragmentFragment.formatted),
			]

			opponents.forEach { opponent in
				if let recordAgainstOpponent = record.records.first(where: { $0.opponent.id == opponent.id}) {
					row.append(textGridCell(
						key: "Opponent-\(opponent.id)",
						text: recordAgainstOpponent.record.asRecordFragmentFragment.formatted
					) { [weak actionable] in
						actionable?.openPlayerDetails(playerID: player.graphID)
					})
				} else {
					row.append(textGridCell(
						key: "Opponent-\(opponent.id)",
						text: Record.empty.formatted
					))
				}
			}

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
				state: LabelState(
					text: .attributed(NSAttributedString(string: text, textColor: .text)),
					alignment: .center
				)
			)
		}

		static func playerCell(for player: Opponent, actionable: TodayActionable) -> GridCellConfig {
			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(player.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.openPlayerDetails(playerID: player.id)
					return .deselected
				}),
				state: ImageState(
					url: avatarURL,
					width: TodayBuilder.avatarImageSize,
					height: TodayBuilder.avatarImageSize,
					rounded: true
				)
			)
		}

		static func gameCell(for game: TodayViewGame, actionable: TodayActionable) -> GridCellConfig {
			let imageURL: URL?
			if let image = game.image {
				imageURL = URL(string: image)
			} else {
				imageURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Game-\(game.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.openGameDetails(gameID: game.id)
					return .deselected
				}),
				state: ImageState(
					url: imageURL,
					width: TodayBuilder.avatarImageSize,
					height: TodayBuilder.avatarImageSize,
					rounded: false
				)
			)
		}
	}

	private struct SpreadsheetConfigs {
		static func rows(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.RowConfig] {
			var rowConfigs: [Int: Spreadsheet.RowConfig] = [:]
			cells.enumerated().forEach { index, _ in
				let topBorder = index == 0 ? Spreadsheet.BorderConfig(color: .todayBorder) : nil
				rowConfigs[index] = Spreadsheet.CommonRowConfig(
					rowHeight: 48,
					topBorder: topBorder,
					bottomBorder: Spreadsheet.BorderConfig(color: .todayBorder)
				)
			}
			return rowConfigs
		}

		static func columns(cells: [[GridCellConfig]]) -> [Int: Spreadsheet.ColumnConfig] {
			var columnConfigs: [Int: Spreadsheet.ColumnConfig] = [:]
			cells.first?.enumerated().forEach { index, _ in
				let leftBorder = index == 0 ? Spreadsheet.BorderConfig(color: .todayBorder) : nil
				columnConfigs[index] = Spreadsheet.ColumnConfig(
					columnWidth: 96,
					leftBorder: leftBorder,
					rightBorder: Spreadsheet.BorderConfig(color: .todayBorder)
				)
			}
			return columnConfigs
		}
	}
}
