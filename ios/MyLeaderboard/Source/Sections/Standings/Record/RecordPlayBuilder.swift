//
//  RecordPlayBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-31.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol RecordPlayActionable: AnyObject {
	func openPlayerPicker()
	func openGamePicker()
	func selectWinner(_ player: GraphID, selected: Bool)
	func setScore(for player: GraphID, score: Int)
}

enum RecordPlayBuilder {
	enum Keys: String {
		case gameSection
		enum Game: String {
			case header
			case selectedGame
			case error
		}

		case playerSection
		enum Players: String {
			case header
			case selectedPlayer
			case error
			case hint
		}
	}

	static func sections(
		game: GameListItem?,
		players: [PlayerListItem],
		winners: Set<GraphID>,
		scores: [GraphID: Int],
		errors: KeyedErrors,
		actionable: RecordPlayActionable
	) -> [TableSection] {
		let sections: [TableSection] = [
			gameSection(game: game, errors: errors, actionable: actionable),
			playerSection(
				players: players,
				winners: winners,
				hasScores: game?.hasScores ?? true,
				scores: scores,
				errors: errors,
				actionable: actionable
			),
		]

		return sections
	}

	static func gameSection(
		game: GameListItem?,
		errors: KeyedErrors,
		actionable: RecordPlayActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			sectionHeader(key: Keys.Game.header, title: "Game"),
			GameListItemCell(
				key: Keys.Game.selectedGame,
				style: CellStyle(highlight: true, accessoryType: .disclosureIndicator),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.openGamePicker()
					return .deselected
				}),
				state: GameListItemState(name: game?.name ?? "No game chosen", image: game?.image),
				cellUpdater: GameListItemState.updateView
			),
		]

		if let errorMessage = errors[Keys.gameSection.rawValue, Keys.Game.error.rawValue] {
			rows.append(LabelCell(
				key: Keys.Game.error,
				style: CellStyle(backgroundColor: .primaryDark),
				state: LabelState(
					text: .attributed(NSAttributedString(string: errorMessage, textColor: .error)),
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			))
		}

		return TableSection(key: Keys.gameSection, rows: rows)
	}

	static func playerSection(
		players: [PlayerListItem],
		winners: Set<GraphID>,
		hasScores: Bool,
		scores: [GraphID: Int],
		errors: KeyedErrors,
		actionable: RecordPlayActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			sectionHeader(key: Keys.Players.header, title: "Players", action: "Edit") { [weak actionable] in
				actionable?.openPlayerPicker()
			},
		]

		players.forEach { player in
			let score = scores[player.id] ?? 0
			let isWinner = winners.contains(player.id)

			rows.append(
				PlayerPlayCell(
					key: "\(Keys.Players.selectedPlayer)-\(player.id)",
					style: CellStyle(highlight: true),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.selectWinner(player.graphID, selected: !isWinner)
						return .deselected
					}),
					state: PlayerPlayCellState(
						name: player.displayName,
						avatar: player.avatar,
						score: score,
						isWinner: isWinner,
						hasScores: hasScores
					) { [weak actionable] updatedScore in
						actionable?.setScore(for: player.graphID, score: updatedScore)
					},
					cellUpdater: PlayerPlayCellState.updateView)
			)
		}

		if let errorMessage = errors[Keys.playerSection.rawValue, Keys.Players.error.rawValue] {
			rows.append(LabelCell(
				key: Keys.Players.error,
				style: CellStyle(backgroundColor: .primaryDark),
				state: LabelState(
					text: .attributed(NSAttributedString(string: errorMessage, textColor: .error)),
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			))
		}

		if players.count > 0 {
			rows.append(LabelCell(
				key: Keys.Players.hint,
				style: CellStyle(backgroundColor: .primaryDark),
				state: LabelState(
					text: .attributed(NSAttributedString(
						string: "Tap a player to mark them as a winner. Choose all players to indicate a tie.",
						textColor: .textSecondary
					)),
					truncationStyle: .multiline,
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			))
		}

		return TableSection(key: Keys.playerSection, rows: rows)
	}

	static func sectionHeader<Key: RawRepresentable>(
		key: Key,
		title: String,
		action: String? = nil,
		onAction: (() -> Void)? = nil
	) -> CellConfigType where Key.RawValue == String {
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
}
