//
//  LabelState.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias LabelCell = HostCell<UILabel, LabelState, LayoutMarginsTableItemLayout>

struct LabelState: ViewState {
	let text: ControlText
	let truncationStyle: TruncationStyle
	let alignment: NSTextAlignment
	let size: CGFloat

	init(text: ControlText, truncationStyle: TruncationStyle = .truncate, alignment: NSTextAlignment = .natural, size: CGFloat = Metrics.Text.body) {
		self.text = text
		self.truncationStyle = truncationStyle
		self.alignment = alignment
		self.size = size
	}

	static func updateView(_ view: UILabel, state: LabelState?) {
		guard let state = state else {
			view.setControlText(nil)
			view.apply(truncationStyle: .truncate)
			return
		}

		view.textAlignment = state.alignment
		view.setControlText(state.text)
		view.font = view.font.withSize(state.size)
		view.apply(truncationStyle: state.truncationStyle)
	}
}
