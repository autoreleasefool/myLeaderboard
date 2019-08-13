//
//  CreatePlayerBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol CreatePlayerActionable: AnyObject {
	func updatedPlayerName(name: String)
	func updatedPlayerUsername(username: String)
}

struct CreatePlayerBuilder {
	enum Keys: String {
		case createPlayerSection
		enum Create: String {
			case header
			case displayName
			case username
			case error
		}
		case previewSection
		enum Preview: String {
			case header
			case avatar
		}
	}

	static func sections(displayName: String, username: String, errors: KeyedErrors, actionable: CreatePlayerActionable) -> [TableSection] {
		return [
			inputSection(displayName: displayName, username: username, errors: errors, actionable: actionable),
			previewSection(username: username),
		]
	}

	static func inputSection(displayName: String, username: String, errors: KeyedErrors, actionable: CreatePlayerActionable) -> TableSection {
		let displayNameLabel = LabelState(text: .attributed(NSAttributedString(string: "Name", textColor: .text)))
		let displayNameInput = TextInputCellState(text: displayName, placeholder: "Joseph Roque") { [weak actionable] text in
			guard let text = text else { return }
			actionable?.updatedPlayerName(name: text)
		}

		let usernameLabel = LabelState(text: .attributed(NSAttributedString(string: "Username", textColor: .text)))
		let usernameInput = TextInputCellState(text: username, placeholder: "josephroquedev") { [weak actionable] text in
			guard let text = text else { return }
			actionable?.updatedPlayerUsername(username: text)
		}

		var rows: [CellConfigType] = [
			sectionHeader(key: Keys.Create.header, title: "Details"),
			CombinedCell<UILabel, LabelState, TextInputCellView, TextInputCellState, LayoutMarginsTableItemLayout>(
				key: Keys.Create.displayName.rawValue,
				state: CombinedState(state1: displayNameLabel, state2: displayNameInput),
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
			CombinedCell<UILabel, LabelState, TextInputCellView, TextInputCellState, LayoutMarginsTableItemLayout>(
				key: Keys.Create.username.rawValue,
				state: CombinedState(state1: usernameLabel, state2: usernameInput),
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

		if let errorMessage = errors[Keys.createPlayerSection.rawValue, Keys.Create.error.rawValue] {
			rows.append(LabelCell(
				key: Keys.Create.error,
				style: CellStyle(backgroundColor: .primaryDark),
				state: LabelState(text: .attributed(NSAttributedString(string: errorMessage, textColor: .error)), size: Metrics.Text.caption),
				cellUpdater: LabelState.updateView
			))
		}

		return TableSection(key: Keys.createPlayerSection, rows: rows)
	}

	static func previewSection(username: String) -> TableSection {
		let rows: [CellConfigType] = [
			sectionHeader(key: Keys.Preview.header, title: "Preview"),
			ImageCell(
				key: Keys.Preview.avatar.rawValue,
				state: ImageState(url: avatarUrl(for: username), width: Metrics.Image.large, height: Metrics.Image.large, rounded: true),
				cellUpdater: ImageState.updateView
			),
		]

		return TableSection(key: Keys.previewSection, rows: rows)
	}

	static func avatarUrl(for username: String) -> URL? {
		guard username.count > 0 else { return nil }
		return URL(string: "https://github.com/\(username).png")
	}

	static func sectionHeader<Key: RawRepresentable>(key: Key, title: String) -> CellConfigType where Key.RawValue == String {
		return LabelCell(
			key: key,
			style: CellStyle(backgroundColor: .primaryLight),
			state: LabelState(text: .attributed(NSAttributedString(string: title, textColor: .text)), size: Metrics.Text.title),
			cellUpdater: LabelState.updateView
		)
	}
}
