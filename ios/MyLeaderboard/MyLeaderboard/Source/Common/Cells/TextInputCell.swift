//
//  TextInputCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-10.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias TextInputCell = HostCell<TextInputCellView, TextInputCellState, LayoutMarginsTableItemLayout>

class TextInputCellView: UITextField {
	fileprivate func prepareForReuse() {
		text = nil
		setActions([])
	}
}

struct TextInputCellState: ViewState {
	let text: String
	let placeholder: String
	let onUpdate: (String?) -> Void

	static func updateView(_ view: TextInputCellView, state: TextInputCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.text = state.text
		let placeholder = NSAttributedString(string: state.placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.textSecondary])
		view.attributedPlaceholder = placeholder
		view.setActions([
			ControlAction(events: .editingChanged) { sender in
				guard let text = sender.text else { return }
				state.onUpdate(text)
			}])
	}

	static func == (lhs: TextInputCellState, rhs: TextInputCellState) -> Bool {
		return lhs.text == rhs.text
	}
}
