//
//  ChangeBoardBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import FunctionalTableData
import myLeaderboardApi
import UIKit

protocol ChangeBoardActionable: AnyObject {
	func updatedBoardName(to name: String)
	func findBoard(withName name: String)
	func joinBoard(withName name: String)
	func createBoard(withName name: String)
	func openPublicBoard()
}

enum ChangeBoardBuilder {
	static func sections(
		boardName: String,
		boardState: BoardState,
		actionable: ChangeBoardActionable
	) -> [TableSection] {
		return [
			inputSection(boardName: boardName, boardState: boardState, actionable: actionable),
			publicBoardSection(actionable: actionable),
		]
	}

	static func inputSection(
		boardName: String,
		boardState: BoardState,
		actionable: ChangeBoardActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			LabelCell(
				key: "introduction",
				style: CellStyle(bottomSeparator: .full, separatorColor: .separator),
				state: LabelState(
					text: .plain("To start using MyLeaderboard, first you'll need to select a Board to " +
								"participate in. You can join an existing Board, if you know its name, or " +
								"create your own below."
					),
					textColor: .text,
					truncationStyle: .multiline,
					alignment: .center
				),
				cellUpdater: LabelState.updateView
			),
			TextInputCell(
				key: "board-name",
				state: TextInputCellState(
					text: boardName,
					placeholder: "Board"
				) { [weak actionable] text in
					guard let text = text else { return }
					actionable?.updatedBoardName(to: text)
				},
				cellUpdater: TextInputCellState.updateView
			),
		]

		switch boardState {
		case .isCreatable:
			rows.append(LabelCell(
				key: "create-board",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					guard boardState == .isCreatable else { return .deselected }
					actionable?.createBoard(withName: boardName)
					return .deselected
				}),
				state: LabelState(
					text: .plain("Create"),
					textColor: .textAction,
					alignment: .center,
					size: Metrics.Text.action
				),
				cellUpdater: LabelState.updateView
			))
		case .isJoinable:
			rows.append(LabelCell(
				key: "join-board",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					guard boardState == .isJoinable else { return .deselected }
					actionable?.joinBoard(withName: boardName)
					return .deselected
				}),
				state: LabelState(
					text: .plain("Join"),
					textColor: .textAction,
					alignment: .center,
					size: Metrics.Text.action
				),
				cellUpdater: LabelState.updateView
			))
		case .undetermined:
			if boardName.count > 0 {
				rows.append(LabelCell(
					key: "check-board",
					style: CellStyle(highlight: true),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.findBoard(withName: boardName)
						return .deselected
					}),
					state: LabelState(
						text: .plain("Check for board"),
						textColor: .textAction,
						alignment: .center,
						size: Metrics.Text.action
					),
					cellUpdater: LabelState.updateView
				))
			}
		}

		return TableSection(key: "Input", rows: rows)
	}

	static func publicBoardSection(actionable: ChangeBoardActionable) -> TableSection {
		let rows: [CellConfigType] = [
			LabelCell(
				key: "public-board-info",
				style: CellStyle(topSeparator: .full, separatorColor: .separator),
				state: LabelState(
					text: .plain("If you don't need your own private board, you can join the 'Public' board below."),
					textColor: .text,
					truncationStyle: .multiline,
					alignment: .center,
					size: Metrics.Text.body
				),
				cellUpdater: LabelState.updateView
			),
			LabelCell(
				key: "join-public-board",
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.openPublicBoard()
					return .deselected
				}),
				state: LabelState(
					text: .plain("Join 'Public' board"),
					textColor: .textAction,
					alignment: .center,
					size: Metrics.Text.action
				),
				cellUpdater: LabelState.updateView
			),
		]

		return TableSection(key: "Public", rows: rows)
	}
}
