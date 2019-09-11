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
	func showPlays(games: [Game], players: [Player])
}

struct PlayerDetailsBuilder {
	private static let avatarImageSize: CGFloat = 32
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter
	}()

	static func sections(player: Player, records: [Game: PlayerStandings?], players: [Player], plays: [GamePlay], builder: SpreadsheetBuilder, actionable: PlayerDetailsActionable) -> [TableSection] {
		let visiblePlayers = players.filter { player in
			return records.first(where: { $0.value?.records[player.id] != nil }) != nil
		}

		var sections: [TableSection] = [
			profileSection(player: player),
		]

		sections.append(contentsOf: scoreSections(records: records, actionable: actionable))
		sections.append(recordsSection(player: player, records: records, players: visiblePlayers, builder: builder, actionable: actionable))
		sections.append(playsSection(games: records.keys.sorted(), player: player, players: players, plays: plays, actionable: actionable))

		return sections
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

	private static func scoreSections(records: [Game: PlayerStandings?], actionable: PlayerDetailsActionable) -> [TableSection] {
		var sections: [TableSection] = []
		records.keys.sorted().forEach { game in
			if let optionalStandings = records[game], let score = optionalStandings?.scoreStats {
				let rows: [CellConfigType] = [
					GameListItemCell(
						key: "Game-\(game.id)",
						style: CellStyle(highlight: true, backgroundColor: .primaryLight),
						actions: CellActions(selectionAction: { [weak actionable] _ in
							actionable?.selectedGame(game: game)
							return .deselected
						}),
						state: GameListItemState(name: "\(game.name) Scores", image: game.image),
						cellUpdater: GameListItemState.updateView
					),
					ScoreCell(
						key: "Score",
						state: ScoreCellState(bestScore: score.best, worstScore: score.worst, averageScore: score.average),
						cellUpdater: ScoreCellState.updateView
					)
				]

				sections.append(TableSection(key: "Score-\(game.id)", rows: rows))
			}
		}

		return sections
	}

	private static func recordsSection(player: Player, records: [Game: PlayerStandings?], players: [Player], builder: SpreadsheetBuilder, actionable: PlayerDetailsActionable) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "Header", title: "Records")
		]
		var spreadsheetCells: [[GridCellConfig]] = []

		spreadsheetCells.append(SpreadsheetCells.headerRow(players: players, actionable: actionable))

		records.keys.sorted().forEach {
			if let optionalPlayerStandings = records[$0], let playerStandings = optionalPlayerStandings {
				spreadsheetCells.append(SpreadsheetCells.gameRow(game: $0, player: player, players: players, record: playerStandings, actionable: actionable))
			}
		}

		let rowConfigs = SpreadsheetConfigs.rows(cells: spreadsheetCells)
		let columnConfigs = SpreadsheetConfigs.columns(cells: spreadsheetCells)
		let config = Spreadsheet.Config(rows: rowConfigs, columns: columnConfigs, cells: spreadsheetCells, border: nil)

		if let spreadsheet = Spreadsheet.section(key: "PlayerRecord-\(player.id)", builder: builder, config: config) {
			rows.append(contentsOf: spreadsheet.rows)
		}

		return TableSection(key: "Records", rows: rows)
	}

	private static func playsSection(games: [Game], player: Player, players: [Player], plays: [GamePlay], actionable: PlayerDetailsActionable) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.sectionHeader(key: "MostRecentPlays", title: "Most Recent Plays", action: "View All") { [weak actionable] in
				actionable?.showPlays(games: [], players: [player])
			}
		]

		var lastDatePlayed: Date?
		plays.prefix(3).forEach {
			if let playCell = Cells.playCell(for: $0, games: games, player: player, players: players, actionable: actionable) {
				if let date = $0.playedOnDay, date != lastDatePlayed {
					rows.append(Cells.dateCell(for: date))
					lastDatePlayed = date
				}
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

		static func playCell(for play: GamePlay, games: [Game], player: Player, players: [Player], actionable: PlayerDetailsActionable) -> CellConfigType? {
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }),
				let game = games.first(where: { $0.id == play.game }) else { return nil }

			let opponent: Player
			var playerScore: Int?
			var opponentScore: Int?
			if firstPlayer == player {
				opponent = secondPlayer
				if let scores = play.scores, scores.count >= 2 {
					playerScore = scores[0]
					opponentScore = scores[1]
				}
			} else {
				opponent = firstPlayer
				if let scores = play.scores, scores.count >= 2 {
					playerScore = scores[1]
					opponentScore = scores[0]
				}
			}

			return PlayerGamePlayCell(
				key: "Play-\(play.id)",
				state: PlayerGamePlayState(game: game, playerID: player.id, opponent: opponent, winners: play.winners, playerScore: playerScore, opponentScore: opponentScore),
				cellUpdater: PlayerGamePlayState.updateView
			)
		}

		static func dateCell(for date: Date) -> CellConfigType {
			let dateString = PlayerDetailsBuilder.dateFormatter.string(from: date)
			return LabelCell(
				key: "Date-\(dateString)",
				state: LabelState(text: .attributed(NSAttributedString(string: dateString, textColor: .textSecondary)), size: Metrics.Text.caption),
				cellUpdater: LabelState.updateView
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

		static func gameRow(game: Game, player: Player, players: [Player], record: PlayerStandings, actionable: PlayerDetailsActionable) -> [GridCellConfig] {
			var row: [GridCellConfig] = [
				gameCell(for: game, actionable: actionable),
				textGridCell(key: "Total", text: record.overallRecord.formatted, backgroundColor: record.overallRecord.backgroundColor) { [weak actionable] in
					actionable?.showPlays(games: [game], players: [])
				},
			]

			players.forEach { opponent in
				if let recordAgainstOpponent = record.records[opponent.id] {
					row.append(textGridCell(key: "Opponent-\(opponent.id)", text: recordAgainstOpponent.formatted, backgroundColor: recordAgainstOpponent.backgroundColor) { [weak actionable] in
						actionable?.showPlays(games: [game], players: [player, opponent])
					})
				} else {
					row.append(textGridCell(key: "Opponent-\(opponent.id)", text: Record(wins: 0, losses: 0, ties: 0, isBest: nil, isWorst: nil).formatted))
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
				state: ImageState(url: avatarURL, width: PlayerDetailsBuilder.avatarImageSize, height: PlayerDetailsBuilder.avatarImageSize, rounded: true)
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
				state: ImageState(url: imageURL, width: PlayerDetailsBuilder.avatarImageSize, height: PlayerDetailsBuilder.avatarImageSize, rounded: false)
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
