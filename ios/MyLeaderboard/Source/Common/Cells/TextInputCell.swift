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
	private static let textInsets = UIEdgeInsets(
		top: Metrics.Spacing.small,
		left: Metrics.Spacing.standard,
		bottom: Metrics.Spacing.small,
		right: Metrics.Spacing.standard
	)

	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = Metrics.Spacing.tiny
		layer.borderColor = UIColor.primaryLight.cgColor
		layer.borderWidth = 1
		backgroundColor = .primaryDark
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate func prepareForReuse() {
		text = nil
		setActions([])
	}

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.textRect(forBounds: bounds)
		return rect.inset(by: Self.textInsets)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.editingRect(forBounds: bounds)
		return rect.inset(by: Self.textInsets)
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
		let placeholder = NSAttributedString(
			string: state.placeholder,
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.textSecondary]
		)
		view.attributedPlaceholder = placeholder
		view.setActions([
			ControlAction(events: .editingChanged) { sender in
				guard let text = sender.text else { return }
				state.onUpdate(text)
			},
		])
	}

	static func == (lhs: TextInputCellState, rhs: TextInputCellState) -> Bool {
		return lhs.text == rhs.text
	}
}
