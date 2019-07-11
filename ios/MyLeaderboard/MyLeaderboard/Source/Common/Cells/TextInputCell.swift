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

class TextInputCellView: UITextField, UITextFieldDelegate {
	fileprivate var onUpdate: ((String?) -> Void)? = nil

	fileprivate func prepareForReuse() {
		self.text = nil
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		onUpdate?(self.text)
		return true
	}
}

struct TextInputCellState: Equatable {
	let text: String
	let placeholder: String
	let onUpdate: (String?) -> Void

	static func updateView(_ view: TextInputCellView, state: TextInputCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.text = state.text
		view.placeholder = state.placeholder
		view.onUpdate = state.onUpdate
	}

	static func ==(lhs: TextInputCellState, rhs: TextInputCellState) -> Bool {
		return lhs.text == rhs.text
	}
}
