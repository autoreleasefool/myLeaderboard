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
	enum Keys: String {
		case createGameSection
		enum Create: String {
			case name
			case error
		}
	}

	static func sections(gameName: String, errors: KeyedErrors, actionable: CreateGameActionable) -> [TableSection] {
		var rows: [CellConfigType] = [
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

		if let errorMessage = errors[Keys.createGameSection.rawValue, Keys.Create.error.rawValue] {
			rows.append(LabelCell(
				key: Keys.Create.error,
				style: CellStyle(backgroundColor: .primaryDark),
				state: LabelState(text: .attributed(NSAttributedString(string: errorMessage, textColor: .error)), size: Metrics.Text.caption),
				cellUpdater: LabelState.updateView
			))
		}

		return [TableSection(key: Keys.createGameSection, rows: rows)]
	}
}
