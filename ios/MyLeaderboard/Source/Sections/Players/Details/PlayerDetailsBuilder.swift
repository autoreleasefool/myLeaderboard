//
//  PlayerDetailsBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol PlayerDetailsActionable: AnyObject {
	func selectedGame(gameID: GraphID)
	func selectedPlayer(playerID: GraphID)
	func showPlays(gameID: GraphID?, playerIDs: [GraphID])
}

enum PlayerDetailsBuilder {
	private static let avatarImageSize: CGFloat = 32
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter
	}()

	static func sections(
		player: PlayerDetails,
		players: [Opponent],
		records: [PlayerDetailsRecord],
		recentPlays: [RecentPlay],
		builder: SpreadsheetBuilder,
		actionable: PlayerDetailsActionable
	) -> [TableSection] {
		var sections: [TableSection] = [
			profileSection(player: player),
		]

		sections.append(contentsOf: scoreSections(records: records, actionable: actionable))
		sections.append(recordsSection(
			player: player,
			players: players,
			records: records,
			builder: builder,
			actionable: actionable
		))
		sections.append(recentPlaysSection(player: player, plays: recentPlays, actionable: actionable))

		return sections
	}

	private static func profileSection(player: PlayerDetails) -> TableSection {
		let avatarURL: URL?
		if let avatar = player.avatar {
			avatarURL = URL(string: avatar)
		} else {
			avatarURL = nil
		}

		let rows: [CellConfigType] = [
			ImageCell(
				key: "Avatar",
				state: ImageState(
					url: avatarURL,
					width: Metrics.Image.large,
					height: Metrics.Image.large,
					rounded: true
				),
				cellUpdater: ImageState.updateImageView
			),
		]

		return TableSection(key: "Profile", rows: rows)
	}

	private static func scoreSections(
		records: [PlayerDetailsRecord],
		actionable: PlayerDetailsActionable
	) -> [TableSection] {
		var sections: [TableSection] = []
		for record in records {
			guard let stats = record.scoreStats else { continue }
			let rows: [CellConfigType] = [
				GameListItemCell(
					key: "Game",
					style: CellStyle(highlight: true, backgroundColor: .primaryLight),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.selectedGame(gameID: record.game.id)
						return .deselected
					}),
					state: GameListItemState(name: "\(record.game.name) Scores", image: record.game.image),
					cellUpdater: GameListItemState.updateView
				),
				ScoreCell(
					key: "Score",
					state: ScoreCellState(bestScore: stats.best, worstScore: stats.worst, averageScore: stats.average),
					cellUpdater: ScoreCellState.updateView
				),
			]

			sections.append(TableSection(key: "Score-\(record.game.id)", rows: rows))
		}

		return sections
	}

	private static func recordsSection(
		player: PlayerDetails,
		players: [Opponent],
		records: [PlayerDetailsRecord],
		builder: SpreadsheetBuilder,
		actionable: PlayerDetailsActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "Header", title: "Records"),
		]
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(players: players, actionable: actionable))

		for record in records {
			spreadsheetCells.append(SpreadsheetCells.gameRow(
				record: record,
				playerID: player.id,
				allPlayers: players,
				actionable: actionable
			))
		}

		let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
		let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
		let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil)

		if spreadsheetCells.count > 1,
			let spreadsheet = Spreadsheet.section(key: "PlayerRecord-\(player.id)", builder: builder, config: config) {
			rows.append(contentsOf: spreadsheet.rows)
		} else {
			rows.append(Cells.emptyCell())
		}

		return TableSection(key: "Records", rows: rows)
	}

	private static func recentPlaysSection(
		player: PlayerDetails,
		plays: [RecentPlay],
		actionable: PlayerDetailsActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(
				key: "MostRecentPlays",
				title: "Most Recent Plays",
				action: "View All"
			) { [weak actionable] in
				actionable?.showPlays(gameID: nil, playerIDs: [player.id])
			},
		]

		var lastDatePlayed: Date?
		plays.prefix(3).forEach {
			if let playCell = Cells.playCell(playerID: player.id, for: $0, actionable: actionable) {
				if let date = $0.playedOnDay, date != lastDatePlayed {
					rows.append(Cells.dateCell(for: date))
					lastDatePlayed = date
				}
				rows.append(playCell)
			}
		}

		if rows.count == 1 {
			rows.append(Cells.emptyCell())
		}

		return TableSection(key: "Plays", rows: rows)
	}

	private enum Cells {
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
			playerID: GraphID,
			for play: RecentPlay,
			actionable: PlayerDetailsActionable
		) -> CellConfigType? {
			guard let firstPlayer = play.players.first,
				let secondPlayer = play.players.last,
				firstPlayer != secondPlayer else { return nil }

			let opponent: RecentPlay.Players
			var playerScore: Int?
			var opponentScore: Int?

			if firstPlayer.id == playerID {
				opponent = secondPlayer
				playerScore = play.scores?.first
				opponentScore = play.scores?.last
			} else {
				opponent = firstPlayer
				playerScore = play.scores?.last
				opponentScore = play.scores?.first
			}

			return PlayerGamePlayCell(
				key: "Play-\(play.id)",
				state: PlayerGamePlayState(
					gameImage: play.game.image,
					playerID: playerID,
					opponentAvatar: opponent.avatar,
					winners: play.winners.map { $0.id },
					playerScore: playerScore,
					opponentScore: opponentScore
				),
				cellUpdater: PlayerGamePlayState.updateView
			)
		}

		static func dateCell(for date: Date) -> CellConfigType {
			let dateString = PlayerDetailsBuilder.dateFormatter.string(from: date)
			return LabelCell(
				key: "Date-\(dateString)",
				state: LabelState(
					text: .attributed(NSAttributedString(string: dateString, textColor: .textSecondary)),
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			)
		}

		static func emptyCell() -> CellConfigType {
			return LabelCell(
				key: "NoData",
				state: LabelState(
					text: .attributed(NSAttributedString(
						string: "There doesn't seem to be anything here 😿",
						textColor: .textSecondary
					)),
					size: Metrics.Text.body
				),
				cellUpdater: LabelState.updateView
			)
		}
	}

	private enum SpreadsheetCells {
		static func headerRow(players: [Opponent], actionable: PlayerDetailsActionable) -> [GridCellConfig] {
			var headerRow: [GridCellConfig] = [
				textGridCell(key: "Header", text: ""),
				textGridCell(key: "Total", text: "Total"),
			]

			players.forEach {
				headerRow.append(playerCell(for: $0, actionable: actionable))
			}

			return headerRow
		}

		static func gameRow(
			record: PlayerDetailsRecord,
			playerID: GraphID,
			allPlayers: [Opponent],
			actionable: PlayerDetailsActionable
		) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				gameCell(for: record.game, actionable: actionable),
				textGridCell(
					key: "Total",
					text: record.overallRecord.asRecordFragmentFragment.formatted,
					backgroundColor: record.overallRecord.asRecordFragmentFragment.backgroundColor,
					onAction: { [weak actionable] in
						actionable?.showPlays(gameID: record.game.id, playerIDs: [])
					}
				),
			]

			var allPlayersIndex = 0
			var gamePlayersIndex = 0

			while allPlayersIndex < allPlayers.count {
				let columnPlayer = allPlayers[allPlayersIndex]

				guard gamePlayersIndex < record.records.count &&
					record.records[gamePlayersIndex].opponent.id == columnPlayer.id else {
					row.append(textGridCell(key: "Opponent-\(columnPlayer.id)", text: Record.empty.formatted))
					allPlayersIndex += 1
					continue
				}

				let opponent = record.records[gamePlayersIndex].opponent
				let vsRecord = record.records[gamePlayersIndex].record

				row.append(textGridCell(
					key: "Opponent-\(opponent.id)",
					text: vsRecord.asRecordFragmentFragment.formatted,
					backgroundColor: vsRecord.asRecordFragmentFragment.backgroundColor,
					onAction: { [weak actionable] in
						actionable?.showPlays(gameID: record.game.id, playerIDs: [playerID, opponent.id])
					}
				))

				allPlayersIndex += 1
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

		static func playerCell(for player: Opponent, actionable: PlayerDetailsActionable) -> GridCellConfig {
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
					width: PlayerDetailsBuilder.avatarImageSize,
					height: PlayerDetailsBuilder.avatarImageSize, rounded: true
				)
			)
		}

		static func gameCell(
			for game: PlayerDetailsRecord.Game,
			actionable: PlayerDetailsActionable
		) -> GridCellConfig {
			let imageURL: URL?
			if let image = game.image {
				imageURL = URL(string: image)
			} else {
				imageURL = nil
			}

			return Spreadsheet.ImageGridCellConfig(
				key: "Game-\(game.id)",
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.selectedGame(gameID: game.id)
					return .deselected
				}),
				state: ImageState(
					url: imageURL,
					width: PlayerDetailsBuilder.avatarImageSize,
					height: PlayerDetailsBuilder.avatarImageSize,
					rounded: false
				)
			)
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
					columnWidth: 96, leftBorder: leftBorder,
					rightBorder: Spreadsheet.BorderConfig(color: .standingsBorder)
				)
			}
			return columnConfigs
		}
	}
}
