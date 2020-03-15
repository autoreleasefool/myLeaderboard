//
//  StandingsListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol StandingsListActionable: AnyObject {
	func selectedPlayer(playerID: GraphID)
	func selectedGame(gameID: GraphID)
	func showPlays(gameID: GraphID, playerIDs: [GraphID])
}

enum StandingsListBuilder {
	private static let avatarImageSize: CGFloat = 32

	static func sections(
		games: [StandingsGame],
		standings: [StandingsGame: StandingsFragment],
		builder: SpreadsheetBuilder,
		actionable: StandingsListActionable
	) -> [TableSection] {
		var sections: [TableSection] = []

		games.forEach { game in
			var rows: [CellConfigType] = [
				Cells.gameHeader(for: game, actionable: actionable),
			]

			var spreadsheetCells: [[GridCellConfig]] = []
			if let gameStandings = standings[game] {
				spreadsheetCells = standingsRows(
					game: game,
					standings: gameStandings,
					actionable: actionable
				)
			}

			var hasRecentPlays: Bool = false
			if spreadsheetCells.count > 1 {
				let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
				let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
				let config = Spreadsheet.Config(
					rows: rowConfigs,
					columns: columnConfigs,
					cells: spreadsheetCells,
					border: nil
				)

				if let spreadsheet = Spreadsheet.section(
					key: "StandingsList-\(game.id)",
					builder: builder,
					config: config
				) {
					rows.append(contentsOf: spreadsheet.rows)
				}
				hasRecentPlays = true
			} else {
				rows.append(LabelCell(
					key: "no-recent-plays",
					state: LabelState(
						text: .attributed(NSAttributedString(string: "No recent plays", textColor: .text)),
						size: Metrics.Text.title
					),
					cellUpdater: LabelState.updateView
				))
			}

			sections.append(TableSection(key: "game-\(game.id)", rows: rows))

			if hasRecentPlays,
				let gameStandings = standings[game] {
				if let limbo = limboSection(
					forGame: game,
					players: Players.limboing(from: gameStandings),
					actionable: actionable
				) {
					sections.append(limbo)
				}

				if let banished = banishedSection(
					forGame: game,
					players: Players.banished(from: gameStandings),
					actionable: actionable
				) {
					sections.append(banished)
				}
			}
		}

		return sections
	}

	private static func standingsRows(
		game: StandingsGame,
		standings: StandingsFragment,
		actionable: StandingsListActionable
	) -> [[GridCellConfig]] {
		var spreadsheetCells: [[GridCellConfig]] = []
		let visiblePlayerRecords = PlayerRecords.visible(from: standings)

		var headerRow: [GridCellConfig] = [
			SpreadsheetCells.textGridCell(key: "Header", text: ""),
			SpreadsheetCells.textGridCell(key: "Total", text: "Total"),
		]
		visiblePlayerRecords.forEach {
			headerRow.append(SpreadsheetCells.playerCell(for: $0, actionable: actionable))
		}
		spreadsheetCells.append(headerRow)

		visiblePlayerRecords.forEach { playerRecord in
			let player = playerRecord.player.asOpponentFragmentFragment
			var cells: [GridCellConfig] = [
				SpreadsheetCells.playerCell(for: playerRecord, actionable: actionable),
				SpreadsheetCells.textGridCell(
					key: "Total",
					text: playerRecord.record.overallRecord.asRecordFragmentFragment.formatted,
					backgroundColor: playerRecord.record.overallRecord.asRecordFragmentFragment.backgroundColor
				) { [weak actionable] in
					actionable?.showPlays(gameID: game.id, playerIDs: [player.id])
				},
			]

			func addEmptyRecordCell(forPlayer opponent: Opponent) {
				let recordText: String
				if player.id == opponent.id {
					recordText = "—"
				} else {
					recordText = RecordFragment.empty.formatted
				}
				cells.append(SpreadsheetCells.textGridCell(
					key: "\(player.id)-\(opponent.id)",
					text: recordText
				))
			}

			var visiblePlayerIndex = 0
			var opponentIndex = 0

			while visiblePlayerIndex < visiblePlayerRecords.count {
				let columnPlayer = visiblePlayerRecords[visiblePlayerIndex].player.asOpponentFragmentFragment

				guard opponentIndex < playerRecord.record.records.count else {
					addEmptyRecordCell(forPlayer: columnPlayer)
					visiblePlayerIndex += 1
					continue
				}

				let opponent = playerRecord.record.records[opponentIndex].opponent.asOpponentFragmentFragment
				let record = playerRecord.record.records[opponentIndex].record.asRecordFragmentFragment

				guard opponent.id == columnPlayer.id else {
					if opponent.id < columnPlayer.id {
						opponentIndex += 1
					} else {
						addEmptyRecordCell(forPlayer: columnPlayer)
						visiblePlayerIndex += 1
					}
					continue
				}

				cells.append(SpreadsheetCells.textGridCell(
					key: "\(player.id)-\(opponent.id)",
					text: record.formatted,
					backgroundColor: record.backgroundColor
				) { [weak actionable] in
					actionable?.showPlays(gameID: game.id, playerIDs: [player.id, opponent.id])
				})

				opponentIndex += 1
				visiblePlayerIndex += 1
			}

			spreadsheetCells.append(cells)
		}

		return spreadsheetCells
	}

