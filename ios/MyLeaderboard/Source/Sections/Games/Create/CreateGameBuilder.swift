//
//  CreateGameBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-10.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol CreateGameActionable: AnyObject {
	func updatedGameName(name: String)
	func updatedHasScores(hasScores: Bool)
}

struct CreateGameBuilder {
	enum Keys: String {
		case createGameSection
		enum Create: String {
			case name
			case hasScores
			case error
		}
	}

	static func sections(gameName: String, hasScores: Bool, errors: KeyedErrors, actionable: CreateGameActionable) -> [TableSection] {
		let nameLabel = LabelState(text: .attributed(NSAttributedString(string: "Name", textColor: .text)))
		let nameInput = TextInputCellState(text: gameName, placeholder: "Patchwork") { [weak actionable] text in
			guard let text = text else { return }
			actionable?.updatedGameName(name: text)
		}

		let hasScoresLabel = LabelState(text: .attributed(NSAttributedString(string: "Has scores?", textColor: .text)))
		let hasScoresSwitch = SwitchState(isOn: hasScores) { [weak actionable] isOn in
			actionable?.updatedHasScores(hasScores: isOn)
		}

		var rows: [CellConfigType] = [
			CombinedCell<UILabel, LabelState, TextInputCellView, TextInputCellState, LayoutMarginsTableItemLayout>(
				key: Keys.Create.name.rawValue,
				state: CombinedState(state1: nameLabel, state2: nameInput),
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
			),
			SwitchCell(
				key: Keys.Create.hasScores.rawValue,
				state: CombinedState(state1: hasScoresLabel, state2: hasScoresSwitch),
				cellUpdater: { view, state in
					CombinedState<LabelState, SwitchState>.updateView(view, state: state)
				}
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
