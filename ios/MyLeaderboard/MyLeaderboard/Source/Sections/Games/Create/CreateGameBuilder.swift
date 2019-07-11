//
//  CreateGameBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-10.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol CreateGameActionable: AnyObject {
	func updatedGameName(name: String)
}

struct CreateGameBuilder {
	static func sections(gameName: String, actionable: CreateGameActionable) -> [TableSection] {
		let rows: [CellConfigType] = [
			TextInputCell(
				key: "gameName",
				state: TextInputCellState(
					text: gameName,
					placeholder: "Name",
					onUpdate: { [weak actionable] text in
						guard let text = text else { return }
						actionable?.updatedGameName(name: text)
					}
				),
				cellUpdater: TextInputCellState.updateView
			),
		]

		return [TableSection(key: "createGame", rows: rows)]
	}
}
