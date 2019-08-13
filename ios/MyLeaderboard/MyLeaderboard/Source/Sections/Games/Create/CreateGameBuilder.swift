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
		let label = LabelState(text: .attributed(NSAttributedString(string: "Name", textColor: .text)))
		let input = TextInputCellState(text: gameName, placeholder: "Patchwork") { [weak actionable] text in
			guard let text = text else { return }
			actionable?.updatedGameName(name: text)
		}

		var rows: [CellConfigType] = [
			CombinedCell<UILabel, LabelState, TextInputCellView, TextInputCellState, LayoutMarginsTableItemLayout>(
				key: Keys.Create.name.rawValue,
				state: CombinedState(state1: label, state2: input),
				cellUpdater: { view, state in
					if state == nil {
						view.view1.setContentHuggingPriority(.defaultHigh, for: .horizontal)
						view.stackView.spacing = 0
					} else {
						view.view1.setContentHuggingPriority(.required, for: .horizontal)
						view.stackView.spacing = Metrics.Spacing.small
					}

					CombinedState<LabelState, TextInputCellState>.updateView(view, state: state)
				}
			)
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