	private static func limboSection(
		forGame game: StandingsGame,
		players: [Opponent],
		actionable: StandingsListActionable
	) -> TableSection? {
		guard players.count > 0 else { return nil }

		var rows: [CellConfigType] = [
			Cells.subHeader(key: "LimboHeader-\(game.id)", text: "Limbo"),
		]

		let limboingPlayerRows: [CellConfigType] = players.map { Cells.playerAvatar(for: $0, actionable: actionable) }

		rows.append(CollectionViewCell(
			key: "Limbo",
			state: CollectionViewCellState(
				sections: [TableSection(key: "Limbo", rows: limboingPlayerRows)],
				itemSize: CGSize(
					width: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard,
					height: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard
				)
			),
			cellUpdater: CollectionViewCellState.updateView
		))

		return TableSection(key: "Limbo-\(game.id)", rows: rows)
	}

	private static func banishedSection(
		forGame game: StandingsGame,
		players: [Opponent],
		actionable: StandingsListActionable
	) -> TableSection? {
		guard players.count > 0 else { return nil }

		var rows: [CellConfigType] = [
			Cells.subHeader(key: "BanishedHeader-\(game.id)", text: "Shadow Realm"),
		]

		let banishedPlayerRows: [CellConfigType] = players.map { Cells.playerAvatar(for: $0, actionable: actionable) }

		rows.append(CollectionViewCell(
			key: "Banished",
			state: CollectionViewCellState(
				sections: [TableSection(key: "Banished", rows: banishedPlayerRows)],
				itemSize: CGSize(
					width: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard,
					height: StandingsListBuilder.avatarImageSize + Metrics.Spacing.standard
				)
			),
			cellUpdater: CollectionViewCellState.updateView
		))

		return TableSection(key: "Banished-\(game.id)", rows: rows)
	}

	private enum Players {
		static func banished(from standings: StandingsFragment) -> [Opponent] {
			return standings.standings.records
				.filter { $0.record.asStandingsPlayerGameRecordFragmentFragment.isBanished }
				.map { $0.player.asOpponentFragmentFragment }
		}

		static func limboing(from standings: StandingsFragment) -> [Opponent] {
			return standings.standings.records
				.filter {
					let freshnes = $0.record.asStandingsPlayerGameRecordFragmentFragment.freshness
					return freshnes > 0 && freshnes < 0.2
				}.map { $0.player.asOpponentFragmentFragment }
		}
	}

	private enum PlayerRecords {
		static func visible(from standings: StandingsFragment) -> [StandingsPlayerRecordNext] {
			return standings.standings.records
				.filter { $0.record.asStandingsPlayerGameRecordFragmentFragment.isBanished == false }
				.map { $0.asStandingsPlayerRecordFragmentFragment }
		}
	}

	private enum SpreadsheetConfigs {
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

	private enum Cells {
		static func subHeader(key: String, text: String) -> CellConfigType {
			return LabelCell(
				key: key,
				state: LabelState(
					text: .attributed(NSAttributedString(string: text, textColor: .textSecondary)),
					size: Metrics.Text.title
				),
				cellUpdater: LabelState.updateView
			)
		}

		static func gameHeader(for game: StandingsGame, actionable: StandingsListActionable) -> CellConfigType {
			return GameListItemCell(
				key: "Header",
				style: CellStyle(highlight: true, backgroundColor: .primaryLight),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedGame(gameID: game.id)
					return .deselected
				}),
				state: GameListItemState(name: game.name, image: game.image),
				cellUpdater: GameListItemState.updateView
			)
		}

		static func playerAvatar(for player: Opponent, actionable: StandingsListActionable) -> CellConfigType {
			return ImageCell(
				key: "player-\(player.id)",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(playerID: player.id)
					return .deselected
				}),
				state: playerAvatarState(for: player),
				cellUpdater: ImageState.updateImageView
			)
		}

		static func playerAvatarState(for player: Opponent, opacity: CGFloat = 1.0) -> ImageState {
			let avatarURL: URL?
			if let avatar = player.avatar {
				avatarURL = URL(string: avatar)
			} else {
				avatarURL = nil
			}

			return ImageState(
				url: avatarURL,
				width: StandingsListBuilder.avatarImageSize,
				height: StandingsListBuilder.avatarImageSize,
				rounded: true,
				opacity: opacity
			)
		}
	}

	private enum SpreadsheetCells {
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

		static func playerCell(
			for playerRecord: StandingsPlayerRecordNext,
			actionable: StandingsListActionable
		) -> GridCellConfig {
			return Spreadsheet.ImageGridCellConfig(
				key: "Avatar-\(playerRecord.player.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedPlayer(playerID: playerRecord.player.id)
					return .deselected
				}),
				state: Cells.playerAvatarState(
					for: playerRecord.player.asOpponentFragmentFragment,
					opacity: CGFloat(playerRecord.record.asStandingsPlayerGameRecordFragmentFragment.freshness)
				)
			)
		}
	}
}
