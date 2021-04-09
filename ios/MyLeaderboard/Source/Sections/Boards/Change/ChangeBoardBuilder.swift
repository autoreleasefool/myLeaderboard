//
//  ChangeBoardBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import FunctionalTableData
import MyLeaderboardApi
import UIKit

protocol ChangeBoardActionable: AnyObject {
	func updatedBoardName(to name: String)
	func findBoard(withName name: String)
	func createBoard(withName name: String)
	func openPublicBoard()
}

enum ChangeBoardBuilder {
	static func sections(
		boardName: String,
		actionable: ChangeBoardActionable
	) -> [TableSection] {
		let rows: [CellConfigType] = [
			LabelCell(
				key: "Introduction",
				state: LabelState(text: .plain("MyLeaderboard allows you to record")),
				cellUpdater: LabelState.updateView
			),
			TextInputCell(
				key: "BoardName",
				state: TextInputCellState(
					text: boardName,
					placeholder: "Board"
				) { [weak actionable] text in
					guard let text = text else { return }
					actionable?.updatedBoardName(to: text)
				},
				cellUpdater: TextInputCellState.updateView
			),
			ButtonCell(
				key: "JoinBoard",
				state: ButtonState(title: "Join") { [weak actionable] _ in
					actionable?.findBoard(withName: boardName)
				},
				cellUpdater: ButtonState.updateView
			),
			ButtonCell(
				key: "CreateBoard",
				state: ButtonState(title: "Create") { [weak actionable] _ in
					actionable?.createBoard(withName: boardName)
				},
				cellUpdater: ButtonState.updateView
			),
			ButtonCell(
				key: "JoinPublicBoard",
				state: ButtonState(title: "Join public board") { [weak actionable] _ in
					actionable?.openPublicBoard()
				},
				cellUpdater: ButtonState.updateView
			),
		]

		return [TableSection(key: "ChangeBoard", rows: rows)]
	}
}
